package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"net"
	"os"
	"os/exec"
	"time"

	"golang.org/x/sys/unix"

	"github.com/mdlayher/netlink"
	

	nflog "github.com/florianl/go-nflog/v2"
	"github.com/google/gopacket"
	"github.com/google/gopacket/layers"
)

func main() {
	var (
		dumpDuration      = flag.Duration("t", 10*time.Second, "how long to run the NFLOG dumping")
		iface             = flag.String("i", "any", "interface to listen on (default: any)")
		mode              = flag.String("m", "tunnel", "IPSec mode (tunnel or transport)")
		tunnelSource      = flag.String("s", "", "IPSec tunnel source IP")
		tunnelDestination = flag.String("d", "", "IPSec tunnel destination IP")
		nflogGroup        = flag.Int("g", 5050, "NFLOG group to use")
	)

	flag.Parse()

	if err := validateFlags(*mode, *tunnelSource, *tunnelDestination); err != nil {
		fmt.Printf("Error: %s\n", err)
		return
	}

	prefix := fmt.Sprintf("ipsecdump:%d", os.Getpid())

	config := nflog.Config{
		Group:       uint16(*nflogGroup),
		Copymode:    nflog.CopyPacket,
		ReadTimeout: time.Second,
	}

	nfl, err := nflog.Open(&config)
	if err != nil {
		log.Fatalf("Could not open nflog socket: %v\n", err)
	}
	defer nfl.Close()

	ctx, cancel := context.WithTimeout(context.Background(), *dumpDuration)
	defer cancel()

	errorFunc := func(err error) int {
		if opError, ok := err.(*netlink.OpError); ok {
			if opError.Timeout() || opError.Temporary() {
				return 0
			}
		}
		log.Fatalf("Could not receive message: %v\n", err)
		return 1
	}

	if err := nfl.RegisterWithErrorFunc(ctx, buildCallBackFn(prefix), errorFunc); err != nil {
		log.Fatalf("Could not register nflog callback: %v\n", err)
	}

	addIngressCmd := exec.Command("iptables", buildIptablesParams(false, *mode, *iface, *tunnelSource, *tunnelDestination, *nflogGroup, prefix)...)
	delIngressCmd := exec.Command("iptables", buildIptablesParams(true, *mode, *iface, *tunnelSource, *tunnelDestination, *nflogGroup, prefix)...)
	addEgressCmd := exec.Command("iptables", buildEgressIptablesParams(false, *mode, *iface, *tunnelSource, *tunnelDestination, *nflogGroup, prefix)...)
	delEgressCmd := exec.Command("iptables", buildEgressIptablesParams(true, *mode, *iface, *tunnelSource, *tunnelDestination, *nflogGroup, prefix)...)

	defer func() {
		if err := delIngressCmd.Run(); err != nil {
			fmt.Printf("Ingress command finished with error: %s\n", err)
		}
		if err := delEgressCmd.Run(); err != nil {
			fmt.Printf("Egress command finished with error: %s\n", err)
		}
	}()
	if err := addIngressCmd.Run(); err != nil {
		fmt.Printf("Ingress command finished with error: %s\n", err)
	}
	if err := addEgressCmd.Run(); err != nil {
		fmt.Printf("Egress command finished with error: %s\n", err)
	}

	<-ctx.Done()
}

func buildCallBackFn(prefix string) func(nflog.Attribute) int {
	return func(attrs nflog.Attribute) int {
		if attrs.Payload != nil && attrs.HwProtocol != nil && attrs.Prefix != nil && *attrs.Prefix == prefix {
			switch *attrs.HwProtocol {
			case unix.ETH_P_IP:
				pkt := gopacket.NewPacket(*attrs.Payload, layers.LayerTypeIPv4, gopacket.Default)
				fmt.Printf("%s ", time.Now().Format("15:04:05.000000"))
				fmt.Println(pkt.Dump())
			case unix.ETH_P_IPV6:
				pkt := gopacket.NewPacket(*attrs.Payload, layers.LayerTypeIPv6, gopacket.Default)
				fmt.Printf("%s ", time.Now().Format("15:04:05.000000"))
				fmt.Println(pkt.Dump())
			}
		}

		return 0
	}
}

func validateFlags(mode, tunnelSource, tunnelDestination string) error {
	if mode == "tunnel" {
		return validateTunnelFlags(tunnelSource, tunnelDestination)
	}
	if mode == "transport" {
		return validateTransportFlags(tunnelSource, tunnelDestination)
	}
	return fmt.Errorf("mode must be 'tunnel' or 'transport'")
}

func validateTransportFlags(tunnelSource, tunnelDestination string) error {
	if tunnelSource != "" || tunnelDestination != "" {
		return fmt.Errorf("transport mode does not support tunnel source/destination IPs")
	}
	return nil
}

func validateTunnelFlags(tunnelSource, tunnelDestination string) error {
	if tunnelSource != "" && net.ParseIP(tunnelSource) == nil {
		return fmt.Errorf("tunnel source IP must be a valid IP address")
	}
	if tunnelDestination != "" && net.ParseIP(tunnelDestination) == nil {
		return fmt.Errorf("tunnel destination IP must be a valid IP address")
	}
	return nil
}

func buildIptablesParams(del bool, mode, iface, tunnelSource, tunnelDestination string, nflogGroup int, prefix string) []string {
	var params []string

	if del {
		params = append(params, "-D")
	} else {
		params = append(params, "-I")
	}

	params = append(params, []string{"PREROUTING", "-t", "raw"}...)
	if iface != "any" {
		params = append(params, "-i", iface)
	}

	params = append(params, []string{"-m", "policy", "--dir", "in", "--pol", "ipsec", "--mode", mode, "--proto", "esp"}...)
	if mode == "tunnel" {
		if tunnelSource != "" {
			params = append(params, "--tunnel-src", tunnelSource)
		}
		if tunnelDestination != "" {
			params = append(params, "--tunnel-dst", tunnelDestination)
		}
	}

	params = append(params, "-j", "NFLOG", "--nflog-group", fmt.Sprintf("%d", nflogGroup), "--nflog-prefix", prefix)

	return params
}

func buildEgressIptablesParams(del bool, mode, iface, tunnelSource, tunnelDestination string, nflogGroup int, prefix string) []string {
	var params []string

	if del {
		params = append(params, "-D")
	} else {
		params = append(params, "-I")
	}

	params = append(params, []string{"OUTPUT", "-t", "raw"}...)
	if iface != "any" {
		params = append(params, "-o", iface)
	}

	params = append(params, []string{"-m", "policy", "--dir", "out", "--pol", "ipsec", "--mode", mode, "--proto", "esp"}...)
	if mode == "tunnel" {
		if tunnelSource != "" {
			params = append(params, "--tunnel-src", tunnelSource)
		}
		if tunnelDestination != "" {
			params = append(params, "--tunnel-dst", tunnelDestination)
		}
	}

	params = append(params, "-j", "NFLOG", "--nflog-group", fmt.Sprintf("%d", nflogGroup), "--nflog-prefix", prefix)

	return params
}
