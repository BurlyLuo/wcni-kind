package main

import (
	"fmt"
	"testing"

	"github.com/google/go-cmp/cmp"
)

func TestValidatFlags(t *testing.T) {
	tests := map[string]struct {
		mode              string
		tunnelSource      string
		tunnelDestination string
		expected          string
	}{
		"tunnel mode":                                       {"tunnel", "", "", ""},
		"transport mode":                                    {"transport", "", "", ""},
		"invalid mode":                                      {"invalid", "", "", "mode must be 'tunnel' or 'transport'"},
		"transport mode with tunnel source IP":              {"transport", "1.2.3.4", "", "transport mode does not support tunnel source/destination IPs"},
		"transport mode with tunnel destination IP":         {"transport", "", "1.2.3.4", "transport mode does not support tunnel source/destination IPs"},
		"tunnel mode with tunnel source IP":                 {"tunnel", "1.2.3.4", "", ""},
		"tunnel mode with tunnel destination IP":            {"tunnel", "", "1.2.3.4", ""},
		"tunnel mode with tunnel source and destination IP": {"tunnel", "1.2.3.4", "1.2.3.4", ""},
		"tunnel mode with invalid tunnel source IP":         {"tunnel", "1.2.3.333", "", "tunnel source IP must be a valid IP address"},
		"tunnel mode with invalid tunnel destination IP":    {"tunnel", "", "1.2.3.4.5", "tunnel destination IP must be a valid IP address"},
	}
	for name, tt := range tests {
		t.Run(name, func(t *testing.T) {
			got := validateFlags(tt.mode, tt.tunnelSource, tt.tunnelDestination)
			gotstr := fmt.Sprintf("%s", got)
			if got == nil {
				gotstr = ""
			}
			if tt.expected != gotstr {
				t.Errorf("expected: %s, got: %s", tt.expected, gotstr)
			}
		})
	}
}

