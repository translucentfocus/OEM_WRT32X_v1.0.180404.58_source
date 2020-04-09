include $(TOPDIR)/rules.mk

PKG_NAME:=streamboost3-keys
LOCAL_SRC=$(if $(wildcard $(TOPDIR)/../rivet/src/$(PKG_NAME)), $(TOPDIR)/../rivet/src/$(PKG_NAME), $(TOPDIR)/../../rivet/src/$(PKG_NAME))
PKG_RELEASE:=1.0
PKG_VERSION:=g78388ac


PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_MIRROR:=none

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  CATEGORY:=Rivet Networks
  SUBMENU:=Utilities
  TITLE:=StreamBoost3 Keys
  DEPENDS:=
  MAINTAINER:=Matthew McClintock <mmcclintock@rivetnetworks.com
endef

define Package/$(PKG_NAME)/description
Places the StreamBoost3 SSL keys into the target image.
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(CP) -a $(PKG_BUILD_DIR)/files/* $(1)/ 2>/dev/null || true
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
