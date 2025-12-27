include $(TOPDIR)/rules.mk

PKG_NAME:=bacnet-stack-sc-hub
PKG_RELEASE:=1
PKG_SOURCE_URL:=https://github.com/bacnet-stack/bacnet-stack.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2025-12-27
PKG_SOURCE_VERSION:=a15ec5e
PKG_MIRROR_HASH:=221a73ffa550b576d5d85d27d4f99343c17f45e692a4e153d3dbc28aa99b1ce3

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
	-DBACDL_ZIGBEE:BOOL=OFF \
	-DBAC_ROUTING:BOOL=OFF \
	-DUCI:BOOL=OFF \
	-DBACNET_STACK_BUILD_APPS:BOOL=ON \
	-DINTRINSIC_REPORTING:BOOL=OFF \
	-DBACNET_PROPERTY_LISTS:BOOL=OFF \
	-DBACNET_BUILD_SERVER_MINI_APP:BOOL=OFF \
	-DBACNET_BUILD_SERVER_BASIC_APP:BOOL=OFF \
	-DBACNET_BUILD_BACPOLL_APP:BOOL=OFF \
	-DBACNET_BUILD_BACDISCOVER_APP:BOOL=OFF \
	-DBACNET_PROTOCOL_REVISION=24 \
	-DBACNET_STACK_DEPRECATED_DISABLE:BOOL=ON \
	-DCMAKE_BUILD_TYPE="Release"

define Package/bacnet-stack-sc-hub/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/sc-hub $(1)/usr/sbin/sc-hub
endef

$(eval $(call BuildPackage,bacnet-stack-sc-hub))
