include $(TOPDIR)/rules.mk

PKG_NAME:=bacnet-stack-server
PKG_VERSION:=1.3.8
PKG_RELEASE:=1
PKG_SOURCE_URL:=https://github.com/stargieg/bacnet-stack-upstream.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2024-11-03
PKG_SOURCE_VERSION:=server-uci
PKG_MIRROR_HASH:=skip

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/bacnet-stack-server
  SECTION:=net
  CATEGORY:=Network
  DEFAULT:=m
  TITLE:=BACnet Protocol Stack (Server with uci config)
  URL:=https://github.com/bacnet-stack
  DEPENDS:=+libpthread +librt +libuci +libubox +libwebsockets-full
endef

define Package/bacnet-stack-server/description
  This package is built with Routing MSTP BIP support.
endef

CMAKE_OPTIONS+= \
	-DBACNET_STACK_BUILD_APPS:BOOL=OFF \
	-DBACDL_ARCNET:BOOL=ON \
	-DBACDL_BIP:BOOL=ON \
	-DBACDL_BIP6:BOOL=ON \
	-DBACDL_BSC:BOOL=ON \
	-DBACDL_ETHERNET:BOOL=ON \
	-DBACDL_MSTP:BOOL=ON \
	-DBAC_ROUTING:BOOL=OFF \
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

define Package/bacnet-stack-server/postinst
#!/bin/sh

[ -n $${IPKG_INSTROOT} ] || {
	/etc/init.d/bacserv enable
	/etc/init.d/bacserv restart
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
	$(INSTALL_DIR) $(1)/etc/ssl/bacnet
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/bin/certs/ca_cert.pem $(1)/etc/ssl/bacnet/
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/bin/certs/ca_key.pem  $(1)/etc/ssl/bacnet/
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/bin/certs/client_cert.pem $(1)/etc/ssl/bacnet/
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/bin/certs/client_key.pem $(1)/etc/ssl/bacnet/
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/bin/certs/server_cert.pem $(1)/etc/ssl/bacnet/
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/bin/certs/server_key.pem $(1)/etc/ssl/bacnet/
endef

$(eval $(call BuildPackage,bacnet-stack-server))
