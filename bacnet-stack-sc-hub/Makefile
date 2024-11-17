include $(TOPDIR)/rules.mk

PKG_NAME:=bacnet-stack-sc-hub
PKG_VERSION:=1.3.8
PKG_RELEASE:=1
PKG_SOURCE_URL:=https://github.com/bacnet-stack/bacnet-stack.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2024-11-03
PKG_SOURCE_VERSION:=master
PKG_MIRROR_HASH:=skip

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
