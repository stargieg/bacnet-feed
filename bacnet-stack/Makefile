include $(TOPDIR)/rules.mk

PKG_NAME:=bacnet-stack
PKG_VERSION:=1.3.8
PKG_RELEASE:=1
#PKG_SOURCE_URL:=https://github.com/bacnet-stack/bacnet-stack.git
PKG_SOURCE_URL:=https://github.com/stargieg/bacnet-stack-upstream.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2024-11-03
PKG_SOURCE_VERSION:=server-uci
PKG_MIRROR_HASH:=skip

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/bacnet-stack/Default
  SECTION:=net
  CATEGORY:=Network
  DEFAULT:=m
  TITLE:=BACnet Protocol Stack
  URL:=https://github.com/bacnet-stack
  DEPENDS:=+libpthread +librt +libuci +libubox
endef

define Package/bacnet-stack/Default/description
  Data Communication Protocol for Building Automation and Control Networks
endef

define Package/bacnet-stack-utils-base
$(call Package/bacnet-stack/Default)
  TITLE+= (Utils Basic)
endef
define Package/bacnet-stack-utils-base/description
  This package is a BACnet utils bacrp,bacepics.
endef

define Package/bacnet-stack-utils-full
$(call Package/bacnet-stack/Default)
  TITLE+= (Utils Full)
  DEPENDS:=bacnet-stack-utils-base
endef
define Package/bacnet-stack-utils-full/description
  This package is a BACnet utils bacpoll,bacmstpcap.
endef

define Package/bacnet-stack-router
$(call Package/bacnet-stack/Default)
  TITLE+= (ROUTER BIP MSTP)
  DEPENDS:=+libuci +libconfig
endef

define Package/bacnet-stack-router-mstp
$(call Package/bacnet-stack/Default)
  TITLE+= (ROUTER BIP MSTP)
endef

define Package/bacnet-stack-router/description
  This package is built with Routing MSTP BIP support.
endef

define Package/bacnet-stack-router-ipv6
$(call Package/bacnet-stack/Default)
  TITLE+= (ROUTER BIP BIP6)
endef

define Package/bacnet-stack-router-ipv6/description
  This package is built with Routing BIP6 BIP support.
endef

define Package/bacnet-stack-server
$(call Package/bacnet-stack/Default)
  TITLE+= (Server with uci config)
endef

define Package/bacnet-stack-server/description
  This package is built with Routing MSTP BIP support.
endef

CMAKE_OPTIONS+= \
	-DBACDL_ARCNET:BOOL=ON \
	-DBACDL_BIP:BOOL=ON \
	-DBACDL_BIP6:BOOL=ON \
	-DBACDL_BSC:BOOL=ON \
	-DBACDL_ETHERNET:BOOL=ON \
	-DBACDL_MSTP:BOOL=ON \
	-DBAC_ROUTING:BOOL=ON \
	-DUCI:BOOL=ON \
	-DSERVER_UCI:BOOL=ON \
	-DBACNET_PROTOCOL_REVISION=24 \
	-DBACNET_STACK_DEPRECATED_DISABLE:BOOL=ON \
	-DCMAKE_BUILD_TYPE="Release"

define Package/bacnet-stack-server/conffiles
/etc/config/bacnet_dev
/etc/config/bacnet_nc
/etc/config/bacnet_sc
/etc/config/bacnet_tl
/etc/config/bacnet_ao
/etc/config/bacnet_av
/etc/config/bacnet_ai
/etc/config/bacnet_bo
/etc/config/bacnet_bv
/etc/config/bacnet_bi
/etc/config/bacnet_mo
/etc/config/bacnet_mv
/etc/config/bacnet_mi
endef

define Package/bacnet-stack-router/conffiles
/etc/config/bacrouter
endef

define Package/bacnet-stack-server/postinst
#!/bin/sh

[ -n $${IPKG_INSTROOT} ] || {
	/etc/init.d/bacserv enable
	/etc/init.d/bacserv restart
}
endef

define Package/bacnet-stack-router/postinst
#!/bin/sh

[ -n $${IPKG_INSTROOT} ] || {
	/etc/init.d/bacrouter enable
	/etc/init.d/bacrouter restart
}
endef

