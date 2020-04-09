include $(TOPDIR)/rules.mk

PKG_NAME:=libsbdaemon
LOCAL_SRC=$(if $(wildcard $(TOPDIR)/../rivet/src/$(PKG_NAME)), $(TOPDIR)/../rivet/src/$(PKG_NAME), $(TOPDIR)/../../rivet/src/$(PKG_NAME))
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:RivetNetworks/smartbyte-libsbdaemon.git
PKG_BRANCH=master
PKG_RELEASE:=2

ifeq ($(DUMP)$(PKG_VERSION),)
PKG_REV:=6f44df8
PKG_VERSION:=g6f44df8
endif
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_MIRROR:=none
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/libsbdaemon/Default
  CATEGORY:=Rivet Networks
  SUBMENU:=Utilities
  TITLE:=Daemonizing Library
  MAINTAINER:=Matthew McClintock <mmcclintock@rivetnetworks.com
endef

define Package/libsbdaemon
$(call Package/libsbdaemon/Default)
  VARIANT:=rtll
endef

define Package/libsbdaemon-rtll
$(call Package/libsbdaemon/Default)
  VARIANT:=rtll
endef

define Package/libsbdaemon-ctll
$(call Package/libsbdaemon/Default)
  VARIANT:=ctll
endef

define Package/libsbdaemon/description
 This package contains a library for decrypting Streamboost daemon configuration files.
endef

define Package/libsbdaemon-rtll/description
 This package contains a library for decrypting Streamboost daemon configuration files. This explicit variant sets the logging level configurable at run-time.
endef

define Package/libsbdaemon-ctll/description
 This package contains a library for decrypting Streamboost daemon configuration files. This explicit variant hardcodes the logging level to INFO.
endef

ifeq ($(BUILD_VARIANT),rtll)
	SBLOG_H:=sb_log_runtime.h
else
	SBLOG_H:=sb_log_minimal.h
endif

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libsbdaemon.so* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/daemonize.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/sb_list.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/sb_limits.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/sb_util.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/$(SBLOG_H) $(1)/usr/include/sb_log.h
endef

define Package/libsbdaemon/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libsbdaemon.so* $(1)/usr/lib/
endef

Package/libsbdaemon-rtll/install = $(Package/libsbdaemon/install)
Package/libsbdaemon-ctll/install = $(Package/libsbdaemon/install)

$(eval $(call BuildPackage,libsbdaemon))
$(eval $(call BuildPackage,libsbdaemon-rtll))
$(eval $(call BuildPackage,libsbdaemon-ctll))
