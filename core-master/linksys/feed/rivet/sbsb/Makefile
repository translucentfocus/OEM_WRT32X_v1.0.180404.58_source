include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=sbsb
LOCAL_SRC=$(if $(wildcard $(TOPDIR)/../rivet/src/$(PKG_NAME)), $(TOPDIR)/../rivet/src/$(PKG_NAME), $(TOPDIR)/../../rivet/src/$(PKG_NAME))
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:RivetNetworks/smartbyte-sbsb
PKG_BRANCH=master
PKG_RELEASE:=1

ifeq ($(DUMP)$(PKG_VERSION),)
PKG_REV:=7f337fb
PKG_VERSION:=g7f337fb
endif

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)

include $(INCLUDE_DIR)/package.mk

define KernelPackage/sbsb
  CATEGORY:=Rivet Networks
  SUBMENU:=Flow Detect
  DEPENDS:=+kmod-nexus
  TITLE:=StreamBoost Sensor Bundle
  FILES:=$(PKG_BUILD_DIR)/sbsb.ko
endef

define KernelPackage/sbsb/description
Streamboost Sensor Bundle supplies several inline sensors to Streamboost.
endef

define Build/Compile
	touch .release
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
	$(INSTALL_BIN) ./files/$(PKG_NAME).init $(1)/etc/streamboost3/init.d/$(PKG_NAME)
endef

# https://forum.openwrt.org/viewtopic.php?id=21953
TARGET_CFLAGS += -Wl,-rpath-link=$(STAGING_DIR)/usr/lib

$(eval $(call KernelPackage,$(PKG_NAME)))
