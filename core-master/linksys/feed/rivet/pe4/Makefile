include $(TOPDIR)/rules.mk

PKG_NAME:=pe4
LOCAL_SRC=$(if $(wildcard $(TOPDIR)/../rivet/src/$(PKG_NAME)), $(TOPDIR)/../rivet/src/$(PKG_NAME), $(TOPDIR)/../../rivet/src/$(PKG_NAME))
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:RivetNetworks/smartbyte-pe4
#PKG_BRANCH=master
PKG_BRANCH=master
PKG_RELEASE:=1.0

ifeq ($(DUMP)$(PKG_VERSION),)
PKG_REV:=8a4f800
PKG_VERSION:=g8a4f800
endif

PKG_DATE:=$(shell date +%Y-%m-%d)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_MIRROR:=none

PKG_BUILD_DEPENDS:=argp-standalone

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  CATEGORY:=Rivet Networks
  SUBMENU:=Utilities
  TITLE:=PE4
  DEPENDS:=+libsbdaemon +nxstat
  MAINTAINER:=Matthew McClintock <mmcclintock@rivetnetworks.com
endef

define Package/$(PKG_NAME)/description
StreamBoost 3.0 Policy Engine
endef

# use TABs here instead of spaces
MAKE_FLAGS += \
	LDLIBS+="-largp"


# https://forum.openwrt.org/viewtopic.php?id=21953
EXTRA_LDFLAGS+=-Wl,-rpath-link=$(STAGING_DIR)/usr/lib
EXTRA_CFLAGS+=-I$(STAGING_DIR)/usr/include
EXTRA_CFLAGS+=-DBUILD_VERSION="${PKG_VERSION}" -DBUILD_DATE="${PKG_DATE}"

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/streamboost3/init.d
	$(INSTALL_DIR) $(1)/usr/bin

	$(INSTALL_BIN) ./files/pe4.init $(1)/etc/streamboost3/init.d/pe4
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/pe4 $(1)/usr/bin/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
