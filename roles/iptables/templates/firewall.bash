#!/bin/bash
# iptables firewall.
#
# This file should be located at /etc/firewall.bash, and is meant to work with
# the `geerlingguy.firewall` Ansible role.
#
# Common port reference:
#   22: SSH
#   25: SMTP
#   80: HTTP
#   123: NTP
#   443: HTTPS
#   2222: SSH alternate
#   8080: HTTP alternate
#
# @author Jeff Geerling

# No spoofing.
if [ -e /proc/sys/net/ipv4/conf/all/rp_filter ]
then
for filter in /proc/sys/net/ipv4/conf/*/rp_filter
do
echo 1 > $filter
done
fi

# Set the default rules.
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Remove all rules and chains.
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X

# Accept traffic from loopback interface (localhost).
iptables -A INPUT -i lo -j ACCEPT

# Forwarded ports.

# Open ports.
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 25 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 3000 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 8086 -j ACCEPT

# Accept icmp ping requests.
iptables -A INPUT -p icmp -j ACCEPT

# Allow NTP traffic for time synchronization.
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT
iptables -A INPUT -p udp --sport 123 -j ACCEPT

# Additional custom rules.

# Allow established connections:
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Log EVERYTHING (ONLY for Debug).
# iptables -A INPUT -j LOG

# Log other incoming requests (all of which are dropped) at 15/minute max.
iptables -A INPUT -m limit --limit 15/minute -j LOG --log-level 7 --log-prefix "Dropped by firewall: "

# Drop all other traffic.
iptables -A INPUT -j DROP

# Configure IPv6 if ip6tables is present.
if [ -x "$(which ip6tables 2>/dev/null)" ]; then

  # Remove all rules and chains.
  ip6tables -F
  ip6tables -X

  # Accept traffic from loopback interface (localhost).
  ip6tables -A INPUT -i lo -j ACCEPT

  # Open ports.
  ip6tables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
  ip6tables -A INPUT -p tcp -m tcp --dport 25 -j ACCEPT
  ip6tables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
  ip6tables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
  ip6tables -A INPUT -p tcp -m tcp --dport 3000 -j ACCEPT
  ip6tables -A INPUT -p tcp -m tcp --dport 8086 -j ACCEPT

  # Accept icmp ping requests.
  ip6tables -A INPUT -p icmpv6 -j ACCEPT

  # Allow NTP traffic for time synchronization.
  ip6tables -A OUTPUT -p udp --dport 123 -j ACCEPT
  ip6tables -A INPUT -p udp --sport 123 -j ACCEPT

  # Additional custom rules.

  # Allow established connections:
  ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

  # Log EVERYTHING (ONLY for Debug).
  # ip6tables -A INPUT -j LOG

  # Log other incoming requests (all of which are dropped) at 15/minute max.
  ip6tables -A INPUT -m limit --limit 15/minute -j LOG --log-level 7 --log-prefix "Dropped by firewall: "

  # Drop all other traffic.
  ip6tables -A INPUT -j DROP

fi
