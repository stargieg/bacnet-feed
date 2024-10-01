include $(TOPDIR)/rules.mk

PKG_NAME:=bacnet-stack
PKG_VERSION:=1.3.4
PKG_RELEASE:=28
#PKG_SOURCE_URL:=https://github.com/bacnet-stack/bacnet-stack.git
PKG_SOURCE_URL:=https://github.com/stargieg/bacnet-stack-upstream.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2024-09-10
PKG_SOURCE_VERSION:=server-uci
PKG_MIRROR_HASH:=skip
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/bacnet-stack/Default
  SECTION:=net
  CATEGORY:=Network
  TITLE:=BACnet Protocol Stack
  URL:=https://github.com/bacnet-stack
  DEPENDS:=+libpthread +librt
endef

define Package/bacnet-stack/Default/description
  Data Communication Protocol for Building Automation and Control Networks
endef

define Package/bacnet-stack-utils-arcnet
$(call Package/bacnet-stack/Default)
  TITLE+= (Utils for Arcnet)
  VARIANT:=utils-arcnet
  DEPENDS:=+libuci +libubox
endef
define Package/bacnet-stack-utils-arcnet/description
  This package is a BACnet utils bacrp,bacepics for Arcnet.
endef

define Package/bacnet-stack-utils-bip
$(call Package/bacnet-stack/Default)
  TITLE+= (Utils for IPv4)
  VARIANT:=utils-bip
  DEPENDS:=+libuci +libubox
endef
define Package/bacnet-stack-utils-bip/description
  This package is a BACnet utils bacrp,bacepics for IPv4.
endef

define Package/bacnet-stack-utils-bip6
$(call Package/bacnet-stack/Default)
  TITLE+= (Utils for IPv6)
  VARIANT:=utils-bip6
  DEPENDS:=+libuci +libubox
endef
define Package/bacnet-stack-utils-bip6/description
  This package is a BACnet utils bacrp,bacepics for IPv6.
endef

define Package/bacnet-stack-utils-ethernet
$(call Package/bacnet-stack/Default)
  TITLE+= (Utils for Ethernet)
  VARIANT:=utils-ethernet
  DEPENDS:=+libuci +libubox
endef
define Package/bacnet-stack-utils-ethernet/description
  This package is a BACnet utils bacrp,bacepics for Ethernet.
endef

define Package/bacnet-stack-utils-mstp
$(call Package/bacnet-stack/Default)
  TITLE+= (Utils for MSTP/RS485)
  VARIANT:=utils-mstp
  DEPENDS:=+libuci +libubox
endef
define Package/bacnet-stack-utils-mstp/description
  This package is a BACnet utils bacrp,bacepics for MSTP/RS485.
endef

define Package/bacnet-stack-router
$(call Package/bacnet-stack/Default)
  TITLE+= (ROUTER BIP MSTP)
  VARIANT:=router
  DEPENDS:=+libconfig
endef

define Package/bacnet-stack-router-mstp
$(call Package/bacnet-stack/Default)
  TITLE+= (ROUTER BIP MSTP)
  VARIANT:=router-mstp
endef

define Package/bacnet-stack-router/description
  This package is built with Routing MSTP BIP support.
endef
define Package/bacnet-stack-server
$(call Package/bacnet-stack/Default)
  TITLE+= (Server ARCNET ETHERNET BIP BIP6 MSTP)
  VARIANT:=server
  DEPENDS:=+libuci +libubox
endef

define Package/bacnet-stack-server/description
  This package is built with Routing MSTP BIP support.
endef

MAKE_VARS += BUILD=release
MAKE_VARS += BACNET_PORT=linux
MAKE_VARS += CSTANDARD=" -std=gnu17"
MAKE_VARS += CC="$(TARGET_CC)"
MAKE_VARS += AR="$(TARGET_AR)"
MAKE_VARS += CFLAGS="$(TARGET_CFLAGS)"
MAKE_VARS += LDFLAGS="$(TARGET_LDFLAGS)"
MAKE_VARS += OPTIMIZATION="-O3"

