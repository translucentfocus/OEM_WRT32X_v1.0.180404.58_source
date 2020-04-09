#
# Copyright (C) 2014-2015 OpenWrt.org
#

. /lib/mvebu.sh

linksys_get_target_firmware() {
	cur_boot_part=`/usr/sbin/fw_printenv -n boot_part`
	target_firmware=""
	if [ "$cur_boot_part" = "1" ]
	then
		# current primary boot - update alt boot
		target_firmware="kernel2"
		fw_setenv boot_part 2
		fw_setenv bootcmd "run altnandboot"
	elif [ "$cur_boot_part" = "2" ]
	then
		# current alt boot - update primary boot
		target_firmware="kernel1"
		fw_setenv boot_part 1
		fw_setenv bootcmd "run nandboot"
	fi

	# re-enable recovery so we get back if the new firmware is broken
	fw_setenv auto_recovery yes

	echo "$target_firmware"
}

platform_do_upgrade_linksys() {

	local magic_long="$(get_magic_long "$1")"

	mkdir -p /var/lock
	local part_label="$(linksys_get_target_firmware)"
	touch /var/lock/fw_printenv.lock

	if [ ! -n "$part_label" ]
	then
		echo "cannot find target partition"
		exit 1
	fi

	local target_mtd=$(find_mtd_part $part_label)

	[ "$magic_long" = "73797375" ] && {
		CI_KERNPART="$part_label"
		if [ "$part_label" = "kernel1" ]
		then
			CI_UBIPART="rootfs1"
		else
			CI_UBIPART="rootfs2"
		fi

		nand_upgrade_tar "$1"
	}
	[ "$magic_long" = "27051956" ] && {
		# erase everything to be safe
		mtd erase $part_label
		get_image "$1" | mtd -n write - $part_label
	}
	[ "$magic_long" = "0000a0e1" ] && {
		# erase everything to be safe
		mtd erase $part_label
		get_image "$1" | mtd -n write - $part_label
	}
}

linksys_preupgrade() {
	export RAMFS_COPY_BIN="${RAMFS_COPY_BIN} /usr/sbin/fw_printenv /usr/sbin/fw_setenv"
	export RAMFS_COPY_BIN="${RAMFS_COPY_BIN} /bin/mkdir /bin/touch"
	export RAMFS_COPY_DATA="${RAMFS_COPY_DATA} /etc/fw_env.config /var/lock/fw_printenv.lock"

	[ -f /tmp/sysupgrade.tgz ] && {
		cp /tmp/sysupgrade.tgz /tmp/syscfg/sysupgrade.tgz
	}
}

append sysupgrade_pre_upgrade linksys_preupgrade