define Package/bacnet-stack-server/install
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/etc/config
	$(INSTALL_CONF) ./files/bacnet_dev.config $(1)/etc/config/bacnet_dev
	$(INSTALL_CONF) ./files/bacnet_nc.config $(1)/etc/config/bacnet_nc
	$(INSTALL_CONF) ./files/bacnet_sc.config $(1)/etc/config/bacnet_sc
	$(INSTALL_CONF) ./files/bacnet_tl.config $(1)/etc/config/bacnet_tl
	$(INSTALL_CONF) ./files/bacnet_ao.config $(1)/etc/config/bacnet_ao
	$(INSTALL_CONF) ./files/bacnet_av.config $(1)/etc/config/bacnet_av
	$(INSTALL_CONF) ./files/bacnet_ai.config $(1)/etc/config/bacnet_ai
	$(INSTALL_CONF) ./files/bacnet_bo.config $(1)/etc/config/bacnet_bo
	$(INSTALL_CONF) ./files/bacnet_bv.config $(1)/etc/config/bacnet_bv
	$(INSTALL_CONF) ./files/bacnet_bv.config $(1)/etc/config/bacnet_bi
	$(INSTALL_CONF) ./files/bacnet_mo.config $(1)/etc/config/bacnet_mo
	$(INSTALL_CONF) ./files/bacnet_mo.config $(1)/etc/config/bacnet_mv
	$(INSTALL_CONF) ./files/bacnet_mo.config $(1)/etc/config/bacnet_mi
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/server-uci $(1)/usr/sbin/bacserv-uci
	$(INSTALL_BIN) ./files/bacserv.init $(1)/etc/init.d/bacserv
endef

define Package/bacnet-stack-router/install
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/etc/config
	$(INSTALL_CONF) ./files/bacrouter.config $(1)/etc/config/bacrouter
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/router $(1)/usr/sbin/bacrouter
	$(INSTALL_BIN) ./files/bacrouter.init $(1)/etc/init.d/bacrouter
endef

define Package/bacnet-stack-router-mstp/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/router-mstp $(1)/usr/sbin/bacrouter-mstp
endef

define Package/bacnet-stack-router-ipv6/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/router-ipv6 $(1)/usr/sbin/bacrouter-ipv6
endef

UTILS_BASE+=ack-alarm
UTILS_BASE+=dcc
UTILS_BASE+=epics
UTILS_BASE+=event
UTILS_BASE+=getevent
UTILS_BASE+=netnumis
UTILS_BASE+=readfile
UTILS_BASE+=readprop
UTILS_BASE+=readpropm
UTILS_BASE+=readrange
UTILS_BASE+=timesync
UTILS_BASE+=whois
UTILS_BASE+=whoisrouter
UTILS_BASE+=writefile
UTILS_BASE+=writegroup
UTILS_BASE+=writeprop
UTILS_BASE+=writepropm

define Package/bacnet-stack-utils-base/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(foreach bacfile,$(UTILS_BASE),$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(bacfile) $(1)/usr/bin/bac$(bacfile) ;)
	$(LN) /usr/bin/bacgetevent $(1)/usr/bin/bacge
	$(LN) /usr/bin/bacreadprop $(1)/usr/bin/bacrp
	$(LN) /usr/bin/bacreadpropm $(1)/usr/bin/bacrpm
	$(LN) /usr/bin/bacreadrange $(1)/usr/bin/bacrr
	$(LN) /usr/bin/bacwhois $(1)/usr/bin/bacwi
	$(LN) /usr/bin/bacwriteprop $(1)/usr/bin/bacwp
	$(INSTALL_BIN) ./files/eventlist.sh $(1)/usr/bin/
endef

UTILS_FILES=abort
UTILS_FILES+=add-list-element
UTILS_FILES+=apdu
UTILS_FILES+=create-object
UTILS_FILES+=delete-object
UTILS_FILES+=error
UTILS_FILES+=gateway
UTILS_FILES+=iam
UTILS_FILES+=iamrouter
UTILS_FILES+=initrouter
UTILS_FILES+=mstpcap
UTILS_FILES+=mstpcrc
UTILS_FILES+=readbdt
UTILS_FILES+=readfdt
UTILS_FILES+=reinit
UTILS_FILES+=remove-list-element
UTILS_FILES+=scov
UTILS_FILES+=ucov
UTILS_FILES+=uevent
UTILS_FILES+=uptransfer
UTILS_FILES+=whatisnetnum
UTILS_FILES+=whohas

define Package/bacnet-stack-utils-full/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(foreach bacfile,$(UTILS_FILES),$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(bacfile) $(1)/usr/bin/bac$(bacfile) ;)
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/server $(1)/usr/sbin/bacserver
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bacdiscover $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bacpoll $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,bacnet-stack-server))
$(eval $(call BuildPackage,bacnet-stack-router))
$(eval $(call BuildPackage,bacnet-stack-router-mstp))
$(eval $(call BuildPackage,bacnet-stack-router-ipv6))
$(eval $(call BuildPackage,bacnet-stack-utils-base))
$(eval $(call BuildPackage,bacnet-stack-utils-full))
