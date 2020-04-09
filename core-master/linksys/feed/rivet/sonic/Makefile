include $(TOPDIR)/rules.mk

PKG_NAME:=sonic
LOCAL_SRC=$(if $(wildcard $(TOPDIR)/../rivet/src/$(PKG_NAME)), $(TOPDIR)/../rivet/src/$(PKG_NAME), $(TOPDIR)/../../rivet/src/$(PKG_NAME))
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:RivetNetworks/smartbyte-sonic
PKG_BRANCH=master
PKG_RELEASE:=1.0

ifeq ($(DUMP)$(PKG_VERSION),)
PKG_REV:=60f0902
PKG_VERSION:=g60f0902
endif

PKG_DATE:=$(shell date +%Y-%m-%d)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_MIRROR:=none

PKG_BUILD_DEPENDS:=argp-standalone

include $(INCLUDE_DIR)/package.mk

SB3_PKG_LIST:=+nxstat +libsbdaemon

define Package/$(PKG_NAME)
  CATEGORY:=Rivet Networks
  SUBMENU:=Utilities
  TITLE:=Sonic
  DEPENDS:=$(SB3_PKG_LIST) +libnl
  MAINTAINER:=Matthew McClintock <mmcclintock@rivetnetworks.com
endef

define Package/$(PKG_NAME)/description
StreamBoost 3.0 Offload Engine
endef

# https://forum.openwrt.org/viewtopic.php?id=21953
EXTRA_LDFLAGS+=-Wl,-rpath-link=$(STAGING_DIR)/usr/lib
EXTRA_CFLAGS+=-I$(STAGING_DIR)/usr/include/libnl3 -I$(STAGING_DIR)/usr/include
EXTRA_CFLAGS+=-DBUILD_VERSION="${PKG_VERSION}" -DBUILD_DATE="${PKG_DATE}"

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/streamboost3/engines
	$(INSTALL_DIR) $(1)/etc/streamboost3/init.d
	$(INSTALL_DIR) $(1)/usr/bin

	$(INSTALL_DATA) ./files/ecm.conf $(1)/etc/streamboost3/engines/
	$(INSTALL_DATA) ./files/sfe.conf $(1)/etc/streamboost3/engines/

	$(INSTALL_BIN) ./files/sonic.init $(1)/etc/streamboost3/init.d/sonic
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/sonic $(1)/usr/bin/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
