include $(TOPDIR)/rules.mk

PKG_NAME:=streamboost3
LOCAL_SRC=$(if $(wildcard $(TOPDIR)/../rivet/src/$(PKG_NAME)), $(TOPDIR)/../rivet/src/$(PKG_NAME), $(TOPDIR)/../../rivet/src/$(PKG_NAME))
PKG_RELEASE:=1.0
PKG_VERSION:=1.0

include $(INCLUDE_DIR)/package.mk

# We are purposefully separating the following packages from the DEPENDS list
# because our internal build script uses this variable to determine which
# ipks should be shipped to the customers.
# NOTE: The streamboost3-keys package has intentionally been left out of this
# list in order to avoid packaging our internel dev keys and shipping them to
# customers. The package is still a dependency of the streamboost3 meta package
# and will allow customers to define their own.
#
# Note: the streamboost3 meta package is not specified in this list in order
# to avoid recursive dependency problems that occur if a package has a
# dependency on itself.
SB3_DEPS:=+kmod-nexus +kmod-sbfc +kmod-sbsb
SB3_DEPS+=+nxstat +lil-ozker +deviceclassifier +sonic +pe4
SB3_DEPS+=+qdiscman3 +bwestd3 +callhome3 +overlord3
SB3_DEPS+=+luci-theme-darmok +darmok +luci-app-darmok +nanite
SB3_DEPS+=+streamboost3-data +libsbdaemon +speedtest

# This variable is read by the build packaging script to determine which
# binary ipks need to be copied into the final tarball.
SB3_PKG_LIST:=+streamboost3 $(SB3_DEPS)

# Destination for run-once script installation. If such a destination does not
# exist on a target board, /etc/rc.d is a reasonable fallback (override the
# value below via the command line, when installing the package)
SB3_RUNONCE_DIR?=/etc/uci-defaults

define Package/$(PKG_NAME)
  CATEGORY:=Rivet Networks
  TITLE:=StreamBoost3
  DEPENDS:=$(SB3_DEPS) +streamboost3-keys @!PACKAGE_qos-scripts +jshn
  MAINTAINER:=Matthew McClintock <mmcclintock@rivetnetworks.com
endef

define Package/$(PKG_NAME)/description
StreamBoost3 package
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/rc.d
	$(INSTALL_DIR) $(1)/etc/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface
	$(INSTALL_DIR) $(1)/etc/hotplug.d/firewall
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)$(SB3_RUNONCE_DIR)

	$(INSTALL_BIN) ./files/$(PKG_NAME).wrapper $(1)/etc/init.d/$(PKG_NAME)
	$(INSTALL_BIN) ./files/$(PKG_NAME).master $(1)/etc/$(PKG_NAME)/
	$(INSTALL_BIN) ./files/rc.$(PKG_NAME) $(1)/etc/$(PKG_NAME)/
	$(INSTALL_BIN) ./files/platform.sh $(1)/etc/$(PKG_NAME)/platform.sh
	$(INSTALL_DATA) ./files/version $(1)/etc/$(PKG_NAME)/version
	$(INSTALL_DATA) ./files/$(PKG_NAME).opkg.conf $(1)/etc/$(PKG_NAME)/
	$(INSTALL_BIN) ./files/hotplug $(1)/etc/$(PKG_NAME)/
	$(INSTALL_BIN) ./files/$(PKG_NAME).runonce $(1)/etc/init.d/

	$(LN) /etc/init.d/$(PKG_NAME) $(1)/usr/bin/$(PKG_NAME)
	$(LN) /etc/init.d/$(PKG_NAME).runonce $(1)$(SB3_RUNONCE_DIR)/$(PKG_NAME).runonce
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
