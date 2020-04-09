include $(TOPDIR)/rules.mk

PKG_NAME:=qdiscman
LOCAL_SRC=$(if $(wildcard $(TOPDIR)/../rivet/src/$(PKG_NAME)), $(TOPDIR)/../rivet/src/$(PKG_NAME), $(TOPDIR)/../../rivet/src/$(PKG_NAME))
PKG_BASENAME:=qdiscman3
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:RivetNetworks/smartbyte-$(PKG_NAME).git
PKG_BRANCH=master
PKG_RELEASE:=1

ifeq ($(DUMP)$(PKG_VERSION),)
PKG_REV:=8e7cf71
PKG_VERSION:=g8e7cf71
endif

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_MIRROR:=none
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_BASENAME)-$(PKG_VERSION)

PKG_BUILD_DEPENDS:=argp-standalone

include $(INCLUDE_DIR)/package.mk

# use SPACES here instead of tabs
define Package/$(PKG_BASENAME)
  CATEGORY:=Rivet Networks
  SUBMENU:=Flow Detect
  TITLE:=StreamBoost to Netlink interface
  DEPENDS:=+libsbdaemon +libnl +nxstat +libevent2-core +tc \
	+iptables +ip6tables \
	+iptables-mod-conntrack-extra +iptables-mod-ipopt \
	+kmod-sched +kmod-sched-connmark +kmod-ipt-ipopt \
	+iptables-mod-mark2prio +kmod-ipv6
  MAINTAINER:=Matthew McClintock <mmcclintock@rivetnetworks.com
  KCONFIG:= \
	CONFIG_BRIDGE_IGMP_SNOOPING=y \
	CONFIG_IPV6=y \
	CONFIG_NETFILTER=y \
	CONFIG_NETFILTER_ADVANCED=y \
	CONFIG_NETFILTER_NETLINK=m \
	CONFIG_NETFILTER_XTABLES=m \
	CONFIG_NETFILTER_XT_CONNMARK=m \
	CONFIG_NETFILTER_XT_MARK=m \
	CONFIG_NETFILTER_XT_MATCH_COMMENT=m \
	CONFIG_NETFILTER_XT_MATCH_CONNMARK=m \
	CONFIG_NETFILTER_XT_MATCH_MARK=m \
	CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m \
	CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m \
	CONFIG_NETFILTER_XT_TARGET_CONNMARK=m \
	CONFIG_NETFILTER_XT_TARGET_MARK=m \
	CONFIG_NET_SCHED=m \
	CONFIG_NET_SCH_CODEL=m \
	CONFIG_NET_SCH_FQ_CODEL=m \
	CONFIG_NET_SCH_HFSC=m \
	CONFIG_NET_SCH_PRIO=m \
	CONFIG_NET_SCH_SFQ=m \
	CONFIG_NF_CONNTRACK=y \
	CONFIG_NF_CONNTRACK_CHAIN_EVENTS=y \
	CONFIG_NF_CONNTRACK_EVENTS=y \
	CONFIG_NF_CONNTRACK_FTP=m \
	CONFIG_NF_CONNTRACK_H323=m \
	CONFIG_NF_CONNTRACK_IRC=m \
	CONFIG_NF_CONNTRACK_MARK=y \
	CONFIG_NF_CONNTRACK_PPTP=m \
	CONFIG_NF_CONNTRACK_SIP=m \
	CONFIG_NF_CT_NETLINK=m \
	CONFIG_NF_CT_PROTO_GRE=m
endef

define Package/$(PKG_BASENAME)/description
Qdiscman receives flow policy information from the oversub pubsub channel and implements the policy into the appropriate network qdisc structures.
endef

# https://forum.openwrt.org/viewtopic.php?id=21953
TARGET_CFLAGS += -Wl,-rpath-link=$(STAGING_DIR)/usr/lib

# use TABs here instead of spaces
MAKE_FLAGS += "STREAMBOOST_VERSION=3"\
	LDLIBS+="-largp" \
	CFLAGS="-I$(STAGING_DIR)/usr/include/libnl3 -I$(STAGING_DIR)/usr/include $(TARGET_CFLAGS)"

# TABS
define Package/$(PKG_BASENAME)/install
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DIR) $(1)/etc/streamboost3
	$(INSTALL_DIR) $(1)/etc/streamboost3/init.d
	$(INSTALL_DIR) $(1)/etc/streamboost3/rc.d
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_BASENAME)   $(1)/usr/bin/
	$(INSTALL_BIN) ./files/qos_setup.sh               $(1)/etc/streamboost3
	$(INSTALL_BIN) ./files/qos_setup_nss.sh           $(1)/etc/streamboost3
	$(INSTALL_BIN) ./files/qos_constants.sh           $(1)/etc/streamboost3
	$(INSTALL_BIN) ./files/$(PKG_BASENAME).init       $(1)/etc/streamboost3/init.d/$(PKG_BASENAME)
endef

# NO TABS, NO SPACES
$(eval $(call BuildPackage,$(PKG_BASENAME)))
