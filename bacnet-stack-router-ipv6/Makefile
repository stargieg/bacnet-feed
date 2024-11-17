include $(TOPDIR)/rules.mk

PKG_NAME:=bacnet-stack-router-ipv6
PKG_VERSION:=1.3.8
PKG_RELEASE:=1
PKG_SOURCE_URL:=https://github.com/bacnet-stack/bacnet-stack.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2024-11-03
PKG_SOURCE_VERSION:=master
PKG_MIRROR_HASH:=skip

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/bacnet-stack-router-ipv6
  SECTION:=net
  CATEGORY:=Network
  DEFAULT:=m
  TITLE:=BACnet Protocol Stack (ROUTER BIP BIP6)
  URL:=https://github.com/bacnet-stack
  DEPENDS:=+libpthread +librt
endef

define Package/bacnet-stack-router-ipv6/description
  This package is built with Routing BIP6 BIP support.
endef


CMAKE_OPTIONS+= \
	-DBACDL_ARCNET:BOOL=OFF \
	-DBACDL_BIP:BOOL=ON \
	-DBACDL_BIP6:BOOL=ON \
	-DBACDL_BSC:BOOL=OFF \
	-DBACDL_ETHERNET:BOOL=OFF \
	-DBACDL_MSTP:BOOL=OFF \
	-DBAC_ROUTING:BOOL=ON \
	-DUCI:BOOL=OFF \
	-DSERVER_UCI:BOOL=OFF \
	-DBACNET_PROTOCOL_REVISION=24 \
	-DBACNET_STACK_DEPRECATED_DISABLE:BOOL=ON \
	-DCMAKE_BUILD_TYPE="Release"

define Package/bacnet-stack-router-ipv6/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/router-ipv6 $(1)/usr/sbin/bacrouter-ipv6
endef

$(eval $(call BuildPackage,bacnet-stack-router-ipv6))
