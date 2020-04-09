#
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=diskdev_cmds
PKG_VERSION:=332.25
PKG_RELEASE:=1
PKG_LICENSE:=APSL 2.0
PKG_MAINTAINER:=Vladimir Vid <vladimir.vid@sartura.hr>

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://www.opensource.apple.com/tarballs/$(PKG_NAME)/
PKG_BUILD_DIR:=$(BUILD_DIR)/diskdev_cmds-$(PKG_VERSION)
PKG_MD5SUM:=261c3de5ec0dcf5244e3f60d79c1d6f1

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)/Default
  SECTION:=utils
  CATEGORY:=Utilities
  SUBMENU:=Filesystem
endef

define Package/fsck.hfs
  $(call Package/$(PKG_NAME)/Default)
  TITLE:=fsck.hfs
endef

TARGET_CFLAGS += -O0
define Package/fsck.hfs/description
	The fsck.hfs utility verifies and repairs standard HFS and HFS+ filesystems.
endef

define Build/Configure
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		-f Makefile.lnx \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS+="$(TARGET_CFLAGS) $(TARGET_CPPFLAGS) -I$(PKG_BUILD_DIR)/include -DDEBUG_BUILD=0 -D_FILE_OFFSET_BITS=64 -D LINUX=1 -D BSD=1" \
		LDFLAGS+="$(TARGET_LDFLAGS) $(if $(CONFIG_USE_GLIBC),-lbsd)" \
		all
endef

define Package/fsck.hfs/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/fsck_hfs.tproj/fsck_hfs $(1)/usr/bin/fsck.hfs
endef

$(eval $(call BuildPackage,fsck.hfs))
