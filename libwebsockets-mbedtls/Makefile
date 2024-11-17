#
# Copyright (C) 2014-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libwebsockets-mbedtls
PKG_VERSION:=4.3.3
PKG_RELEASE:=1

PKG_SOURCE:=libwebsockets-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=libwebsockets-$(PKG_VERSION)
PKG_SOURCE_URL:=https://codeload.github.com/warmcat/libwebsockets/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=6fd33527b410a37ebc91bb64ca51bdabab12b076bc99d153d7c5dd405e4bdf90
PKG_BUILD_DIR:=$(BUILD_DIR)/libwebsockets-$(PKG_VERSION)
PKG_SOURCE_VERSION:=v$(PKG_VERSION)

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=libubox

CMAKE_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

CMAKE_OPTIONS += -DLWS_IPV6=$(if $(CONFIG_IPV6),ON,OFF)
CMAKE_OPTIONS += -DISABLE_WERROR=ON
CMAKE_OPTIONS += -DCMAKE_BUILD_TYPE=Release
CMAKE_OPTIONS += -DLWS_WITH_EXTERNAL_POLL=ON
CMAKE_OPTIONS += -DLWS_WITH_ULOOP=ON

# turn off all test apps
CMAKE_OPTIONS += -DLWS_WITHOUT_TESTAPPS=ON
CMAKE_OPTIONS += -DLWS_WITHOUT_TEST_SERVER=ON
CMAKE_OPTIONS += -DLWS_WITHOUT_TEST_SERVER_EXTPOLL=ON
CMAKE_OPTIONS += -DLWS_WITHOUT_TEST_PING=ON
CMAKE_OPTIONS += -DLWS_WITHOUT_TEST_CLIENT=ON

define Package/libwebsockets-mbedtls/Default
	SECTION:=libs
	CATEGORY:=Libraries
	TITLE:=libwebsockets (mbedTLS)
	DEPENDS:=+zlib +libcap +libubox +libmbedtls
	URL:=https://libwebsockets.org
	MAINTAINER:=Karl Palsson <karlp@etactica.com>
endef

define Package/libwebsockets-mbedtls-small
	$(call Package/libwebsockets-mbedtls/Default)
	TITLE +=(Small)
	CONFLICTS:=libwebsockets-openssl libwebsockets-mbedtls-full
	PROVIDES:=libwebsockets libwebsockets-small libwebsockets-mbedtls libwebsockets-mbedtls-small
	VARIANT:=small
endef

define Package/libwebsockets-mbedtls-full
	$(call Package/libwebsockets-mbedtls/Default)
	TITLE +=(Full - OpenSSL, libuv, plugins, CGI)
	DEPENDS +=+libuv
	CONFLICTS:=libwebsockets-openssl
	PROVIDES:=libwebsockets libwebsockets-full libwebsockets-mbedtls libwebsockets-mbedtls-full
	VARIANT:=full
endef

CMAKE_OPTIONS += -DLWS_WITH_MBEDTLS=1

ifeq ($(BUILD_VARIANT),full)
    CMAKE_OPTIONS += -DLWS_WITH_LIBUV=ON
    CMAKE_OPTIONS += -DLWS_WITH_PLUGINS=ON
    CMAKE_OPTIONS += -DLWS_WITH_SERVER_STATUS=ON
    CMAKE_OPTIONS += -DLWS_WITH_ACCESS_LOG=ON
    CMAKE_OPTIONS += -DLWS_WITH_CGI=ON
    CMAKE_OPTIONS += -DLWS_UNIX_SOCK=ON
endif

define Package/libwebsockets-mbedtls-small/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libwebsockets*.so* $(1)/usr/lib/
endef

define Package/libwebsockets-mbedtls-full/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libwebsockets*.so* $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libwebsockets-evlib_uv.so* $(1)/usr/lib
endef

$(eval $(call BuildPackage,libwebsockets-mbedtls-small))
$(eval $(call BuildPackage,libwebsockets-mbedtls-full))
