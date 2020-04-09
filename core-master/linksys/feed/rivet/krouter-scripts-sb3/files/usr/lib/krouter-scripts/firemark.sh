#!/bin/sh
#****************************************************************
#
#		         firemark.sh
#
#		Copyright 2016 Rivet Networks LLC
#
#****************************************************************

. /usr/share/libubox/jshn.sh
. /lib/functions.sh

trap "lock -u /tmp/krouter.fm.lock" 0
trap "exit 1" SIGTERM SIGHUP

lock /tmp/krouter.fm.lock

uci set firewall.krouter=include
uci set firewall.krouter.path=/usr/lib/krouter-scripts/firemark.sh

iptables -N krouter-chain -t mangle
iptables -D PREROUTING -t mangle -j krouter-chain
iptables -A PREROUTING -t mangle -j krouter-chain
iptables -F krouter-chain -t mangle

LAN_STATUS=$(ubus call network.interface.lan status)
json_load "$LAN_STATUS"
json_get_var LAN_DEVICE l3_device

get_dscp_mark() {
	case $1 in
		1) echo 0x2e
			;;
		2) echo 0x20
			;;
		3) echo 0x26
			;;
		4) echo 0x00
			;;
		5) echo 0x08
			;;
		6) echo 0x0e
			;;
	esac
}

# configure DHCP clients for high priority
# iterate over DHCP leases
compare_and_add() {
	local maccmp=${1%;*}
	local prio=${1#*;}

	# if it's a fully formed MAC add it regardless of DHCP
	[ $(echo $maccmp | wc -c) = "18" ] && {
		logger -t krouter "found macprio entry for $maccmp (static)"
		iptables -A krouter-chain -t mangle -i ${LAN_DEVICE} -m mac --mac-source ${maccmp} --j DSCP --set-dscp $(get_dscp_mark $prio)

		return
	}

	[ -e /var/dhcp.leases ] && {
		while read -r expires macaddr ipaddr hostname; do
			echo $macaddr | grep -q -i ^$maccmp && {
				logger -t krouter "found macprio entry for $macaddr"
				iptables -A krouter-chain -t mangle -i ${LAN_DEVICE} -m mac --mac-source ${macaddr} --j DSCP --set-dscp $(get_dscp_mark $prio)
			}
		done < /var/dhcp.leases
	}
}

iptables -A krouter-chain -t mangle -j CONNMARK --restore-mark

config_load krouter
config_list_foreach krouter macprio compare_and_add

iptables -A krouter-chain -t mangle -i ${LAN_DEVICE} -j CONNMARK --save-mark