ifeq ($(BUILD_VARIANT),server)
MAKE_VARS += UCI=1
MAKE_VARS += UCI_LIB_DIR="$(STAGING_DIR)/usr/lib"
#MAKE_VARS += BUILD=debug
MAKE_VARS += BACNET_SRC_DIR=$(PKG_BUILD_DIR)/src
MAKE_VARS += BACNET_PORT_DIR=$(PKG_BUILD_DIR)/ports/linux
define Build/Compile
	$(MAKE_VARS) $(MAKE) -C $(PKG_BUILD_DIR)/apps/server-uci all
endef
endif

ifeq ($(BUILD_VARIANT),router)
define Build/Compile
	$(MAKE_VARS) $(MAKE) -C $(PKG_BUILD_DIR) router
endef
endif

ifeq ($(BUILD_VARIANT),router-mstp)
define Build/Compile
	$(MAKE_VARS) $(MAKE) -C $(PKG_BUILD_DIR) router-mstp
endef
endif

ifeq ($(BUILD_VARIANT),utils-arcnet)
MAKE_VARS += BACDL=arcnet
MAKE_VARS += UCI=1
define Build/Compile
	$(MAKE_VARS) $(MAKE) -C $(PKG_BUILD_DIR) apps
endef
endif
ifeq ($(BUILD_VARIANT),utils-bip)
MAKE_VARS += BACDL=bip
MAKE_VARS += BBMD=full
MAKE_VARS += UCI=1
define Build/Compile
        $(MAKE_VARS) $(MAKE) -C $(PKG_BUILD_DIR) apps
endef
endif
ifeq ($(BUILD_VARIANT),utils-bip6)
MAKE_VARS += BACDL=bip6
MAKE_VARS += BBMD=full
MAKE_VARS += UCI=1
define Build/Compile
        $(MAKE_VARS) $(MAKE) -C $(PKG_BUILD_DIR) apps
endef
endif
ifeq ($(BUILD_VARIANT),utils-ethernet)
MAKE_VARS += BACDL=ethernet
MAKE_VARS += UCI=1
define Build/Compile
        $(MAKE_VARS) $(MAKE) -C $(PKG_BUILD_DIR) apps
endef
endif
ifeq ($(BUILD_VARIANT),utils-mstp)
MAKE_VARS += BACDL=mstp
MAKE_VARS += UCI=1
define Build/Compile
        $(MAKE_VARS) $(MAKE) -C $(PKG_BUILD_DIR) apps
endef
endif


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
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/bacserv-uci $(1)/usr/sbin/bacserv-uci
	$(INSTALL_BIN) ./files/bacserv.init $(1)/etc/init.d/bacserv
endef

define Package/bacnet-stack-router/install
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/etc/config
	$(INSTALL_CONF) ./files/bacrouter.config $(1)/etc/config/bacrouter
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/router $(1)/usr/sbin/bacrouter
	$(INSTALL_BIN) ./files/bacrouter.init $(1)/etc/init.d/bacrouter
endef

define Package/bacnet-stack-router-mstp/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/router-mstp $(1)/usr/sbin/bacrouter-mstp
endef

define Package/bacnet-stack-utils-arcnet/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/* $(1)/usr/bin/
	$(INSTALL_BIN) ./files/eventlist.sh $(1)/usr/bin/
endef
define Package/bacnet-stack-utils-bip/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/* $(1)/usr/bin/
	$(INSTALL_BIN) ./files/eventlist.sh $(1)/usr/bin/
endef
define Package/bacnet-stack-utils-bip6/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/* $(1)/usr/bin/
	$(INSTALL_BIN) ./files/eventlist.sh $(1)/usr/bin/
endef
define Package/bacnet-stack-utils-ethernet/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/* $(1)/usr/bin/
	$(INSTALL_BIN) ./files/eventlist.sh $(1)/usr/bin/
endef
define Package/bacnet-stack-utils-mstp/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/* $(1)/usr/bin/
	$(INSTALL_BIN) ./files/eventlist.sh $(1)/usr/bin/
endef

$(eval $(call BuildPackage,bacnet-stack-server))
$(eval $(call BuildPackage,bacnet-stack-router))
$(eval $(call BuildPackage,bacnet-stack-router-mstp))
$(eval $(call BuildPackage,bacnet-stack-utils-arcnet))
$(eval $(call BuildPackage,bacnet-stack-utils-bip))
$(eval $(call BuildPackage,bacnet-stack-utils-bip6))
$(eval $(call BuildPackage,bacnet-stack-utils-ethernet))
$(eval $(call BuildPackage,bacnet-stack-utils-mstp))
