include $(TOPDIR)/rules.mk

# Build package version from git sha-1
PKG_NAME:=lil-ozker
LOCAL_SRC=$(if $(wildcard $(TOPDIR)/../rivet/src/$(PKG_NAME)), $(TOPDIR)/../rivet/src/$(PKG_NAME), $(TOPDIR)/../../rivet/src/$(PKG_NAME))
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:RivetNetworks/smartbyte-lil-ozker
PKG_BRANCH=master
PKG_RELEASE:=2

ifeq ($(DUMP)$(PKG_VERSION),)
PKG_REV:=f18a220
PKG_VERSION:=gf18a220
endif

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_MIRROR:=none
PKG_BUILD_DEPENDS:=jansson argp-standalone

include $(INCLUDE_DIR)/package.mk

# use SPACES here instead of tabs
define Package/$(PKG_NAME)/Default
  CATEGORY:=Rivet Networks
  SUBMENU:=Web UI
  TITLE:=FastCGI Gateway for the Web UI - Slim Version
  DEPENDS:=+jansson +fcgi +libsbdaemon +nxstat
  MAINTAINER:=Matthew McClintock <mmcclintock@rivetnetworks.com
endef

define Package/$(PKG_NAME)
$(call Package/$(PKG_NAME)/Default)
endef

define Package/$(PKG_NAME)/description
Lil ozKer is ozKer's baby daemon. He does the same job as his daddy,
providing an interface between the UI and the information scattered
everywhere in the system, except he's much slimmer.
endef

# https://forum.openwrt.org/viewtopic.php?id=21953
TARGET_CFLAGS += -Wl,-rpath-link=$(STAGING_DIR)/usr/lib

# use TABs here instead of spaces if you need to break up a long line
MAKE_FLAGS += \
	EXTRA_LDLIBS+="-largp"

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/streamboost3/init.d/
	$(INSTALL_DIR) $(1)/etc/streamboost3/rc.d
	$(INSTALL_DIR) $(1)/usr/bin/

	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME) $(1)/usr/bin/
	$(INSTALL_BIN) ./files/$(PKG_NAME).init $(1)/etc/streamboost3/init.d/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/www/cgi-bin/
	$(INSTALL_BIN) ./files/$(PKG_NAME).cgiwrapper $(1)/www/cgi-bin/$(PKG_NAME)
endef

# NO TABS, NO SPACES
$(eval $(call BuildPackage,$(PKG_NAME)))
