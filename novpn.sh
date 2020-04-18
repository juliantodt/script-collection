#!/bin/bash

# Run a command without vpn when everything else is routed through VPN.

# USAGE: ./novpn.sh command [args]

# Runs the command (including all named options and args) in a specifcly setup CGROUP that routes it outside of
# an active openvpn connection. Useful when a command requires your full internet bandwidth or a website restricts VPN use.

# NOTE: running this script a second time (after reboot) will print an error message but will still work. Don't worry.
# NOTE: tested on arch with openvpn
# NOTE: replace wlp7s0 with the name of your internet adapter (see `ip link`)

sudo mkdir -p /sys/fs/cgroup/net_cls/novpn
sudo bash -c "echo 0x00110011 > /sys/fs/cgroup/net_cls/novpn/net_cls.classid"
sudo iptables -t mangle -A OUTPUT -m cgroup --cgroup 0x00110011 -j MARK --set-mark 11
sudo iptables -t nat -A POSTROUTING -m cgroup --cgroup 0x00110011 -o wlp7s0 -j MASQUERADE
sudo ip rule add fwmark 11 table novpn
sudo ip route add default via 192.168.178.1 table novpn
sudo bash -c "echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter"
sudo bash -c "echo 0 > /proc/sys/net/ipv4/conf/wlp7s0/rp_filter"
sudo bash -c "echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter"

sudo cgcreate -t $USER:users -a $USER:users -g net_cls:novpn

cgexec -g net_cls:novpn $@
