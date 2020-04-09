#!/bin/sh

[ -f ${STREAMBOOST_CFGDIR:-/etc/streamboost3}/rc.streamboost3 ] && . ${STREAMBOOST_CFGDIR:-/etc/streamboost3}/rc.streamboost3
[ -f ${STREAMBOOST_CFGDIR:-/etc/streamboost3}/qos_constants.sh ] && . ${STREAMBOOST_CFGDIR:-/etc/streamboost3}/qos_constants.sh

KERNEL_MODULES="sch_prio sch_fq_codel sch_hfsc sch_sfq cls_fw sch_codel"


# sets up the qdisc structures on an interface
# $1: dev
setup_iface() {
	local dev=$1
	# ####################################################################
	# configure the root prio
	# ####################################################################
	tc qdisc add dev ${dev} root \
		handle ${PRIO_HNDL_MAJ}: \
		prio bands 3 priomap 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
	[ $? = 0 ] || return $?
	# interactive for localhost OUTPUT
	tc qdisc add dev ${dev} \
		parent ${PRIO_HNDL_MAJ}:${OUTPUT_HNDL_MIN} \
		handle ${OUTPUT_HNDL_MAJ}: \
		fq_codel limit ${OUTPUT_FQC_LIMIT} \
			target ${OUTPUT_FQC_TARGET} \
			interval ${OUTPUT_FQC_INTERVAL}
	[ $? = 0 ] || return $?

	# base hfsc under which all streamboost classes appear
	tc qdisc add dev ${dev} \
		parent ${PRIO_HNDL_MAJ}:2 \
		handle ${SB_HNDL_MAJ}: \
		hfsc default ${CLASSID_DEFAULT}
	[ $? = 0 ] || return $?

	# ###################################################################
	# configure the base hfsc
	# ###################################################################

	#
	# The main hfsc class is where adjusted global bandwidth is enforced
	# by the bandwidth estimator daemon.  Initial upper limit is 1Gbit
	#
	tc class add dev ${dev} \
		parent ${SB_HNDL_MAJ}:0 \
		classid ${SB_HNDL_MAJ}:${CLASSID_ROOT} \
		hfsc ls m1 0 d 0 m2 ${ROOT_WEIGHT} \
			ul m1 0 d 0 m2 ${ROOT_UPPERLIMIT}
	[ $? = 0 ] || return $?

	#
	# default classifier for the main hfsc classifies on fwmark
	#
	tc filter add dev ${dev} parent ${SB_HNDL_MAJ}: fw
	[ $? = 0 ] || return $?

	#
	# Parent class for the six dedicated classes (voice,
	#   realtime conversational, realtime streaming, interactive,
	#   streaming, and default)
	#
	tc class add dev ${dev} \
		parent ${SB_HNDL_MAJ}:${CLASSID_ROOT} \
		classid ${SB_HNDL_MAJ}:${CLASSID_DEDICATED} \
		hfsc ls m1 0 d 0 m2 ${DEDICATED_WEIGHT}
	[ $? = 0 ] || return $?

	#
	# parent class for classified flows
	#
	tc class add dev ${dev} \
		parent ${SB_HNDL_MAJ}:${CLASSID_ROOT} \
		classid ${SB_HNDL_MAJ}:${CLASSID_CLASSIFIED} \
		hfsc ls m1 0 d 0 m2 ${CLASSIFIED_WEIGHT}
	[ $? = 0 ] || return $?

	#
	# parent class for background and bulk classes (background,
	#   carrier bulk, and localhost)
	#
	#tc class add dev ${dev} \
	#	parent ${SB_HNDL_MAJ}:${CLASSID_ROOT} \
	#	classid ${SB_HNDL_MAJ}:${CLASSID_BGBULK} \
	#	hfsc ls m1 0 d 0 m2 ${BGBULK_WEIGHT}
	#[ $? = 0 ] || return $?

	#
	# voice
	#
	tc class add dev ${dev} \
		parent ${SB_HNDL_MAJ}:${CLASSID_DEDICATED} \
		classid ${SB_HNDL_MAJ}:${CLASSID_VOICE} \
		hfsc sc umax ${VOICE_SC_UMAX} \
			dmax ${VOICE_SC_DMAX} \
			rate ${VOICE_SC_RATE}
	[ $? = 0 ] || return $?
	tc qdisc add dev ${dev} \
		parent ${SB_HNDL_MAJ}:${CLASSID_VOICE} \
		handle ${CLASSID_VOICE}: \
		sfq perturb ${VOICE_SFQ_PERTURB}
	[ $? = 0 ] || return $?

	#
	# realtime conversational
	#
	tc class add dev ${dev} \
		parent ${SB_HNDL_MAJ}:${CLASSID_DEDICATED} \
		classid ${SB_HNDL_MAJ}:${CLASSID_REALTIME_CONVERSATIONAL} \
		hfsc sc umax ${REALTIME_CONVERSATIONAL_SC_UMAX} \
			dmax ${REALTIME_CONVERSATIONAL_SC_DMAX} \
			rate ${REALTIME_CONVERSATIONAL_SC_RATE}
	[ $? = 0 ] || return $?
	tc qdisc add dev ${dev} \
		parent ${SB_HNDL_MAJ}:${CLASSID_REALTIME_CONVERSATIONAL} \
		handle ${CLASSID_REALTIME_CONVERSATIONAL}: \
		sfq perturb ${REALTIME_CONVERSATIONAL_SFQ_PERTURB}
	[ $? = 0 ] || return $?

	#
	# realtime streaming
	#
	tc class add dev ${dev} \
		parent ${SB_HNDL_MAJ}:${CLASSID_DEDICATED} \
		classid ${SB_HNDL_MAJ}:${CLASSID_REALTIME_STREAMING} \
		hfsc sc umax ${REALTIME_STREAMING_SC_UMAX} \
			dmax ${REALTIME_STREAMING_SC_DMAX} \
			rate ${REALTIME_STREAMING_SC_RATE}
	[ $? = 0 ] || return $?
	tc qdisc add dev ${dev} \
		parent ${SB_HNDL_MAJ}:${CLASSID_REALTIME_STREAMING} \
		handle ${CLASSID_REALTIME_STREAMING}: \
			fq_codel limit ${REALTIME_STREAMING_FQC_LIMIT} \
			target ${REALTIME_STREAMING_FQC_TARGET} \
			interval ${REALTIME_STREAMING_FQC_INTERVAL}
	[ $? = 0 ] || return $?

	#
	# interactive
	#
	tc class add dev ${dev} \
		parent ${SB_HNDL_MAJ}:${CLASSID_DEDICATED} \
		classid ${SB_HNDL_MAJ}:${CLASSID_INTERACTIVE} \
		hfsc ls m1 0 d 0 m2 ${INTERACTIVE_SC_WEIGHT}
	[ $? = 0 ] || return $?
	tc qdisc add dev ${dev} \
		parent ${SB_HNDL_MAJ}:${CLASSID_INTERACTIVE} \
		handle ${CLASSID_INTERACTIVE}: \
		fq_codel limit ${INTERACTIVE_FQC_LIMIT} \
			target ${INTERACTIVE_FQC_TARGET} \
			interval ${INTERACTIVE_FQC_INTERVAL}
	[ $? = 0 ] || return $?

	#
	# streaming
	#
	tc class add dev ${dev} \
		parent ${SB_HNDL_MAJ}:${CLASSID_DEDICATED} \
		classid ${SB_HNDL_MAJ}:${CLASSID_STREAMING} \
		hfsc ls m1 0 d 0 m2 ${STREAMING_SC_WEIGHT}
	[ $? = 0 ] || return $?
	tc qdisc add dev ${dev} \
		parent ${SB_HNDL_MAJ}:${CLASSID_STREAMING} \
		handle ${CLASSID_STREAMING}: \
		fq_codel limit ${STREAMING_FQC_LIMIT} \
			target ${STREAMING_FQC_TARGET} \
			interval ${STREAMING_FQC_INTERVAL}
	[ $? = 0 ] || return $?

	#
	# default
	#
	tc class add dev ${dev} \
		parent ${SB_HNDL_MAJ}:${CLASSID_DEDICATED} \
		classid ${SB_HNDL_MAJ}:${CLASSID_DEFAULT} \
		hfsc ls m1 0 d 0 m2 ${DEFAULT_SC_WEIGHT}
	[ $? = 0 ] || return $?
	tc qdisc add dev ${dev} \
		parent ${SB_HNDL_MAJ}:${CLASSID_DEFAULT} \
		handle ${CLASSID_DEFAULT}: \
		fq_codel limit ${DEFAULT_FQC_LIMIT} \
			target ${DEFAULT_FQC_TARGET} \
			interval ${DEFAULT_FQC_INTERVAL}
	[ $? = 0 ] || return $?

	#
	# background
	#
	tc class add dev ${dev} \
		parent ${SB_HNDL_MAJ}:${CLASSID_DEDICATED} \
		classid ${SB_HNDL_MAJ}:${CLASSID_BACKGROUND} \
		hfsc ls m1 0 d 0 m2 ${BACKGROUND_SC_WEIGHT}
	[ $? = 0 ] || return $?
	tc qdisc add dev ${dev} \
		parent ${SB_HNDL_MAJ}:${CLASSID_BACKGROUND} \
		handle ${CLASSID_BACKGROUND}: \
		fq_codel limit ${BACKGROUND_FQC_LIMIT} \
			target ${BACKGROUND_FQC_TARGET} \
			interval ${BACKGROUND_FQC_INTERVAL}
	[ $? = 0 ] || return $?

	#
	# carrier bulk
	#
	tc class add dev ${dev} \
		parent ${SB_HNDL_MAJ}:${CLASSID_DEDICATED} \
		classid ${SB_HNDL_MAJ}:${CLASSID_CARRIER_BULK} \
		hfsc ls m1 0 d 0 m2 ${CARRIER_BULK_SC_WEIGHT}
	[ $? = 0 ] || return $?
	tc qdisc add dev ${dev} \
		parent ${SB_HNDL_MAJ}:${CLASSID_CARRIER_BULK} \
		handle ${CLASSID_CARRIER_BULK}: \
		fq_codel limit ${CARRIER_BULK_FQC_LIMIT} \
			target ${CARRIER_BULK_FQC_TARGET} \
			interval ${CARRIER_BULK_FQC_INTERVAL}
	[ $? = 0 ] || return $?

	#
	# localhost
	#
	tc class add dev ${dev} \
		parent ${SB_HNDL_MAJ}:${CLASSID_DEDICATED} \
		classid ${SB_HNDL_MAJ}:${CLASSID_LOCALHOST} \
		hfsc ls m1 0 d 0 m2 ${LOCALHOST_SC_WEIGHT}
	[ $? = 0 ] || return $?
	tc qdisc add dev ${dev} \
		parent ${SB_HNDL_MAJ}:${CLASSID_LOCALHOST} \
		handle ${CLASSID_LOCALHOST}: \
		fq_codel limit ${LOCALHOST_FQC_LIMIT} \
			target ${LOCALHOST_FQC_TARGET} \
			interval ${LOCALHOST_FQC_INTERVAL}
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


	# All packets from localhost to LAN are marked as 2:3 so
	# that they skip BWC
	${ipt} -t mangle -${cmd} OUTPUT -o $LAN_IFACE \
		-j CLASSIFY --set-class ${PRIO_HNDL_MAJ}:${OUTPUT_HNDL_MIN}

	# All packets from localhost to WAN are marked, but not in
	# such a way that they skip BWC
	# Note the !LAN_IFACE logic allows us to catch any potential
	# PPPoE interface as well
	${ipt} -t mangle -${cmd} OUTPUT ! -o $LAN_IFACE -j CLASSIFY \
		--set-class ${SB_HNDL_MAJ}:${CLASSID_LOCALHOST}

	# For the LAN side, we set the default to be the parent of the
	# HTB, so that when ct_mark is copied to nf_mark, by
	# CONNMARK --restore mark, priority will be unset, and filter fw
	# will read the mark and set the class correctly.  In the WAN
	# direction, the root is the HTB, so we do not need to set the
	# class; it will just work.
	${ipt} -t mangle -${cmd} FORWARD -o $LAN_IFACE \
		-j CLASSIFY --set-class ${PRIO_HNDL_MAJ}:${SB_HNDL_MIN}

	# Forwarded ICMP packets in their own queue
	${ipt} -t mangle -${cmd} FORWARD -p icmp -m limit --limit 2/second \
		-j CLASSIFY \
		--set-class ${SB_HNDL_MAJ}:${CLASSID_REALTIME_CONVERSATIONAL}

	# DNS Elevation
	${ipt} -t mangle -${cmd} POSTROUTING -p udp --dport 53 \
		-j CLASSIFY \
		--set-class ${SB_HNDL_MAJ}:${CLASSID_REALTIME_CONVERSATIONAL}
	${ipt} -t mangle -${cmd} POSTROUTING -p udp --dport 53 \
		-j RETURN

	# TCP Elevation
	${ipt} -t mangle -${cmd} POSTROUTING -p tcp \
		-m conntrack --ctorigdstport 80 -m connbytes --connbytes 0:39 \
		--connbytes-dir both --connbytes-mode packets -j CLASSIFY \
		--set-class ${SB_HNDL_MAJ}:${CLASSID_REALTIME_CONVERSATIONAL}
	${ipt} -t mangle -${cmd} POSTROUTING -p tcp \
		-m conntrack --ctorigdstport 80 -m connbytes --connbytes 0:39 \
		--connbytes-dir both --connbytes-mode packets -j RETURN

	# Restore the CONNMARK to the packet
	${ipt} -t mangle -${cmd} POSTROUTING -j CONNMARK --restore-mark
}

setup_iptables () {
	# call iptables to add rules
	generic_iptables iptables A
	generic_iptables ip6tables A
}

teardown_iptables () {
	# call iptables to delete rules
	generic_iptables iptables D
	generic_iptables ip6tables D
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
