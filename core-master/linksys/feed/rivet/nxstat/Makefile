include $(TOPDIR)/rules.mk

PKG_NAME:=nxstat
LOCAL_SRC=$(if $(wildcard $(TOPDIR)/../rivet/src/$(PKG_NAME)), $(TOPDIR)/../rivet/src/$(PKG_NAME), $(TOPDIR)/../../rivet/src/$(PKG_NAME))
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:RivetNetworks/smartbyte-nxstat.git
PKG_BRANCH=master
PKG_RELEASE:=1

ifeq ($(DUMP)$(PKG_VERSION),)
PKG_REV:=13fe28e
PKG_VERSION:=g13fe28e
endif

PKG_DATE:=$(shell date +%Y-%m-%d)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_MIRROR:=none

PKG_BUILD_DEPENDS:=argp-standalone

include $(INCLUDE_DIR)/package.mk

# use SPACES here instead of tabs
define Package/nxstat
  CATEGORY:=Rivet Networks
  SUBMENU:=Utilities
  TITLE:=Nxstat
  DEPENDS:=+jansson +libsbdaemon +libuuid +libnl +!PACKAGE_ip-full:ip +!BUSYBOX_CONFIG_MD5SUM:coreutils-md5sum
  MAINTAINER:=Matthew McClintock <mmcclintock@rivetnetworks.com
endef

define Package/nxstat/description
Provides the core userspace components of StreamBoost 3.0 including libnexus, nxstat, and logorama.
endef

# https://forum.openwrt.org/viewtopic.php?id=21953
TARGET_CFLAGS += -Wl,-rpath-link=$(STAGING_DIR)/usr/lib
EXTRA_LDFLAGS+=-Wl,-rpath-link=$(STAGING_DIR)/usr/lib
EXTRA_CFLAGS+=-I$(STAGING_DIR)/usr/include/libnl3 -I$(STAGING_DIR)/usr/include
EXTRA_CFLAGS+=-DBUILD_VERSION="${PKG_VERSION}" -DBUILD_DATE="${PKG_DATE}"

# use TABs here instead of spaces
MAKE_FLAGS += \
	EXTRA_LDLIBS+="-largp"

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/nexus.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/nxpeer.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/nxlog.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/nxcodec.h $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libnexus.so* $(1)/usr/lib/
endef

define Build/Install
	$(call Build/Install/Default,install-libs)
endef

# TABS
define Package/nxstat/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libnexus.so* $(1)/usr/lib/

	$(INSTALL_DIR) $(1)/etc/streamboost3/init.d
	$(INSTALL_DIR) $(1)/etc/streamboost3/rc.d
	$(INSTALL_BIN) ./files/nxstat.init $(1)/etc/streamboost3/init.d/nxstat

	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/nxstat $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/logorama $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/nxcli $(1)/usr/bin/
endef

# NO TABS, NO SPACES
$(eval $(call BuildPackage,nxstat))
