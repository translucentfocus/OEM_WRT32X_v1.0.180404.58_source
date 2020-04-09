include $(TOPDIR)/rules.mk

PKG_NAME:=wand
LOCAL_SRC=$(if $(wildcard $(TOPDIR)/../rivet/src/$(PKG_NAME)), $(TOPDIR)/../rivet/src/$(PKG_NAME), $(TOPDIR)/../../rivet/src/$(PKG_NAME))
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:RivetNetworks/smartbyte-wand
PKG_BRANCH=master
PKG_RELEASE:=1.0

ifeq ($(DUMP)$(PKG_VERSION),)
PKG_REV:=865a468
PKG_VERSION:=g865a468
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
  TITLE:=W.A.N.D
  DEPENDS:=$(SB3_PKG_LIST)
  MAINTAINER:=Matthew McClintock <mmcclintock@rivetnetworks.com
endef

define Package/$(PKG_NAME)/description
StreamBoost 3 Wireless Analytics Networking Daemon
endef

# https://forum.openwrt.org/viewtopic.php?id=21953
EXTRA_LDFLAGS+=-Wl,-rpath-link=$(STAGING_DIR)/usr/lib
EXTRA_CFLAGS+=-I$(STAGING_DIR)/usr/include
EXTRA_CFLAGS+=-DBUILD_VERSION="${PKG_VERSION}" -DBUILD_DATE="${PKG_DATE}"

# Include pre POSIX-2008 extensions that were allowed in GNU
# e.g. strnlen
ifneq ($(CONFIG_USE_UCLIBC),)
EXTRA_CFLAGS+=-D_GNU_SOURCE
endif

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/streamboost3/init.d
	$(INSTALL_DIR) $(1)/usr/bin

	$(INSTALL_BIN) ./files/wand.init $(1)/etc/streamboost3/init.d/wand
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/wand $(1)/usr/bin/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
