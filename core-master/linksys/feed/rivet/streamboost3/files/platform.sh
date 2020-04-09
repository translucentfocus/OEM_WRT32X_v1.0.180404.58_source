#!/bin/sh
#
# Platform-specific functions.
# These may be different for  certain operating systems.


# INTEGRATION NOTES
# 1. If the platform doesn't have UCI, the streamboost3 metapackage must be
#    installed with "SB3_RUNONCE_DIR=/etc/rc.d" in order to preserve state
#    between system updates (sysupgrade).
###################

. /usr/share/libubox/jshn.sh
. /lib/functions.sh

# Return the name of the interface used for lan or wan
# Param: "lan" or "wan"
# For PPPoE, this will return the physical device, e.g. eth0, and not the
# virtual pppoe device (otherwise we would fail to add NSS qdiscs to it later).
print_interface_device() {
	local net_dev=""
	if [ "$1" = "lan" -a -n "${LAN_IFACE}" ]; then
		net_dev="${LAN_IFACE}"
	elif [ "$1" = "wan" -a -n "${WAN_IFACE}" ]; then
		net_dev="${WAN_IFACE}"
	else
		json_load "$(ubus call network.interface.$1 status)"
		json_get_var dev_name device
		net_dev="$dev_name"
	fi

	# If ubus wasn't able to provide us the network name then
	# try uci for the non-lan name, assume "br-lan" for lan.
	if [ -z "$net_dev" ]; then
		if [ "$1" = "lan" ]; then
			net_dev="br-lan"
		else
			net_dev=$(uci show network.${1}.ifname | cut -d '=' -f2 | sed "s/'//g")
		fi
	fi
	echo "$net_dev"
}

# Query the state of the lan or wan interface
# Param: "lan" or "wan" (*not* the actual interface name)
# We use ubus to query the interface status, which will work for both DHCP and PPPoE modes.
# (Using "ip show dev eth0" will say "up" even if pppoe hasn't received an IP address yet).
is_interface_up() {
	local dev="$1"

	[ -z "${dev}" ] && return 1

	json_load "$(ubus call network.interface.$dev status)"
	json_get_var up up

	[ "$up" = "1" ]
}

is_firewall_up() {
	fw_is_loaded
}
