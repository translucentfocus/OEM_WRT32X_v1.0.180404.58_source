#!/bin/sh

if [ "$ACTION" = "pressed" -a "$BUTTON" = "wps" -a ! -f "/tmp/wps.lock" ]; then

atb() {
	# Make sure only one instance is running
	touch /tmp/wps.lock

	# Restart LED's
	echo none > /sys/class/leds/pca963x\:venom\:blue\:wps/trigger
	echo none > /sys/class/leds/pca963x\:venom\:amber\:wps/trigger

	w_ifaces="$(ls /var/run/hostapd)"
	for x in $w_ifaces; do
		hostapd_cli -i "$x" wps_pbc
	done

	# Start the blue LED
	echo timer > /sys/class/leds/pca963x\:venom\:blue\:wps/trigger

	timeout=120
	while [ "$timeout" -gt "0" ]; do
		for x in $w_ifaces; do
			pbc_status="$(hostapd_cli -i $x wps_get_status | grep "PBC" | awk '{print $NF}')"
			if [ "$pbc_status" != "Active" ]; then
				pbc_result="$(hostapd_cli -i $x wps_get_status | grep "result" | awk '{print $NF}')"
				break
			fi
		done

		if [ ! -z "$pbc_result" -a "$pbc_result" == "Success" ]; then
			echo default-on > /sys/class/leds/pca963x\:venom\:blue\:wps/trigger

			# Turn the LED of after 5 seconds
			sleep 5 && echo none > /sys/class/leds/pca963x\:venom\:blue\:wps/trigger
			[ -f "/tmp/wps.lock" ] && rm /tmp/wps.lock
			exit 0
		else
			sleep 1
			timeout=$((timeout-1))
		fi
	done


	for x in $w_ifaces; do
		hostapd_cli -i $x wps_cancel
	done

	echo none > /sys/class/leds/pca963x\:venom\:blue\:wps/trigger
	echo default-on > /sys/class/leds/pca963x\:venom\:amber\:wps/trigger

	# Set cronjob to disable the amber LED after a minute
	if [ ! "$(fgrep -w wps /etc/crontabs/root | uniq)" ]; then
		echo '*/1 * * * * echo none > /sys/class/leds/pca963x\:venom\:amber\:wps/trigger' >> /etc/crontabs/root
		echo "*/1 * * * * sed -i '/wps/d' /etc/crontabs/root" >> /etc/crontabs/root
		/etc/init.d/cron restart
	fi

	[ -f "/tmp/wps.lock" ] && rm /tmp/wps.lock
}

atb &

fi

return 0
