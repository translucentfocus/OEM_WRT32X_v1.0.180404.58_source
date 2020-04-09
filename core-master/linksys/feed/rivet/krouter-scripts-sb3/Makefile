include $(TOPDIR)/rules.mk

PKG_NAME:=krouter-scripts-sb3
PKG_VERSION:=1.0
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/krouter-scripts-sb3
  CATEGORY:=Rivet Networks
  TITLE:=Scripts to support SB3 as a compat layer to krouter-scripts
  DEPENDS:=+kmod-sched +iptables-mod-ipmark +kmod-sched-core +kmod-sched-connmark +kmod-ifb +iptables +iptables-mod-ipopt +iptables-mod-conntrack-extra
  URL:=http://rivetnetworks.com
  PKGARCH:=all
endef

define Package/krouter-scripts-sb3/description
  Scripts to support SB3 as a compat layer to krouter-scripts
endef

define Build/Compile
endef

define Package/krouter-scripts-sb3/install
	$(CP) files/* $(1)/
endef

$(eval $(call BuildPackage,krouter-scripts-sb3))
