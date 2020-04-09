include $(TOPDIR)/rules.mk

PKG_NAME:=jquery
PKG_RELEASE:=1.0

JQUERY_URL=http://code.jquery.com
JQUERY_VERSION=2.1.4
JQUERY_MD5SUM:=f9c7afd05729f10f55b689f36bb20172

include $(INCLUDE_DIR)/package.mk

define Package/jquery
  CATEGORY:=Rivet Networks
  SUBMENU:=Web UI
  TITLE:=Jquery API
  DEPENDS:=
  MAINTAINER:=Matthew McClintock <mmcclintock@rivetnetworks.com
endef

define Package/jquery/description
Jquery API needed by several components
endef

define Build/Compile
endef

define Download/jquery
	FILE:=jquery-$(JQUERY_VERSION).min.js
	URL:=$(JQUERY_URL)
	MD5SUM:=$(JQUERY_MD5SUM)
endef

define Package/jquery/install
	$(INSTALL_DIR) $(1)/www/js
	$(CP) $(DL_DIR)/jquery-$(JQUERY_VERSION).min.js $(1)/www/js/
	$(LN) jquery-$(JQUERY_VERSION).min.js $(1)/www/js/jquery-$(JQUERY_VERSION).js
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
$(eval $(call Download,jquery))
$(eval $(call BuildPackage,jquery))
