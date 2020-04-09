include $(TOPDIR)/rules.mk

PKG_NAME:=callhome3
LOCAL_SRC=$(if $(wildcard $(TOPDIR)/../rivet/src/$(PKG_NAME)), $(TOPDIR)/../rivet/src/$(PKG_NAME), $(TOPDIR)/../../rivet/src/$(PKG_NAME))
PKG_RELEASE:=1.0
PKG_VERSION:=1.0

# override the local source mirror path since
# the source for libnexus is located within the
# nexus repo.
LOCAL_SRC:=$(TOPDIR)/qca/src/callhomeclient

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  CATEGORY:=Rivet Networks
  SUBMENU:=Flow Detect
  DEPENDS:=+curl +openssl-util +streamboost3-keys
  TITLE:=StreamBoost 3.0 callhome client
  MAINTAINER:=Matthew McClintock <mmcclintock@rivetnetworks.com
endef

define Package/$(PKG_NAME)/Description
Client for the StreamBoost 3.0 callhome server
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/streamboost3/rc.d
	$(INSTALL_DIR) $(1)/etc/streamboost3/init.d
	$(INSTALL_DIR) $(1)/usr/bin

	$(INSTALL_BIN) ./files/$(PKG_NAME).init $(1)/etc/streamboost3/init.d/$(PKG_NAME)
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
