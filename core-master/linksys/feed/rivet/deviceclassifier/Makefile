include $(TOPDIR)/rules.mk

PKG_NAME:=deviceclassifier
LOCAL_SRC=$(if $(wildcard $(TOPDIR)/../rivet/src/$(PKG_NAME)), $(TOPDIR)/../rivet/src/$(PKG_NAME), $(TOPDIR)/../../rivet/src/$(PKG_NAME))
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:RivetNetworks/smartbyte-$(PKG_NAME)
PKG_BRANCH=master
PKG_RELEASE:=1.0

ifeq ($(DUMP)$(PKG_VERSION),)
PKG_REV:=7181227
PKG_VERSION:=g7181227
endif

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_MIRROR:=none

PKG_BUILD_DEPENDS:=argp-standalone

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  CATEGORY:=Rivet Networks
  SUBMENU:=Utilities
  DEPENDS:=+nxstat +iwinfo +wlanconfig
  TITLE:=StreamBoost Device Classifier (A.K.A diki)
  MAINTAINER:=Matthew McClintock <mmcclintock@rivetnetworks.com
endef

define Package/$(PKG_NAME)/Description
Device Classifier is responsible for device detection function in StreamBoost 3.0.
endef

# https://forum.openwrt.org/viewtopic.php?id=21953
TARGET_CFLAGS += -Wl,-rpath-link=$(STAGING_DIR)/usr/lib

# use TABs here instead of spaces
MAKE_FLAGS += \
	EXTRA_LDLIBS+="-largp"

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/streamboost3/devices.d
	$(INSTALL_DIR) $(1)/etc/streamboost3/init.d
	$(INSTALL_DIR) $(1)/etc/streamboost3/rc.d
	$(INSTALL_DIR) $(1)/usr/bin

	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME) $(1)/usr/bin/diki

	$(INSTALL_BIN) ./files/diki.init $(1)/etc/streamboost3/init.d/diki
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scripts/clients.sh $(1)/etc/streamboost3/devices.d/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scripts/interfaces.sh $(1)/etc/streamboost3/devices.d/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scripts/neighbors.sh $(1)/etc/streamboost3/devices.d/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
