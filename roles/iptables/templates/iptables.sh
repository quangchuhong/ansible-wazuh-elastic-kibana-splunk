#!/bin/sh

# Reset iptables
iptables -F INPUT
iptables -F OUTPUT
# Ghi chú:
#   không dùng iptables -F/-X vì làm lỗi docker (xóa nhầm cả Chain DOCKER)

iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Cụm storage dùng DOCKER, không được xóa FORWARD và NAT làm lỗi container
iptables -F FORWARD
iptables -t nat -F
iptables -t nat -X
# Allow anything on loopback
iptables -A INPUT -i lo -j ACCEPT

# Allow ICMP
# http://serverfault.com/a/84981
iptables -A INPUT -p icmp -j ACCEPT

# Allow existing connections to continue
# http://serverfault.com/a/20461
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Whitelist IP and port

# drop IPv4 forwarding (we aren't a router)
iptables -P FORWARD DROP


# allow incoming ssh & mosh connections from openvpn servers
iptables -A INPUT -p tcp --dport 22 -s '192.168.3.60' -j ACCEPT
iptables -A INPUT -p udp -m multiport --dports 60000:61000 -s '192.168.3.60' -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -s '192.168.6.15' -j ACCEPT
iptables -A INPUT -p udp -m multiport --dports 60000:61000 -s '192.168.6.15' -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -s '192.168.3.61' -j ACCEPT
iptables -A INPUT -p udp -m multiport --dports 60000:61000 -s '192.168.3.61' -j ACCEPT


iptables -A INPUT -p tcp --dport 22 -s 113.190.192.11 -j ACCEPT
# drop all incoming ssh traffic from non-whitelisted hosts
iptables -A INPUT -p tcp --dport 22 -j DROP

# ntp
iptables -A INPUT -p udp --sport 123 -j ACCEPT

# nrpe
iptables -A INPUT -s 192.168.2.82 -p tcp --dport 5666 -j ACCEPT
iptables -A INPUT -s 103.69.194.194 -p tcp --dport 5666 -j ACCEPT
# splunk
iptables -A INPUT -s 192.168.2.82 -p tcp --dport 8089 -j ACCEPT


# check-in

# shared_db

# powerup

# HLS



# web



# Open port 9200 for HAProxy check





# mongodb



# mysql
iptables -A INPUT -s 127.0.0.1 -p tcp -m tcp --dport 3306 -j ACCEPT



# redis




# memcached



# mogilefsd



# mogstored




# staging

# smokeping


# redis-cdn


# dashboard-cdn

# prometheus-cdn

# alert


# logs

# seafile

# dev-vunm
#IPVanPhong
iptables -I INPUT -s 103.238.70.226 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 118.70.242.162 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 103.238.70.210 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 103.238.70.194 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 103.238.70.242 -p tcp --dport 22 -j ACCEPT



iptables -I INPUT -s 123.25.30.191 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 123.16.13.202 -p tcp --dport 22 -j ACCEPT

# FPT
iptables -I INPUT -s 118.70.74.155 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 118.70.74.157 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 118.70.74.159 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 118.70.74.161 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 118.70.74.162 -p tcp --dport 22 -j ACCEPT

# VNPT
iptables -I INPUT -s 113.190.232.10 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 113.160.5.74 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 113.160.6.158 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 113.160.73.210 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 113.190.246.18 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 113.160.45.166 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 113.190.246.18 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 113.160.0.10 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 113.160.45.182 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 113.190.232.95 -p tcp --dport 22 -j ACCEPT


# Viettel
iptables -I INPUT -s 27.72.100.137 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 27.72.98.102 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 27.72.98.234 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 27.72.98.253 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 27.72.98.227 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 117.4.250.231 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 117.4.252.45 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 117.4.250.39 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s 123.30.170.241 -p tcp --dport 22 -j ACCEPT

iptables -A INPUT -p tcp --dport 4000 -j ACCEPT
iptables -A INPUT -p tcp --dport 4001 -j ACCEPT
iptables -A INPUT -p tcp --dport 4002 -j ACCEPT
iptables -A INPUT -p tcp --dport 4003 -j ACCEPT
iptables -A INPUT -p tcp --dport 4004 -j ACCEPT
iptables -A INPUT -p tcp --dport 8050 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Asterisk rules ip vanphong
#IPVanPhong
iptables -I INPUT -s 103.238.70.226 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 118.70.242.162 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 103.238.70.210 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 103.238.70.194 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 103.238.70.242 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 192.168.17.0/24 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 192.168.18.0/24 -p udp --dport 5060 -j ACCEPT

iptables -I INPUT -s 123.25.30.191 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 123.16.13.202 -p udp --dport 5060 -j ACCEPT

# FPT
iptables -I INPUT -s 118.70.74.155 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 118.70.74.157 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 118.70.74.159 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 118.70.74.161 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 118.70.74.162 -p udp --dport 5060 -j ACCEPT

# VNPT
iptables -I INPUT -s 113.190.232.10 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 113.160.5.74 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 113.160.6.158 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 113.160.73.210 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 113.190.246.18 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 113.160.45.166 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 113.190.246.18 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 113.160.0.10 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 113.160.45.182 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 113.190.232.95 -p udp --dport 5060 -j ACCEPT


# Viettel
iptables -I INPUT -s 27.72.100.137 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 27.72.98.102 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 27.72.98.234 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 27.72.98.253 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 27.72.98.227 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 117.4.250.231 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 117.4.252.45 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 117.4.250.39 -p udp --dport 5060 -j ACCEPT
iptables -I INPUT -s 123.30.170.241 -p udp --dport 5060 -j ACCEPT 


# Asterisk rules 
iptables -A INPUT -p udp -m udp --dport 4569 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 5036 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 10000:20000 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 2727 -j ACCEPT


# call-center
#
# Block common attacks
# ====================
# - http://www.cyberciti.biz/tips/linux-iptables-10-how-to-block-common-attack.html
# - http://newartisans.com/2007/09/neat-tricks-with-iptables/

# Make sure NEW incoming tcp connections are SYN packets;
# otherwise we need to drop them:
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

# Packets with incoming fragments drop them.
# This attack result into Linux server panic such data loss.
iptables -A INPUT -f -j DROP

# Incoming malformed XMAS packets drop them:
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# Incoming malformed NULL packets:
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# Reject packets from RFC1918 class networks (i.e., spoofed)
iptables -A INPUT -s 169.254.0.0/16   -j DROP
iptables -A INPUT -s 172.16.0.0/12    -j DROP
iptables -A INPUT -s 127.0.0.0/8      -j DROP

iptables -A INPUT -s 224.0.0.0/4      -j DROP
iptables -A INPUT -d 224.0.0.0/4      -j DROP
iptables -A INPUT -s 240.0.0.0/5      -j DROP
iptables -A INPUT -d 240.0.0.0/5      -j DROP
iptables -A INPUT -s 0.0.0.0/8        -j DROP
iptables -A INPUT -d 0.0.0.0/8        -j DROP
iptables -A INPUT -d 239.255.255.0/24 -j DROP
iptables -A INPUT -d 255.255.255.255  -j DROP

# Mitigate TCP SYN Flood Attacks
sysctl -w net/netfilter/nf_conntrack_tcp_loose=0

# Drop invalid packets immediately
iptables -A INPUT -m state --state INVALID -j DROP

# Drop bogus TCP packets
iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -j DROP


# Everything else
iptables -A INPUT -j DROP

