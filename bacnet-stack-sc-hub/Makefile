include $(TOPDIR)/rules.mk

PKG_NAME:=bacnet-stack-sc-hub
PKG_RELEASE:=1
PKG_SOURCE_URL:=https://github.com/bacnet-stack/bacnet-stack.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2025-09-20
PKG_SOURCE_VERSION:=f877ca0
PKG_MIRROR_HASH:=8b93d80091114d5f37b0605ebf11db9a964a08e9a54b1eda3a56c8c81946c4a7

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/bacnet-stack-sc-hub
  SECTION:=net
  CATEGORY:=Network
  DEFAULT:=m
  TITLE:=BACnet Protocol Stack (BSC Hub sevice)
  URL:=https://github.com/bacnet-stack
  DEPENDS:=+libpthread +librt +libwebsockets-full
endef

define Package/bacnet-stack-sc-hub/description
  This package is BSC Hub server.
endef

CMAKE_OPTIONS+= \
	-DBACDL_ARCNET:BOOL=OFF \
	-DBACDL_BIP:BOOL=OFF \
	-DBACDL_BIP6:BOOL=OFF \
	-DBACDL_BSC:BOOL=ON \
	-DBACDL_ETHERNET:BOOL=OFF \
	-DBACDL_MSTP:BOOL=OFF \
	-DBAC_ROUTING:BOOL=OFF \
	-DUCI:BOOL=OFF \
	-DSERVER_UCI:BOOL=OFF \
	-DBACNET_PROTOCOL_REVISION=24 \
	-DBACNET_STACK_DEPRECATED_DISABLE:BOOL=ON \
	-DCMAKE_BUILD_TYPE="Release"

define Package/bacnet-stack-sc-hub/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/sc-hub $(1)/usr/sbin/sc-hub
endef

$(eval $(call BuildPackage,bacnet-stack-sc-hub))
