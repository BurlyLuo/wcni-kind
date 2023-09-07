package main

import (
        "fmt"
        "io"
        "log"
        "net"
        "net/http"
)

func main() {
        interfaceName := "ens33"

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
		io.WriteString(w, "Hello, HTTP!\n")
	})
	if err := http.ListenAndServe(":80", nil); err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}

