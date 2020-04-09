include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=nexus
LOCAL_SRC=$(if $(wildcard $(TOPDIR)/../rivet/src/$(PKG_NAME)), $(TOPDIR)/../rivet/src/$(PKG_NAME), $(TOPDIR)/../../rivet/src/$(PKG_NAME))
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:RivetNetworks/smartbyte-$(PKG_NAME)
PKG_BRANCH=master
PKG_RELEASE:=1

ifeq ($(DUMP)$(PKG_VERSION),)
PKG_REV:=abdb9a2
PKG_VERSION:=gabdb9a2
endif

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)

include $(INCLUDE_DIR)/package.mk

define KernelPackage/$(PKG_NAME)
  CATEGORY:=Rivet Networks
  SUBMENU:=Flow Detect
  DEPENDS:=+libnetfilter-conntrack
  KCONFIG:= \
  	CONFIG_NETFILTER=y \
	CONFIG_NETFILTER_ADVANCED=y \
  	CONFIG_NETFILTER_NETLINK=y \
	CONFIG_NF_CONNTRACK=y \
	CONFIG_NF_CONNTRACK_MARK=y \
  	CONFIG_NF_CONNTRACK_EVENTS=y \
	CONFIG_NF_CONNTRACK_CHAIN_EVENTS=y
  TITLE:=StreamBoost Nexus
  FILES:=$(PKG_BUILD_DIR)/nexus.ko
endef

define KernelPackage/$(PKG_NAME)-example-sensor
  CATEGORY:=Rivet Networks
  SUBMENU:=Flow Detect
  DEPENDS:=+kmod-nexus
  TITLE:=Example sensor StreamBoost Nexus
  FILES:=$(PKG_BUILD_DIR)/sensors/nexus_example_sensor.ko
endef

define KernelPackage/$(PKG_NAME)/Description
Nexus is the core kernel component for StreamBoost.
endef

define KernelPackage/$(PKG_NAME)-example-sensor/Description
Example sensor for the StreamBoost Nexus system.
endef

define Build/Compile/$(PKG_NAME)
	$(MAKE) -C "$(LINUX_DIR)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		ARCH="$(LINUX_KARCH)" \
		SUBDIRS="$(PKG_BUILD_DIR)" \
		modules
endef

define Build/Compile/$(PKG_NAME)-example-sensor
	$(call Build/InstallDev/$(PKG_NAME),$(STAGING_DIR))
	$(MAKE) -C "$(LINUX_DIR)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		ARCH="$(LINUX_KARCH)" \
		SUBDIRS="$(PKG_BUILD_DIR)/sensors" \
		EXTRA_CFLAGS="-I$(STAGING_DIR)/usr/include" \
		modules
endef

define Build/Compile
	$(call Build/Compile/$(PKG_NAME))
	$(if $(CONFIG_PACKAGE_kmod-$(PKG_NAME)-example-sensor), \
		$(call Build/Compile/$(PKG_NAME)-example-sensor))
endef

define Build/InstallDev/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/usr/include/nexus
	$(CP) $(PKG_BUILD_DIR)/nexus.h $(1)/usr/include/nexus/
	$(CP) $(PKG_BUILD_DIR)/packet.h $(1)/usr/include/nexus/
	$(CP) $(PKG_BUILD_DIR)/connection.h $(1)/usr/include/nexus/
	$(CP) $(PKG_BUILD_DIR)/tuple.h $(1)/usr/include/nexus/
	$(CP) $(PKG_BUILD_DIR)/compat.h $(1)/usr/include/nexus/
endef

define Build/InstallDev
	$(call Build/InstallDev/$(PKG_NAME),$(1),$(2))
endef

define KernelPackage/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/streamboost3/init.d
	$(INSTALL_DIR) $(1)/etc/streamboost3/rc.d

	$(INSTALL_BIN) ./files/$(PKG_NAME).init $(1)/etc/streamboost3/init.d/$(PKG_NAME)
endef

$(eval $(call KernelPackage,$(PKG_NAME)))
$(eval $(call KernelPackage,$(PKG_NAME)-example-sensor))
