OPENWRT_REV:=af7e7ab684d5dd89a3072ad7b29a81a2669ef54f
FW_VERSION=1.0
BUILDDATE=$(shell date +%g%m%d)
ifndef BUILD_NUMBER
BUILD_NUMBER=nonjenkins-$(shell whoami)-$(shell date +%H%M)
endif

all: prepare firmware


firmware:
ifneq (,$(JENKINS))
	@sed -i 's:# CONFIG_MARVELL_WLAN_SOURCES is not set:CONFIG_MARVELL_WLAN_SOURCES=y:g' _build/.config
	@sed -i 's:# CONFIG_MARVELL_HOSTAPD_SOURCES is not set:CONFIG_MARVELL_HOSTAPD_SOURCES=y:g' _build/.config
endif
ifneq (,$(LOCK))
	@sed -i 's:CONFIG_KERNEL_CRASHLOG=y:# CONFIG_KERNEL_CRASHLOG is not set:g' _build/.config
	@sed -i 's:CONFIG_KERNEL_PRINTK=y:# CONFIG_KERNEL_PRINTK is not set:g' _build/.config
endif
	@sed -i 's@VERSION@'"$(FW_VERSION).$(BUILDDATE).$(BUILD_NUMBER)"'@' _build/files/etc/uci-defaults/98_linksys_defaults
	@$(MAKE) -C _build
	@rm -f FW_WRT32X_*.img
	@cp _build/bin/mvebu/openwrt-mvebu-armada-385-linksys-venom-squashfs-factory.img FW_WRT32X_$(FW_VERSION).$(BUILDDATE).$(BUILD_NUMBER)_FORUBOOT.img
	@cp _build/bin/mvebu/openwrt-mvebu-armada-385-linksys-venom-squashfs-sysupgrade.tar FW_WRT32X_$(FW_VERSION).$(BUILDDATE).$(BUILD_NUMBER).img

prepare:
	@echo "### Setting things up... "
	@if [ ! -d _build ]; then git clone -q https://github.com/openwrt/archive.git _build; fi
	@cd _build && git fetch origin && git reset --hard origin/master && git clean -f && git checkout $(OPENWRT_REV) && cd ..
	@rm -rf _build/feeds _build/tmp
	@sed -i '/custom/c\src-link linksys $(PWD)/linksys/feed' _build/feeds.conf.default
	@_build/scripts/feeds update -a
	@_build/scripts/feeds install -d y sambuca-web-device ookla kmod-wlan-v9_8964 minidlna
	@_build/scripts/feeds install -d y streamboost3 krouter-scripts-sb3
	@_build/scripts/feeds install -d y bwestd3 callhome3 deviceclassifier libsbdaemon speedtest
	@_build/scripts/feeds install -d y lil-ozker nanite kmod-nexus nxstat overlord3 pe4 qdiscman3
	@_build/scripts/feeds install -d y kmod-sbfc kmod-sbsb sonic streamboost3-data streamboost3-keys
	@_build/scripts/feeds install -d y jansson jquery fcgi
	@_build/scripts/feeds install -d y -p linksys -f hostapd
	@_build/scripts/feeds install -d y -p linksys -f samba3
	@_build/scripts/feeds install -d y -p linksys -f fsck.hfs
	@_build/scripts/feeds install siproxd
	@rm -rf _build/files
	@cp -a $(PWD)/linksys/files _build/
	@cp -a linksys/patches/* _build/
	@cp linksys/defconfig _build/.config

clean:
	@echo "### Cleaning up the OpenWrt directory... "
	@make -s -C _build dirclean

distclean:
	@echo "### Removing the OpenWrt directory... "
	@rm -rf _build

gpl_tarball:
	@echo "### Building GPL tarball... "
	@if [ -e _build/files ]; then rm -rf _build/files; fi
	@if [ -e gpl_tarball.tar.bz2 ]; then rm gpl_tarball.tar.bz2; fi
	@tar cjfX gpl_tarball.tar.bz2 excluded-files .
	@rm -rf _build/files
