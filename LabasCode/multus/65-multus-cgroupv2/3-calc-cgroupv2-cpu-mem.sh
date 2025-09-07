#!/bin/bash
# pod-cg-inspect-fixed.sh
# Robust version: inspect cgroup v2 CPU/Memory usage (anon from memory.stat).
# Default: 6 samples of 5s each. Compute percent relative to cgroup cpu.max (pod pinned CPU).
# Usage examples:
#   ./pod-cg-inspect-fixed.sh
#   ./pod-cg-inspect-fixed.sh -i 2 -n 10
#   ./pod-cg-inspect-fixed.sh -w
set -euo pipefail

PROGNAME=$(basename "$0")
INTERVAL=5
SAMPLES=6
WATCH=0

usage() {
  cat <<EOF
Usage: $PROGNAME [-i interval_seconds] [-n samples] [-w] [-h]
  -i INTERVAL   Sampling interval in seconds (integer, default: 5)
  -n SAMPLES    Number of samples per run (integer, default: 6)
  -w            Watch mode: repeat runs until interrupted (Ctrl-C)
  -h            Show this help
Examples:
  $PROGNAME
  $PROGNAME -i 2 -n 10
  $PROGNAME -w
EOF
  exit 1
}

# parse options robustly
while getopts ":i:n:wh" opt; do
  case "$opt" in
    i) INTERVAL="${OPTARG}" ;;
    n) SAMPLES="${OPTARG}" ;;
    w) WATCH=1 ;;
    h) usage ;;
    \:) echo "ERROR: Option -$OPTARG requires an argument." >&2; usage ;;
    \?) echo "ERROR: Invalid option: -$OPTARG" >&2; usage ;;
  esac
done

# validate numeric args
is_positive_int() {
  [[ "$1" =~ ^[1-9][0-9]*$ ]]
}

if ! is_positive_int "$INTERVAL"; then
  echo "ERROR: interval (-i) must be a positive integer, got: '$INTERVAL'" >&2
  usage
fi
if ! is_positive_int "$SAMPLES"; then
  echo "ERROR: samples (-n) must be a positive integer, got: '$SAMPLES'" >&2
  usage
fi

# locate cgroup v2 path
cg_mount(){ awk '$3=="cgroup2"{print $2; exit}' /proc/mounts || echo "/sys/fs/cgroup"; }
cg_rel(){ awk -F: '$1=="0"{print $3; exit}' /proc/self/cgroup || echo "/"; }
MOUNT=$(cg_mount)
REL=$(cg_rel)
if [[ "$REL" == "/" ]]; then CGPATH="$MOUNT"; else CGPATH="${MOUNT%/}${REL}"; fi

# readers
read_cpu_usage(){ awk '/^usage_usec/ {print $2; exit}' "$CGPATH/cpu.stat" 2>/dev/null || echo 0; }
read_cpu_max_raw(){ cat "$CGPATH/cpu.max" 2>/dev/null || echo "max 100000"; }
read_mem_anon(){ awk '/^anon/ {print $2; exit}' "$CGPATH/memory.stat" 2>/dev/null || echo 0; }
read_mem_max(){ cat "$CGPATH/memory.max" 2>/dev/null || echo max; }
host_mem_bytes(){ awk '/^MemTotal:/{print $2*1024; exit}' /proc/meminfo || echo 0; }
node_cpus(){ nproc --all 2>/dev/null || awk '/^processor/{c++}END{print c+0}' /proc/cpuinfo; }

# sanity checks
if [[ ! -d "$CGPATH" ]]; then
  echo "ERROR: cgroup path not found: $CGPATH" >&2
  exit 1
fi
if [[ ! -f "$CGPATH/cpu.stat" ]]; then
  echo "ERROR: $CGPATH/cpu.stat missing" >&2
  exit 1
fi
if [[ ! -f "$CGPATH/memory.stat" || ! -f "$CGPATH/memory.max" ]]; then
  echo "ERROR: memory.stat or memory.max missing under $CGPATH" >&2
  exit 1
fi

# gather static meta
NODE_CPUS=$(node_cpus)
HOST_MEM_BYTES=$(host_mem_bytes)
CPU_MAX_RAW=$(read_cpu_max_raw)

# derive CPU_LIMIT_CORES from cpu.max (quota/period)
if [[ "$CPU_MAX_RAW" == max* ]]; then
  CPU_LIMIT_CORES="$NODE_CPUS"
else
  read -r quota period <<<"$CPU_MAX_RAW"
  if [[ -z "$quota" || -z "$period" || "$period" -le 0 ]]; then
    CPU_LIMIT_CORES="$NODE_CPUS"
  else
    CPU_LIMIT_CORES=$(awk -v q="$quota" -v p="$period" 'BEGIN{ printf "%.6f", q / p }')
  fi
fi

