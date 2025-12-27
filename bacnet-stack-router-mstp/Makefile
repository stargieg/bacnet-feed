include $(TOPDIR)/rules.mk

PKG_NAME:=bacnet-stack-router-mstp
PKG_RELEASE:=1
PKG_SOURCE_URL:=https://github.com/bacnet-stack/bacnet-stack.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2025-12-27
PKG_SOURCE_VERSION:=a15ec5e
PKG_MIRROR_HASH:=5a7519fa0a8079ac6af1078ae124c94434668679fff25c4eebb14a29e71eec34

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/bacnet-stack-router-mstp
  SECTION:=net
  CATEGORY:=Network
  DEFAULT:=m
  TITLE:=BACnet Protocol Stack (ROUTER BIP MSTP)
  URL:=https://github.com/bacnet-stack
  DEPENDS:=+libpthread +librt
endef

define Package/bacnet-stack-router-mstp/Default/description
  Data Communication Protocol for Building Automation and Control Networks
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

define Package/bacnet-stack-router-mstp/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/router-mstp $(1)/usr/sbin/bacrouter-mstp
endef

$(eval $(call BuildPackage,bacnet-stack-router-mstp))
