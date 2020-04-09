include $(TOPDIR)/rules.mk

PKG_NAME:=nanite
LOCAL_SRC=$(if $(wildcard $(TOPDIR)/../rivet/src/$(PKG_NAME)), $(TOPDIR)/../rivet/src/$(PKG_NAME), $(TOPDIR)/../../rivet/src/$(PKG_NAME))
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:RivetNetworks/smartbyte-nanite
PKG_BRANCH=master
PKG_RELEASE:=1.0

ifeq ($(DUMP)$(PKG_VERSION),)
PKG_REV:=fe15c75
PKG_VERSION:=gfe15c75
endif

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_MIRROR:=none

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  CATEGORY:=Rivet Networks
  SUBMENU:=Web UI
  TITLE:=nanite
  DEPENDS:=+jquery
  MAINTAINER:=Matthew McClintock <mmcclintock@rivetnetworks.com
endef

define Package/$(PKG_NAME)/description
Nanite package contains html and javascript elements for StreamBoost 3 web UI.
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/www/css
	$(INSTALL_DIR) $(1)/www/js

	$(INSTALL_BIN) $(PKG_BUILD_DIR)/nanite.html $(1)/www/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/groups.json $(1)/www/
	$(CP) $(PKG_BUILD_DIR)/css/* $(1)/www/css/
	$(CP) $(PKG_BUILD_DIR)/js/* $(1)/www/js/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
