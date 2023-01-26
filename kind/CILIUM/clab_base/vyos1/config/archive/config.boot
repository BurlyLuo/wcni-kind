interfaces {
    ethernet eth1 {
        address 10.1.12.1/24
        duplex auto
        smp-affinity auto
        speed auto
    }
    loopback lo {
    }
}
protocols {
    bgp 100 {
        neighbor 10.1.12.2 {
            remote-as 100
        }
        parameters {
            router-id 10.1.12.1
        }
    }
}
system {
    config-management {
        commit-revisions 100
    }
    console {
        device ttyS0 {
            speed 9600
        }
    }
    host-name R1
    login {
        user vyos {
            authentication {
                encrypted-password $6$QxPS.uk6mfo$9QBSo8u1FkH16gMyAVhus6fU3LOzvLR9Z9.82m3tiHFAxTtIkhaZSWssSgzt4v4dGAL8rhVQxTg0oAG9/q11h/
                plaintext-password ""
            }
            level admin
        }
    }
    ntp {
        server 0.pool.ntp.org {
        }
        server 1.pool.ntp.org {
        }
        server 2.pool.ntp.org {
        }
    }
    syslog {
        global {
            facility all {
                level info
            }
            facility protocols {
                level debug
            }
        }
    }
    time-zone UTC
}


/* Warning: Do not remove the following line. */
/* === vyatta-config-version: "snmp@1:vrrp@2:dns-forwarding@1:broadcast-relay@1:firewall@5:dhcp-server@5:ipsec@5:config-management@1:system@10:l2tp@1:cluster@1:mdns@1:conntrack@1:webproxy@2:quagga@7:webgui@1:webproxy@1:conntrack-sync@1:pppoe-server@2:qos@1:nat@4:dhcp-relay@2:wanloadbalance@3:pptp@1:ntp@1:ssh@1:zone-policy@1" === */
/* Release version: 1.2.8 */
