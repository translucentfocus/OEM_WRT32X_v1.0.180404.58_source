include $(TOPDIR)/rules.mk

PKG_NAME:=streamboost3-data
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:RivetNetworks/smartbyte-$(PKG_NAME)
PKG_BRANCH=reaper
PKG_RELEASE:=1

SB3_VERSION_PREFIX?=SB3_BUILD_VERSION

ifeq ($(DUMP)$(PKG_VERSION),)
PKG_REV:=e2e19f5
PKG_VERSION:=0x03030000-ge2e19f5
endif
# Tag format sample: SB3_BUILD_VERSION_3.1.123 (prefix is variable)
# The next line extracts the numbers out of the most recent tag, e.g. 3.1.123
SB3_VER:=$(shell git tag -l $(SB3_VERSION_PREFIX)_'*' | sort -V | tail -1 | cut -d _ -f 4)
ifeq ($(SB3_VER),)
  SB3_VER:=$(shell cat ../streamboost3/files/version)
  ifeq ($(SB3_VER),)
    $(error Error: StreamBoost build version could not be evaluated.)
  endif
endif
PKG_VERSION:=0x03030000-ge2e19f5

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_MIRROR:=none

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  CATEGORY:=Rivet Networks
  SUBMENU:=Utilities
  TITLE:=StreamBoost3 Data Files
  DEPENDS:=
  MAINTAINER:=Matthew McClintock <mmcclintock@rivetnetworks.com
  PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
This packages contains a collection of signature, pattern, and rule files for use by streamboost3 classifiers and sensors.
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/streamboost3

	$(INSTALL_DATA) $(PKG_BUILD_DIR)/alias.conf $(1)/etc/streamboost3/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/device.vger $(1)/etc/streamboost3/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/device.pattern $(1)/etc/streamboost3/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/nh.sig $(1)/etc/streamboost3/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/sbfc.vger $(1)/etc/streamboost3/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/tags.csv $(1)/etc/streamboost3/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/flowclassifier.conf $(1)/etc/streamboost3/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/policy.conf $(1)/etc/streamboost3/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/policy1.conf $(1)/etc/streamboost3/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/sbsb.conf $(1)/etc/streamboost3/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/macoui_db $(1)/etc/streamboost3/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/bwestd.conf $(1)/etc/streamboost3/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/hidden_tags.conf $(1)/etc/streamboost3/
endef

#If your package doesn't define a "postinst", then one gets made
#for you, and it may call a function that doesn't exist on some
#versions of openwrt. That function is "default_postinst()".
#This code change is an attempt to make this package able to be
#installed on more versions of openwrt.
define Package/$(PKG_NAME)/postinst
#!/bin/sh
exit 0
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
