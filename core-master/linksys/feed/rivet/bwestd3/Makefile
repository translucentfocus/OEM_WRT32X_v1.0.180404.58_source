include $(TOPDIR)/rules.mk

PKG_NAME:=bwestd
LOCAL_SRC=$(if $(wildcard $(TOPDIR)/../rivet/src/$(PKG_NAME)), $(TOPDIR)/../rivet/src/$(PKG_NAME), $(TOPDIR)/../../rivet/src/$(PKG_NAME))
PKG_BASENAME:=bwestd3
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:RivetNetworks/smartbyte-$(PKG_NAME).git
PKG_BRANCH=master
PKG_RELEASE:=1

ifeq ($(DUMP)$(PKG_VERSION),)
PKG_REV:=a212624
PKG_VERSION:=ga212624
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
  TITLE:=Bandwidth Estimator Daemon
  DEPENDS:= +libpthread +libpcap +libsbdaemon +libnl +nxstat
  MAINTAINER:=Matthew McClintock <mmcclintock@rivetnetworks.com
endef

define Package/$(PKG_BASENAME)/description
Bandwidth Estimator Daemon continuously monitors network to estimate available bandwidth.
endef

# https://forum.openwrt.org/viewtopic.php?id=21953
TARGET_CFLAGS += -Wl,-rpath-link=$(STAGING_DIR)/usr/lib

# use TABs here instead of spaces
MAKE_FLAGS += "STREAMBOOST_VERSION=3.1"\
	LDLIBS+="-largp" \
	CFLAGS="-I$(STAGING_DIR)/usr/include/libnl3 -I$(STAGING_DIR)/usr/include $(TARGET_CFLAGS)"

# TABS
define Package/$(PKG_BASENAME)/install
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DIR) $(1)/etc/streamboost3
	$(INSTALL_DIR) $(1)/etc/streamboost3/init.d
	$(INSTALL_DIR) $(1)/etc/streamboost3/rc.d
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_BASENAME)     $(1)/usr/bin/
	$(INSTALL_BIN) ./files/$(PKG_BASENAME).init         $(1)/etc/streamboost3/init.d/$(PKG_BASENAME)
endef

# NO TABS, NO SPACES
$(eval $(call BuildPackage,$(PKG_BASENAME)))
