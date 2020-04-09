#!/bin/sh

[ -f ${STREAMBOOST_CFGDIR:-/etc/streamboost3}/rc.streamboost3 ] && . ${STREAMBOOST_CFGDIR:-/etc/streamboost3}/rc.streamboost3
[ -f ${STREAMBOOST_CFGDIR:-/etc/streamboost3}/qos_constants.sh ] && . ${STREAMBOOST_CFGDIR:-/etc/streamboost3}/qos_constants.sh

EXTRA_CMD_ARGS="--nss"

# sets up the qdisc structures on an interface
# $1: dev
setup_iface() {
	local dev=$1

	# ####################################################################
	# configure the root prio
	# ####################################################################
	tc qdisc add dev ${dev} root \
		handle ${PRIO_HNDL_MAJ}: \
		nssprio bands 3
	[ $? = 0 ] || return $?

	# ####################################################################
	# nsscodel and nsstbl
	# ####################################################################
	tc qdisc add dev ${dev} \
		parent ${PRIO_HNDL_MAJ}:${OUTPUT_HNDL_MIN} \
		handle ${OUTPUT_HNDL_MAJ} \
		nsscodel limit ${OUTPUT_FQC_LIMIT} \
			 target ${OUTPUT_FQC_TARGET} \
			 interval ${OUTPUT_FQC_INTERVAL}
	[ $? = 0 ] || return $?

	tc qdisc add dev ${dev} \
		parent ${PRIO_HNDL_MAJ}:${SB_HNDL_MIN} \
		handle ${TBF_HNDL_MAJ}: \
		nsstbl rate ${SB_SC_UPPERLIMIT} \
			burst ${SB_SC_BURST} \
			mtu ${DEFAULT_MTU}
	[ $? = 0 ] || return $?

	# ####################################################################
	# nssprio and subprio (nssbf)
	# ####################################################################
	tc qdisc add dev ${dev} \
		parent ${TBF_HNDL_MAJ}:${SUBPRIO_HNDL_MIN} \
		handle ${SUBPRIO_HNDL_MAJ}: \
		nssprio bands 2
	[ $? = 0 ] || return $?

	tc qdisc add dev ${dev} \
		parent ${SUBPRIO_HNDL_MAJ}:${SCHROOT_HNDL_MIN} \
		handle ${SCHROOT_HNDL_MAJ}: \
		nssbf
	[ $? = 0 ] || return $?

	# ####################################################################
	# Parent class for dedicated classes
	# ####################################################################
	tc class add dev ${dev} \
		parent ${SCHROOT_HNDL_MAJ}: \
		classid ${SCHROOT_HNDL_MAJ}:${CLASSID_DEDICATED} \
		nssbf rate ${DEFAULT_MTU} \
			burst ${DEFAULT_MTU} \
			mtu ${DEFAULT_MTU} \
			quantum ${DEDICATED_WEIGHT}
	[ $? = 0 ] || return $?

	tc qdisc add dev ${dev} \
		parent ${SCHROOT_HNDL_MAJ}:${CLASSID_DEDICATED} \
		handle ${DEDICATED_HNDL_MAJ} \
		nssbf
	[ $? = 0 ] || return $?

	# ####################################################################
	# Parent class for classified flows
	# ####################################################################
	tc class add dev ${dev} \
		parent ${SCHROOT_HNDL_MAJ}: \
		classid ${SCHROOT_HNDL_MAJ}:${CLASSID_CLASSIFIED} \
		nssbf rate ${DEFAULT_MTU} \
			burst ${DEFAULT_MTU} \
			mtu ${DEFAULT_MTU} \
			quantum ${CLASSIFIED_WEIGHT}
	[ $? = 0 ] || return $?

	# ####################################################################
	# Parent class for background and bulk
	# ####################################################################
	tc class add dev ${dev} \
		parent ${SCHROOT_HNDL_MAJ}: \
		classid ${SCHROOT_HNDL_MAJ}:${CLASSID_BGBULK} \
		nssbf rate ${DEFAULT_MTU} \
			burst ${DEFAULT_MTU} \
			mtu ${DEFAULT_MTU} \
			quantum ${BGBULK_WEIGHT}
	[ $? = 0 ] || return $?

	tc qdisc add dev ${dev} \
		parent ${SCHROOT_HNDL_MAJ}:${CLASSID_BGBULK} \
		handle ${BGBULK_HNDL_MAJ} \
		nssbf
	[ $? = 0 ] || return $?

	# ####################################################################
	# Voice
	# ####################################################################
	tc class add dev ${dev} \
		parent ${DEDICATED_HNDL_MAJ}: \
		classid ${DEDICATED_HNDL_MAJ}:${CLASSID_VOICE} \
		nssbf rate ${VOICE_SC_RATE} \
			burst ${VOICE_SC_BURST} \
			quantum ${VOICE_SC_WEIGHT} \
			mtu ${DEFAULT_MTU}
	[ $? = 0 ] || return $?

	tc qdisc add dev ${dev} \
		parent ${DEDICATED_HNDL_MAJ}:${CLASSID_VOICE} \
		handle ${CLASSID_VOICE} \
		nsscodel limit ${VOICE_FQC_LIMIT} \
			 target ${VOICE_FQC_TARGET} \
			 interval ${VOICE_FQC_INTERVAL}
	[ $? = 0 ] || return $?

	# ####################################################################
	# Realtime Conversational
	# ####################################################################
	tc class add dev ${dev} \
		parent ${DEDICATED_HNDL_MAJ}: \
		classid ${DEDICATED_HNDL_MAJ}:${CLASSID_REALTIME_CONVERSATIONAL} \
		nssbf rate ${REALTIME_CONVERSATIONAL_SC_RATE} \
			burst ${REALTIME_CONVERSATIONAL_SC_BURST} \
			quantum ${REALTIME_CONVERSATIONAL_SC_WEIGHT} \
			mtu ${DEFAULT_MTU}
	[ $? = 0 ] || return $?

	tc qdisc add dev ${dev} \
		parent ${DEDICATED_HNDL_MAJ}:${CLASSID_REALTIME_CONVERSATIONAL} \
		handle ${CLASSID_REALTIME_CONVERSATIONAL} \
		nsscodel limit ${REALTIME_CONVERSATIONAL_FQC_LIMIT} \
			 target ${REALTIME_CONVERSATIONAL_FQC_TARGET} \
			 interval ${REALTIME_CONVERSATIONAL_FQC_INTERVAL}
	[ $? = 0 ] || return $?

	# ####################################################################
	# Realtime Streaming
	# ####################################################################
	tc class add dev ${dev} \
		parent ${DEDICATED_HNDL_MAJ}: \
		classid ${DEDICATED_HNDL_MAJ}:${CLASSID_REALTIME_STREAMING} \
		nssbf rate ${REALTIME_STREAMING_SC_RATE} \
			burst ${REALTIME_STREAMING_SC_BURST} \
			quantum ${REALTIME_STREAMING_SC_WEIGHT} \
			mtu ${DEFAULT_MTU}
	[ $? = 0 ] || return $?

	tc qdisc add dev ${dev} \
		parent ${DEDICATED_HNDL_MAJ}:${CLASSID_REALTIME_STREAMING} \
		handle ${CLASSID_REALTIME_STREAMING} \
		nsscodel limit ${REALTIME_STREAMING_FQC_LIMIT} \
			 target ${REALTIME_STREAMING_FQC_TARGET} \
			 interval ${REALTIME_STREAMING_FQC_INTERVAL}
	[ $? = 0 ] || return $?

	# ####################################################################
	# Interactive
	# ####################################################################
	tc class add dev ${dev} \
		parent ${DEDICATED_HNDL_MAJ}: \
		classid ${DEDICATED_HNDL_MAJ}:${CLASSID_INTERACTIVE} \
		nssbf rate ${INTERACTIVE_SC_RATE} \
			burst ${INTERACTIVE_SC_BURST} \
			quantum ${INTERACTIVE_SC_WEIGHT} \
			mtu ${DEFAULT_MTU}
	[ $? = 0 ] || return $?

	tc qdisc add dev ${dev} \
		parent ${DEDICATED_HNDL_MAJ}:${CLASSID_INTERACTIVE} \
		handle ${CLASSID_INTERACTIVE} \
		nsscodel limit ${INTERACTIVE_FQC_LIMIT} \
			 target ${INTERACTIVE_FQC_TARGET} \
			 interval ${INTERACTIVE_FQC_INTERVAL}
	[ $? = 0 ] || return $?

	# ####################################################################
	# Streaming
	# ####################################################################
	tc class add dev ${dev} \
		parent ${DEDICATED_HNDL_MAJ}: \
		classid ${DEDICATED_HNDL_MAJ}:${CLASSID_STREAMING} \
		nssbf rate ${STREAMING_SC_RATE} \
			burst ${STREAMING_SC_BURST} \
			quantum ${STREAMING_SC_WEIGHT} \
			mtu ${DEFAULT_MTU}
	[ $? = 0 ] || return $?

	tc qdisc add dev ${dev} \
		parent ${DEDICATED_HNDL_MAJ}:${CLASSID_STREAMING} \
		handle ${CLASSID_STREAMING} \
		nsscodel limit ${STREAMING_FQC_LIMIT} \
			 target ${STREAMING_FQC_TARGET} \
			 interval ${STREAMING_FQC_INTERVAL}
	[ $? = 0 ] || return $?

	# ####################################################################
	# Default
	# ####################################################################
	tc class add dev ${dev} \
		parent ${DEDICATED_HNDL_MAJ}: \
		classid ${DEDICATED_HNDL_MAJ}:${CLASSID_DEFAULT} \
		nssbf rate ${DEFAULT_SC_RATE} \
			burst ${DEFAULT_SC_BURST} \
			quantum ${DEFAULT_SC_WEIGHT} \
			mtu ${DEFAULT_MTU}
	[ $? = 0 ] || return $?

	# NOTE: we mark this as the default qdisc for NSS using "set_default"
	tc qdisc add dev ${dev} \
		parent ${DEDICATED_HNDL_MAJ}:${CLASSID_DEFAULT} \
		handle ${CLASSID_DEFAULT} \
		nsscodel limit ${DEFAULT_FQC_LIMIT} \
			 target ${DEFAULT_FQC_TARGET} \
			 interval ${DEFAULT_FQC_INTERVAL} \
			 "set_default"
	[ $? = 0 ] || return $?

	# ####################################################################
	# Background
	# ####################################################################
	tc class add dev ${dev} \
		parent ${BGBULK_HNDL_MAJ}: \
		classid ${BGBULK_HNDL_MAJ}:${CLASSID_BACKGROUND} \
		nssbf rate ${BACKGROUND_SC_RATE} \
			burst ${BACKGROUND_SC_BURST} \
			quantum ${BACKGROUND_SC_WEIGHT} \
			mtu ${DEFAULT_MTU}
	[ $? = 0 ] || return $?

	tc qdisc add dev ${dev} \
		parent ${BGBULK_HNDL_MAJ}:${CLASSID_BACKGROUND} \
		handle ${CLASSID_BACKGROUND} \
		nsscodel limit ${BACKGROUND_FQC_LIMIT} \
			 target ${BACKGROUND_FQC_TARGET} \
			 interval ${BACKGROUND_FQC_INTERVAL}
	[ $? = 0 ] || return $?

	# ####################################################################
	# Carrier Bulk
	# ####################################################################
	tc class add dev ${dev} \
		parent ${BGBULK_HNDL_MAJ}: \
		classid ${BGBULK_HNDL_MAJ}:${CLASSID_CARRIER_BULK} \
		nssbf rate ${CARRIER_BULK_SC_RATE} \
			burst ${CARRIER_BULK_SC_BURST} \
			quantum ${CARRIER_BULK_SC_WEIGHT} \
			mtu ${DEFAULT_MTU}
	[ $? = 0 ] || return $?

	tc qdisc add dev ${dev} \
		parent ${BGBULK_HNDL_MAJ}:${CLASSID_CARRIER_BULK} \
		handle ${CLASSID_CARRIER_BULK} \
		nsscodel limit ${CARRIER_BULK_FQC_LIMIT} \
			 target ${CARRIER_BULK_FQC_TARGET} \
			 interval ${CARRIER_BULK_FQC_INTERVAL}
	[ $? = 0 ] || return $?

	# ####################################################################
	# Local host
	# ####################################################################
	tc class add dev ${dev} \
		parent ${BGBULK_HNDL_MAJ}: \
		classid ${BGBULK_HNDL_MAJ}:${CLASSID_LOCALHOST} \
		nssbf rate ${LOCALHOST_SC_RATE} \
			burst ${LOCALHOST_SC_BURST} \
			quantum ${LOCALHOST_SC_WEIGHT} \
			mtu ${DEFAULT_MTU}
	[ $? = 0 ] || return $?

	tc qdisc add dev ${dev} \
		parent ${BGBULK_HNDL_MAJ}:${CLASSID_LOCALHOST} \
		handle ${CLASSID_LOCALHOST} \
		nsscodel limit ${LOCALHOST_FQC_LIMIT} \
			 target ${LOCALHOST_FQC_TARGET} \
			 interval ${LOCALHOST_FQC_INTERVAL}
	[ $? = 0 ] || return $?

	# ####################################################################
	# Classified (base class for classified flows)
	# ####################################################################
	tc qdisc add dev ${dev} \
		parent ${SCHROOT_HNDL_MAJ}:${CLASSID_CLASSIFIED} \
		handle ${SB_HNDL_MAJ} \
		nssbf
	[ $? = 0 ] || return $?

	tc class add dev ${dev} \
		parent ${SB_HNDL_MAJ}: \
		classid ${SB_HNDL_MAJ}:${CLASSID_CLASSIFIED} \
		nssbf rate ${DEFAULT_MTU} \
			burst ${DEFAULT_MTU} \
			quantum ${CLASSIFIED_WEIGHT} \
			mtu ${DEFAULT_MTU}
	[ $? = 0 ] || return $?
}

