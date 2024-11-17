include $(TOPDIR)/rules.mk

PKG_NAME:=bacnet-stack-router
PKG_VERSION:=1.3.8
PKG_RELEASE:=1
PKG_SOURCE_URL:=https://github.com/bacnet-stack/bacnet-stack.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2024-11-03
PKG_SOURCE_VERSION:=master
PKG_MIRROR_HASH:=skip

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
	-DBAC_ROUTING:BOOL=ON \
	-DUCI:BOOL=OFF \
	-DSERVER_UCI:BOOL=OFF \
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
