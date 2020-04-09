include $(TOPDIR)/rules.mk

PKG_NAME:=ookla
PKG_VERSION:=1.3.0-79
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/ookla
  SECTION:=utils
  CATEGORY:=OOkla
  TITLE:=Ookla Nano
  DEPENDS:=+libstdcpp
  URL:=http://www.speedtest.net
  PKGARCH:=all
endef

define Package/ookla/description
  "Ookla Nano", the lightweight Ookla client
endef

define Build/Compile
endef

define Package/ookla/install
	$(CP) files/* $(1)/
endef

$(eval $(call BuildPackage,ookla))
