#
# Copyright (C) 2014-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libwebsockets-openssl
PKG_VERSION:=4.3.3
PKG_RELEASE:=1

PKG_SOURCE:=libwebsockets-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=libwebsockets-$(PKG_VERSION)
PKG_SOURCE_URL:=https://codeload.github.com/warmcat/libwebsockets/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=6fd33527b410a37ebc91bb64ca51bdabab12b076bc99d153d7c5dd405e4bdf90
PKG_BUILD_DIR:=$(BUILD_DIR)/libwebsockets-$(PKG_VERSION)
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_CONFIG_DEPENDS:=CONFIG_OPENSSL_WITH_DEPRECATED

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=libubox openssl

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

define Package/libwebsockets-openssl/Default
	SECTION:=libs
	CATEGORY:=Libraries
	TITLE:=libwebsockets (OpenSSL)
	DEPENDS:=+zlib +libcap +libubox +libopenssl +@OPENSSL_WITH_DEPRECATED
	URL:=https://libwebsockets.org
	MAINTAINER:=Karl Palsson <karlp@etactica.com>
endef

define Package/libwebsockets-openssl-small
	$(call Package/libwebsockets-openssl/Default)
	TITLE += (Small)
	CONFLICTS:=libwebsockets-openssl-full libwebsockets-mbedtls
	PROVIDES:=libwebsockets libwebsockets-small libwebsockets-openssl libwebsockets-openssl-small
	VARIANT:=small
endef

define Package/libwebsockets-openssl-full
	$(call Package/libwebsockets-openssl/Default)
	TITLE += (Full - OpenSSL, libuv, plugins, CGI)
	DEPENDS +=+libuv
	CONFLICTS:=libwebsockets-mbedtls
	PROVIDES:= libwebsockets libwebsockets-full libwebsockets-openssl-full
	VARIANT:=full
endef

CMAKE_OPTIONS += -DLWS_OPENSSL_CLIENT_CERTS=/etc/ssl/certs
CMAKE_OPTIONS += -DLWS_WITH_SSL=ON


ifeq ($(BUILD_VARIANT),full)
    CMAKE_OPTIONS += -DLWS_WITH_LIBUV=ON
    CMAKE_OPTIONS += -DLWS_WITH_PLUGINS=ON
    CMAKE_OPTIONS += -DLWS_WITH_SERVER_STATUS=ON
    CMAKE_OPTIONS += -DLWS_WITH_ACCESS_LOG=ON
    CMAKE_OPTIONS += -DLWS_WITH_CGI=ON
    CMAKE_OPTIONS += -DLWS_UNIX_SOCK=ON
endif

define Package/libwebsockets-openssl-small/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libwebsockets*.so* $(1)/usr/lib/
endef

define Package/libwebsockets-openssl-full/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libwebsockets*.so* $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libwebsockets-evlib_uv.so* $(1)/usr/lib
endef

$(eval $(call BuildPackage,libwebsockets-openssl-small))
$(eval $(call BuildPackage,libwebsockets-openssl-full))
