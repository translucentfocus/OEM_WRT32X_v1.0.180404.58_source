include $(TOPDIR)/rules.mk

# Build package version from git sha-1
PKG_NAME:=overlord
LOCAL_SRC=$(if $(wildcard $(TOPDIR)/../rivet/src/$(PKG_NAME)), $(TOPDIR)/../rivet/src/$(PKG_NAME), $(TOPDIR)/../../rivet/src/$(PKG_NAME))
PKG_BASENAME:=overlord3
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:RivetNetworks/smartbyte-$(PKG_NAME).git
PKG_BRANCH=master
PKG_RELEASE:=1.0

ifeq ($(DUMP)$(PKG_VERSION),)
PKG_REV:=660b62a
PKG_VERSION:=g660b62a
endif

PKG_DATE:=$(shell date +%Y-%m-%d)
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
  SUBMENU:=Bandwidth Control
  TITLE:=Overlord3
  DEPENDS:=+nxstat +libsbdaemon +jansson
  MAINTAINER:=Matthew McClintock <mmcclintock@rivetnetworks.com
endef

define Package/$(PKG_BASENAME)/description
Overlord manages bandwidth allocation by computing the current policy profile for each flow.
endef

TARGET_CFLAGS += -Wl,-rpath-link=$(STAGING_DIR)/usr/lib
EXTRA_LDFLAGS+=-Wl,-rpath-link=$(STAGING_DIR)/usr/lib
EXTRA_CFLAGS+=-I$(STAGING_DIR)/usr/include
EXTRA_CFLAGS+=-DBUILD_VERSION="${PKG_VERSION}" -DBUILD_DATE="${PKG_DATE}"

# use TABs here instead of spaces
MAKE_FLAGS += \
	LDLIBS+="-largp" \
	IPC=nxpeer

# TABS
define Package/$(PKG_BASENAME)/install
	$(INSTALL_DIR) $(1)/etc/streamboost3/init.d
	$(INSTALL_DIR) $(1)/etc/streamboost3/rc.d
	$(INSTALL_BIN) ./files/$(PKG_BASENAME).init $(1)/etc/streamboost3/init.d/$(PKG_BASENAME)

	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/overlord $(1)/usr/bin/$(PKG_BASENAME)
endef

# NO TABS, NO SPACES
$(eval $(call BuildPackage,$(PKG_BASENAME)))
