include $(TOPDIR)/rules.mk

PKG_NAME:=bacnet-stack-router
PKG_RELEASE:=1
PKG_SOURCE_URL:=https://github.com/bacnet-stack/bacnet-stack.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2025-12-27
PKG_SOURCE_VERSION:=a15ec5e
PKG_MIRROR_HASH:=01c3adfe944d5f4b230a5313dbca7ddefed321cc4ae22c5b3453e90f28ad400e

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/bacnet-stack-router
  SECTION:=net
  CATEGORY:=Network
  DEFAULT:=m
  TITLE:=BACnet Protocol Stack (ROUTER BIP MSTP)
  URL:=https://github.com/bacnet-stack
  DEPENDS:=+libpthread +librt +libconfig
endef

define Package/bacnet-stack-router/description
  This package is built with Routing MSTP BIP support.
endef


CMAKE_OPTIONS+= \
	-DBACDL_ARCNET:BOOL=OFF \
	-DBACDL_BIP:BOOL=ON \
	-DBACDL_BIP6:BOOL=OFF \
	-DBACDL_BSC:BOOL=OFF \
	-DBACDL_ETHERNET:BOOL=OFF \
	-DBACDL_MSTP:BOOL=ON \
	-DBACDL_ZIGBEE:BOOL=OFF \
	-DBAC_ROUTING:BOOL=ON \
	-DUCI:BOOL=OFF \
	-DBACNET_STACK_BUILD_APPS:BOOL=ON \
	-DINTRINSIC_REPORTING:BOOL=ON \
	-DBACNET_PROPERTY_LISTS:BOOL=OFF \
	-DBACNET_BUILD_SERVER_MINI_APP:BOOL=OFF \
	-DBACNET_BUILD_SERVER_BASIC_APP:BOOL=OFF \
	-DBACNET_BUILD_BACPOLL_APP:BOOL=OFF \
	-DBACNET_BUILD_BACDISCOVER_APP:BOOL=OFF \
	-DBACNET_PROTOCOL_REVISION=24 \
	-DBACNET_STACK_DEPRECATED_DISABLE:BOOL=ON \
	-DCMAKE_BUILD_TYPE="Release"

define Package/bacnet-stack-router/conffiles
/etc/config/bacrouter
endef

define Package/bacnet-stack-router/postinst
#!/bin/sh

[ -n $${IPKG_INSTROOT} ] || {
	/etc/init.d/bacrouter enable
	/etc/init.d/bacrouter restart
}
endef

define Package/bacnet-stack-router/install
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/etc/config
	$(INSTALL_CONF) ./files/bacrouter.config $(1)/etc/config/bacrouter
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/router $(1)/usr/sbin/bacrouter
	$(INSTALL_BIN) ./files/bacrouter.init $(1)/etc/init.d/bacrouter
endef

$(eval $(call BuildPackage,bacnet-stack-router))