start_qdiscs() {
	setup_iface ${WAN_IFACE}
	[ $? = 0 ] || return $?

	setup_iface ${LAN_IFACE}
	[ $? = 0 ] || return $?
}

stop_qdiscs() {
	tc qdisc del dev ${WAN_IFACE} root
	tc qdisc del dev ${LAN_IFACE} root
}

#
#  sets up iptables rules
#
#  $1: iptables executable, e.g., 'iptables' or 'ip6tables'
#  $2: 'A' or 'D' depending on whether to add all rules or delete them
generic_iptables() {
	local ipt=$1
	local cmd=$2

	# All packets from localhost to LAN are marked to skip BWC
	${ipt} -t mangle -${cmd} OUTPUT -o $LAN_IFACE \
		-j CLASSIFY --set-class ${OUTPUT_HNDL_MAJ}:0
	[ $? = 0 ] || return $?

	# All packets from localhost to WAN are marked, but not in
	# such a way that they skip BWC
	# Note the !LAN_IFACE logic allows us to catch any potential
	# PPPoE interface as well
	${ipt} -t mangle -${cmd} OUTPUT ! -o $LAN_IFACE -j CLASSIFY \
		--set-class ${CLASSID_LOCALHOST}:0
	[ $? = 0 ] || return $?

	# limited to 2 per second, placed into REALTIME convo
	${ipt} -t mangle -${cmd} FORWARD -p icmp -m limit --limit 2/second \
		-j CLASSIFY \
		--set-class ${CLASSID_REALTIME_CONVERSATIONAL}:0
	[ $? = 0 ] || return $?

	# Restore the CONNMARK to the packet
	${ipt} -t mangle -${cmd} POSTROUTING -j CONNMARK --restore-mark
	[ $? = 0 ] || return $?

	# Further, restore the mark to priority since filters don't work.
	# Note, mark2prio only overwrites prio with the connmark if the prio
	# is zero so that it won't stomp on the CLASSIFY target.
	${ipt} -t mangle -${cmd} POSTROUTING -j mark2prio
	[ $? = 0 ] || return $?
}

setup_iptables () {
	# call iptables to add rules
	generic_iptables iptables A
	[ $? = 0 ] || return $?
	generic_iptables ip6tables A
	[ $? = 0 ] || return $?
}

teardown_iptables () {
	# call iptables to delete rules
	generic_iptables iptables D
	[ $? = 0 ] || return $?
	generic_iptables ip6tables D
	[ $? = 0 ] || return $?
}

qos_onstart() {
	stop_qdiscs
	start_qdiscs || exit 3
	teardown_iptables
	setup_iptables
}

qos_onstop() {
	teardown_iptables
	stop_qdiscs
}
