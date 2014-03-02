#!/bin/bash

br="br0"

tap="tap0"

eth_ip="192.168.8.4"
eth_netmask="255.255.255.0"
eth_broadcast="192.168.8.255"

for t in $tap; do
  openvpn --mktun --dev $t
done

brctl addbr $br

for t in $tap; do
  brctl addif $br $t
done

for t in $tap; do
  ifconfig $t 0.0.0.0 promisc up
done

ifconfig $br $eth_ip netmask $eth_netmask broadcast $eth_broadcast

exit 0
