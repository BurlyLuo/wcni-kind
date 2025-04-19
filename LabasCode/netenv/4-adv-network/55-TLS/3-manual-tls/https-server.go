package main

import (
	"fmt"
	"io"
	"log"
	"net"
	"net/http"
)

func main() {
	interfaceName := "ens3"

	interfaces, err := net.Interfaces()
	if err != nil {
		fmt.Println("Failed to get network interfaces: ", err)
		return
	}

	var ipAddr string
	for _, iface := range interfaces {
		if iface.Name == interfaceName {
			addrs, err := iface.Addrs()
			if err != nil {
				fmt.Printf("Failed to get addresses for interface %s: %v\n", iface.Name, err)
				return
			}

			for _, addr := range addrs {
				ipNet, ok := addr.(*net.IPNet)
				if ok && !ipNet.IP.IsLoopback() && ipNet.IP.To4() != nil {
					ipAddr = ipNet.IP.String()
					break
				}
			}
		}
	}

	if ipAddr == "" {
		fmt.Printf("No IPv4 address found for interface %s\n", interfaceName)
		return
	}

	fmt.Printf("Bind at IPv4 address for interface %s: %s\n", interfaceName, ipAddr)

	http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
		io.WriteString(w, "hello, world!\n")
	})
	if e := http.ListenAndServeTLS(ipAddr+":443", "server.crt", "server.key", nil); e != nil {
		log.Fatal("ListenAndServeTLS: ", e)
	}
}