print_header() {
  cat <<EOF
===============================================
cgroup path: $CGPATH
cpu.max (raw): $CPU_MAX_RAW
memory.max: $(read_mem_max)
NODE_CPUS (host visible): $NODE_CPUS
CPU_LIMIT_CORES (denominator used): $CPU_LIMIT_CORES
Samples: $SAMPLES  Interval: ${INTERVAL}s
Using memory.stat anon as "RSS-like" numerator.
===============================================
EOF
}

run_once() {
  print_header
  prev_cpu=$(read_cpu_usage)
  prev_anon=$(read_mem_anon)
  echo
  printf "%6s  %-20s  %12s  %10s  %7s  %13s  %13s  %10s  %10s\n" \
    "Sample" "Timestamp(UTC)" "delta_usec" "cores" "mCPU" "delta_anon(B)" "anon(B)" "mem_pct" "cpu_pct"
  printf "%6s  %-20s  %12s  %10s  %7s  %13s  %13s  %10s  %10s\n" \
    "------" "--------------------" "----------" "----------" "------" "-------------" "-------------" "--------" "--------"

  sum_cpu_pct=0; sum_mem_pct=0
  valid_cpu=0; valid_mem=0

  for i in $(seq 1 "$SAMPLES"); do
    sleep "$INTERVAL"
    now_ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    cur_cpu=$(read_cpu_usage)
    cur_anon=$(read_mem_anon)

    delta_cpu=$((cur_cpu - prev_cpu))
    delta_anon=$((cur_anon - prev_anon))
    prev_cpu=$cur_cpu
    prev_anon=$cur_anon

    cores=$(awk -v d="$delta_cpu" -v t="$INTERVAL" 'BEGIN{ if(t<=0){print "0.000000000"} else{ printf "%.9f", d/(t*1000000) } }')
    mCPU=$(awk -v c="$cores" 'BEGIN{ printf "%.3f", c*1000 }')
    cpu_pct=$(awk -v c="$cores" -v l="$CPU_LIMIT_CORES" 'BEGIN{ if(l<=0){print "NaN"} else{ printf "%.6f", (c/l)*100 } }')

    mem_max_raw=$(read_mem_max)
    if [[ "$mem_max_raw" == "max" || -z "$mem_max_raw" ]]; then
      if [[ -n "$HOST_MEM_BYTES" && "$HOST_MEM_BYTES" -gt 0 ]]; then
        mem_pct=$(awk -v a="$cur_anon" -v h="$HOST_MEM_BYTES" 'BEGIN{ printf "%.6f", (a/h)*100 }')
      else
        mem_pct="NaN"
      fi
    else
      mem_pct=$(awk -v a="$cur_anon" -v m="$mem_max_raw" 'BEGIN{ if(m<=0){print "NaN"} else{ printf "%.6f", (a/m)*100 } }')
    fi

    printf "%6d  %-20s  %12d  %10s  %7s  %13d  %13d  %8s%%  %7s%%\n" \
      "$i" "$now_ts" "$delta_cpu" "$cores" "$mCPU" "$delta_anon" "$cur_anon" "$mem_pct" "$cpu_pct"

    case "$cpu_pct" in
      ''|NaN) : ;;
      *) sum_cpu_pct=$(awk -v s="$sum_cpu_pct" -v v="$cpu_pct" 'BEGIN{ printf "%.12f", s+v }'); valid_cpu=$((valid_cpu+1)) ;;
    esac
    case "$mem_pct" in
      ''|NaN) : ;;
      *) sum_mem_pct=$(awk -v s="$sum_mem_pct" -v v="$mem_pct" 'BEGIN{ printf "%.12f", s+v }'); valid_mem=$((valid_mem+1)) ;;
    esac
  done

  if [[ "$valid_cpu" -gt 0 ]]; then
    avg_cpu=$(awk -v s="$sum_cpu_pct" -v n="$valid_cpu" 'BEGIN{ printf "%.2f", s/n }')
  else
    avg_cpu="NaN"
  fi
  if [[ "$valid_mem" -gt 0 ]]; then
    avg_mem=$(awk -v s="$sum_mem_pct" -v n="$valid_mem" 'BEGIN{ printf "%.2f", s/n }')
  else
    avg_mem="NaN"
  fi

  echo
  echo "Summary (averages over $valid_cpu cpu samples, $valid_mem mem samples):"
  echo "  CPU_avg_of_limit: ${avg_cpu}%   (denom = cpu.max -> $CPU_LIMIT_CORES cores)"
  echo "  MEM_avg(anon/limit_or_host): ${avg_mem}%   (anon numerator, denom=memory.max or host MemTotal if memory.max==max)"
  echo "---------------------------------------------------------------"
}

# trap for clean exit in watch mode
trap 'echo; echo "Interrupted, exiting."; exit 0' INT TERM

if [[ "$WATCH" -eq 1 ]]; then
  echo "Watch mode: repeating runs until interrupted (Ctrl-C)."
  while true; do
    run_once
    sleep 1
  done
else
  run_once
fi
