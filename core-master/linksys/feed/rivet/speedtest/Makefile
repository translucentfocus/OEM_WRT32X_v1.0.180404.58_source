include $(TOPDIR)/rules.mk

PKG_NAME:=speedtest
LOCAL_SRC=$(if $(wildcard $(TOPDIR)/../rivet/src/$(PKG_NAME)), $(TOPDIR)/../rivet/src/$(PKG_NAME), $(TOPDIR)/../../rivet/src/$(PKG_NAME))
PKG_BASENAME:=speedtest
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:RivetNetworks/Speedtest_Linux.git
PKG_BRANCH=master
PKG_RELEASE:=1

ifeq ($(DUMP)$(PKG_VERSION),)
PKG_REV:=8545582
PKG_VERSION:=g8545582
endif

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_MIRROR:=none
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_BASENAME)-$(PKG_VERSION)

PKG_BUILD_DEPENDS:=argp-standalone

include $(INCLUDE_DIR)/package.mk

# use SPACES here instead of tabs
define Package/$(PKG_BASENAME)
  CATEGORY:=Rivet Networks
  SUBMENU:=Bandwidth Estimation
  TITLE:=Speedtest Application
  DEPENDS:= +libpthread +librt +libstdcpp
  MAINTAINER:=Matthew McClintock <mmcclintock@rivetnetworks.com
endef

define Package/$(PKG_BASENAME)/description
Speedtest application.
endef

# https://forum.openwrt.org/viewtopic.php?id=21953
TARGET_CFLAGS += -Wl,-rpath-link=$(STAGING_DIR)/usr/lib

# use TABs here instead of spaces
LDLIBS+="-largp" \
	CFLAGS="-I$(STAGING_DIR)/usr/include $(TARGET_CFLAGS)"

# TABS
define Package/$(PKG_BASENAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_BASENAME)     $(1)/usr/bin/
endef

# NO TABS, NO SPACES
$(eval $(call BuildPackage,$(PKG_BASENAME)))
