include $(TOPDIR)/rules.mk

PKG_NAME:=sambuca-web-device
PKG_VERSION:=2017-03-15-1
PKG_RELEASE:=1

PKG_MAINTAINER:=Davor Popovic <davor.popovic@sartura.hr>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=sambuca
	CATEGORY:=Sambuca
	TITLE:=Sambuca web user interface
	DEPENDS:=+uhttpd +uhttpd-mod-ubus +rpcd +rpcd-mod-rpcsys +rpcd-mod-file +pptpd +miniupnpd +ddns-scripts \
		+ddns-scripts_no-ip_com +openvpn-polarssl +ip-full +kmod-usb-core +kmod-usb-ohci +kmod-usb-uhci \
		+kmod-usb2 +kmod-usb3 +kmod-usb-storage +kmod-usb-storage-extras +usbutils +kmod-nls-cp437 \
		+kmod-nls-iso8859-1 +kmod-nls-utf8 +kmod-scsi-core +kmod-fs-ext4 +kmod-fs-msdos +ntfs-3g +lsblk +pppoe-discovery\
		+kmod-fs-hfsplus +fsck.hfs +samba3 +samba3-nmbd +vsftpd +ca-certificates +uhttpd-mod-tls +uhttpd-mod-tls_polarssl +BUSYBOX_CONFIG_NTPD
endef

define Package/$(PKG_NAME)/description
	Sambuca web interface
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/www
	cp -r ./src-sambuca/* $(1)/www

	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d/
	$(INSTALL_BIN) ./acl/* $(1)/usr/share/rpcd/acl.d/

	$(INSTALL_DIR) $(1)/www/cgi-bin/
	$(INSTALL_BIN) ./cgi-bin/* $(1)/www/cgi-bin/

	$(INSTALL_DIR) $(1)/usr/libexec/rpcd/
	$(INSTALL_BIN) ./rpcd/* $(1)/usr/libexec/rpcd/

	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) ./etc/usb-detect.init $(1)/etc/init.d/usb-detect
	$(INSTALL_BIN) ./etc/wan-detect.init $(1)/etc/init.d/wan-detect
	$(INSTALL_BIN) ./etc/pppoe-detect.init $(1)/etc/init.d/pppoe-detect
	$(INSTALL_BIN) ./etc/fwupdate.init $(1)/etc/init.d/fwupdate
	$(INSTALL_BIN) ./etc/connled.init $(1)/etc/init.d/connled

	$(INSTALL_DIR) $(1)/etc/hotplug.d/usb
	$(INSTALL_BIN) ./etc/10-usb $(1)/etc/hotplug.d/usb/
	$(INSTALL_DIR) $(1)/etc/hotplug.d/scsi
	$(INSTALL_BIN) ./etc/11-scsi $(1)/etc/hotplug.d/scsi

	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface
	$(INSTALL_BIN) ./etc/12-ip_check $(1)/etc/hotplug.d/iface/

	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./uci-defaults/* $(1)/etc/uci-defaults/

	$(INSTALL_DIR) $(1)/etc/
	$(INSTALL_DATA) ./etc/wordlist.txt $(1)/etc/wordlist.txt
	$(INSTALL_DATA) ./etc/sysupgrade.conf $(1)/etc/sysupgrade.conf
	$(INSTALL_BIN) ./etc/dmz_ordering $(1)/etc/dmz_ordering
	$(INSTALL_BIN) ./etc/wps_connection $(1)/etc/wps_connection

	$(INSTALL_DIR) $(1)/etc/
	$(INSTALL_DATA) ./etc/firewall.eula $(1)/etc/firewall.eula

	$(INSTALL_DIR) $(1)/etc/
	$(INSTALL_BIN) ./etc/conndev $(1)/etc/conndev

	$(INSTALL_DIR) $(1)/etc/channels
	$(INSTALL_BIN) ./etc/2Glist $(1)/etc/channels/2Glist
	$(INSTALL_BIN) ./etc/5Glist $(1)/etc/channels/5Glist

	$(INSTALL_DIR) $(1)/etc/openvpn
	$(INSTALL_BIN) ./etc/openvpn_updown $(1)/etc/openvpn/openvpn_updown

	$(INSTALL_DIR) $(1)/sbin/
	$(INSTALL_BIN) ./sbin/* $(1)/sbin/

	$(INSTALL_DIR) $(1)/lib/network
	$(INSTALL_BIN) ./lib/network/hosts.sh $(1)/lib/network/hosts.sh

	$(INSTALL_DIR) $(1)/usr
	$(INSTALL_DATA) ./usr/release_notes.txt $(1)/usr/release_notes.txt
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
