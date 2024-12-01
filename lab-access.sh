#!/bin/bash


# Activate forwarding
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -p

# Reset the policies of the main tables
sudo iptables -t filter -F
sudo iptables -t nat -F

# Opening the LIBVIRT chains by default
sudo iptables -t filter -A LIBVIRT_FWI -j ACCEPT
sudo iptables -t filter -A LIBVIRT_FWO -j ACCEPT
sudo iptables -t filter -A LIBVIRT_FWX -j ACCEPT
sudo iptables -t filter -A LIBVIRT_INP -j ACCEPT
sudo iptables -t filter -A LIBVIRT_OUT -j ACCEPT

# Enabling NAT on WiFi and virtual bridge (virbr0) for all VMs.
sudo iptables -t nat -A POSTROUTING -o wlp5s0 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o virbr0 -j MASQUERADE


####   Personal port forwarding policies per IP of VM.  ####

# 192.168.122.10 port 22
sudo iptables -t nat -A PREROUTING -p tcp --dport 2210 -j DNAT --to-destination 192.168.122.10:22
sudo iptables -t nat -A POSTROUTING -p tcp -d 192.168.122.10 --dport 2210 -j MASQUERADE
