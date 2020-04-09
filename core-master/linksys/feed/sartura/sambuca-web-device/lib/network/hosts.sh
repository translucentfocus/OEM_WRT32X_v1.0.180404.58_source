#!/bin/sh

sleep 10 && \
current_ip=$(ifstatus lan | jsonfilter -e '@["ipv4-address"][0].address') && \
sed -i '/myrouter/c\'$current_ip' myrouter' /etc/hosts && \
/etc/init.d/dnsmasq restart &
