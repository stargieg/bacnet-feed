include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-bacnet-client
PKG_VERSION:=0.2.4
PKG_RELEASE:=5
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-bacnet-client
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=Bacnet Device
  EXTRA_DEPENDS:=luci-mod-admin-full, iconv
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-bacnet-client/conffiles
/etc/config/bacnetclient
endef

define Package/luci-app-bacnet-client/postinst
#!/bin/sh
if [ -z $${IPKG_INSTROOT} ] ; then
	rm -rf /tmp/luci-*
	/etc/init.d/rpcd restart
	grep -q "bacnetclient call _cron" /etc/crontabs/root || echo "* * *  *  * /usr/libexec/rpcd/bacnetclient call _cron" >> /etc/crontabs/root
	/etc/init.d/cron restart
fi
endef

define Package/luci-app-bacnet-client/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./root/etc/config/bacnetclient $(1)/etc/config/bacnetclient
	$(INSTALL_DIR) $(1)/www/luci-static/resources/view
	$(INSTALL_DATA) ./htdocs/luci-static/resources/view/* $(1)/www/luci-static/resources/view
	$(INSTALL_DIR) $(1)/usr/share/luci/menu.d
	$(INSTALL_DATA) ./root/usr/share/luci/menu.d/* $(1)/usr/share/luci/menu.d
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) ./root/usr/share/rpcd/acl.d/* $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DIR) $(1)/usr/libexec/rpcd
	$(INSTALL_BIN) ./root/usr/libexec/rpcd/* $(1)/usr/libexec/rpcd
endef

$(eval $(call BuildPackage,luci-app-bacnet-client))