func TestBuildIptablesParams(t *testing.T) {
	tests := map[string]struct {
		del               bool
		mode              string
		iface             string
		tunnelSource      string
		tunnelDestination string
		nflogGroup        int
		prefix            string
		expected          []string
	}{
		"insert simple transport filter": {
			false, "transport", "any", "", "", 5050, "myprefix",
			[]string{"-I", "PREROUTING", "-t", "raw", "-m", "policy", "--dir", "in", "--pol", "ipsec", "--mode", "transport", "--proto", "esp", "-j", "NFLOG", "--nflog-group", "5050", "--nflog-prefix", "myprefix"},
		},
		"remove simple transport filter": {
			true, "transport", "any", "", "", 5050, "myprefix",
			[]string{"-D", "PREROUTING", "-t", "raw", "-m", "policy", "--dir", "in", "--pol", "ipsec", "--mode", "transport", "--proto", "esp", "-j", "NFLOG", "--nflog-group", "5050", "--nflog-prefix", "myprefix"},
		},
		"insert eth0 transport filter": {
			false, "transport", "eth0", "", "", 5050, "myprefix",
			[]string{"-I", "PREROUTING", "-t", "raw", "-i", "eth0", "-m", "policy", "--dir", "in", "--pol", "ipsec", "--mode", "transport", "--proto", "esp", "-j", "NFLOG", "--nflog-group", "5050", "--nflog-prefix", "myprefix"},
		},
		"remove eth0 transport filter": {
			true, "transport", "eth0", "", "", 5050, "myprefix",
			[]string{"-D", "PREROUTING", "-t", "raw", "-i", "eth0", "-m", "policy", "--dir", "in", "--pol", "ipsec", "--mode", "transport", "--proto", "esp", "-j", "NFLOG", "--nflog-group", "5050", "--nflog-prefix", "myprefix"},
		},
		"insert simple tunnel filter": {
			false, "tunnel", "any", "", "", 5050, "myprefix2",
			[]string{"-I", "PREROUTING", "-t", "raw", "-m", "policy", "--dir", "in", "--pol", "ipsec", "--mode", "tunnel", "--proto", "esp", "-j", "NFLOG", "--nflog-group", "5050", "--nflog-prefix", "myprefix2"},
		},
		"remove simple tunnel filter": {
			true, "tunnel", "any", "", "", 5050, "myprefix2",
			[]string{"-D", "PREROUTING", "-t", "raw", "-m", "policy", "--dir", "in", "--pol", "ipsec", "--mode", "tunnel", "--proto", "esp", "-j", "NFLOG", "--nflog-group", "5050", "--nflog-prefix", "myprefix2"},
		},
		"insert eth0 tunnel filter": {
			false, "tunnel", "eth0", "", "", 4040, "myprefix",
			[]string{"-I", "PREROUTING", "-t", "raw", "-i", "eth0", "-m", "policy", "--dir", "in", "--pol", "ipsec", "--mode", "tunnel", "--proto", "esp", "-j", "NFLOG", "--nflog-group", "4040", "--nflog-prefix", "myprefix"},
		},
		"remove eth0 tunnel filter": {
			true, "tunnel", "eth0", "", "", 4040, "myprefix",
			[]string{"-D", "PREROUTING", "-t", "raw", "-i", "eth0", "-m", "policy", "--dir", "in", "--pol", "ipsec", "--mode", "tunnel", "--proto", "esp", "-j", "NFLOG", "--nflog-group", "4040", "--nflog-prefix", "myprefix"},
		},
		"insert eth0 tunnel filter with tunnelsource": {
			false, "tunnel", "eth0", "1.2.3.4", "", 5050, "myprefix",
			[]string{"-I", "PREROUTING", "-t", "raw", "-i", "eth0", "-m", "policy", "--dir", "in", "--pol", "ipsec", "--mode", "tunnel", "--proto", "esp", "--tunnel-src", "1.2.3.4", "-j", "NFLOG", "--nflog-group", "5050", "--nflog-prefix", "myprefix"},
		},
		"remove eth0 tunnel filter with tunnelsource": {
			true, "tunnel", "eth0", "1.2.3.4", "", 5050, "myprefix",
			[]string{"-D", "PREROUTING", "-t", "raw", "-i", "eth0", "-m", "policy", "--dir", "in", "--pol", "ipsec", "--mode", "tunnel", "--proto", "esp", "--tunnel-src", "1.2.3.4", "-j", "NFLOG", "--nflog-group", "5050", "--nflog-prefix", "myprefix"},
		},
		"insert eth0 tunnel filter with tunnelsource and destination": {
			false, "tunnel", "eth0", "1.2.3.4", "4.5.6.7", 5050, "myprefix",
			[]string{"-I", "PREROUTING", "-t", "raw", "-i", "eth0", "-m", "policy", "--dir", "in", "--pol", "ipsec", "--mode", "tunnel", "--proto", "esp", "--tunnel-src", "1.2.3.4", "--tunnel-dst", "4.5.6.7", "-j", "NFLOG", "--nflog-group", "5050", "--nflog-prefix", "myprefix"},
		},
		"remove eth0 tunnel filter with tunnelsource and destination": {
			true, "tunnel", "eth0", "1.2.3.4", "4.5.6.7", 5050, "myprefix",
			[]string{"-D", "PREROUTING", "-t", "raw", "-i", "eth0", "-m", "policy", "--dir", "in", "--pol", "ipsec", "--mode", "tunnel", "--proto", "esp", "--tunnel-src", "1.2.3.4", "--tunnel-dst", "4.5.6.7", "-j", "NFLOG", "--nflog-group", "5050", "--nflog-prefix", "myprefix"},
		},
	}
	for name, tt := range tests {
		t.Run(name, func(t *testing.T) {
			got := buildIptablesParams(tt.del, tt.mode, tt.iface, tt.tunnelSource, tt.tunnelDestination, tt.nflogGroup, tt.prefix)
			diff := cmp.Diff(tt.expected, got)
			if diff != "" {
				t.Error(diff)
			}
		})
	}
}
