include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=sbfc
LOCAL_SRC=$(if $(wildcard $(TOPDIR)/../rivet/src/$(PKG_NAME)), $(TOPDIR)/../rivet/src/$(PKG_NAME), $(TOPDIR)/../../rivet/src/$(PKG_NAME))
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:RivetNetworks/smartbyte-sbfc
PKG_BRANCH=master
PKG_RELEASE:=1

ifeq ($(DUMP)$(PKG_VERSION),)
PKG_REV:=51e4dcc
PKG_VERSION:=g51e4dcc
endif

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)

include $(INCLUDE_DIR)/package.mk

define KernelPackage/sbfc
  CATEGORY:=Rivet Networks
  SUBMENU:=Flow Detect
  DEPENDS:=+kmod-nexus
  TITLE:=StreamBoost Inline Classifier
  FILES:=$(PKG_BUILD_DIR)/sbfc.ko
  #AUTOLOAD:=$(call AutoLoad,61,sbfc)
endef

define KernelPackage/sbfc/description
Streamboost Fast Classifier is an in-line sensor for Streamboost 3.0.  It supports port, protocol, substring, and HTTP matching to classify packets.
endef

define Build/Compile
	touch .release
	$(call Build/Compile/Default, DEBUG=0)
	V=1 $(MAKE) -C "$(LINUX_DIR)" \
	  	DEBUG=0 \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		ARCH="$(LINUX_KARCH)" \
		SUBDIRS="$(PKG_BUILD_DIR)" \
		EXTRA_CFLAGS="$(EXTRA_CFLAGS) -I$(STAGING_DIR)/usr/include" \
		V=1 \
		modules
endef

define KernelPackage/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/streamboost3
	$(INSTALL_DIR) $(1)/etc/streamboost3/init.d
	$(INSTALL_DIR) $(1)/etc/streamboost3/rc.d

	$(INSTALL_BIN) ./files/$(PKG_NAME).init $(1)/etc/streamboost3/init.d/$(PKG_NAME)
endef

define Package/sbfc-cli
  CATEGORY:=Rivet Networks
  SUBMENU:=Utilities
  TITLE:=sbfc-cli
  DEPENDS:=+libsbdaemon +libnetfilter-conntrack +libpcap
  MAINTAINER:=Matthew McClintock <mmcclintock@rivetnetworks.com
endef

define Package/sbfc-cli/description
Provides the cli build of sbfc
endef

# https://forum.openwrt.org/viewtopic.php?id=21953
TARGET_CFLAGS += -Wl,-rpath-link=$(STAGING_DIR)/usr/lib

# TABS
define Package/sbfc-cli/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/sbfc $(1)/usr/bin/
endef

$(eval $(call KernelPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,sbfc-cli))
