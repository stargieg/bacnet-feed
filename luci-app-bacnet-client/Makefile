include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-bacnet-client
PKG_VERSION:=0.2.4
PKG_RELEASE:=6
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-bacnet-client
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=Bacnet Device
  EXTRA_DEPENDS:=luci-mod-admin-full, msmtp
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
	grep -q "eventlist.json.get" /etc/crontabs/root || echo "*/5 * *  *  * touch /tmp/eventlist.json.get" >> /etc/crontabs/root
	grep -q "rsync -a -d /tmp/rrd /etc/luci-uploads/" /etc/crontabs/root || echo "21 */1 *  *  * rsync -a -d /tmp/rrd /etc/luci-uploads/" >> /etc/crontabs/root
	/etc/init.d/cron restart
	if [ ! grep -q collectd-exec-bacnet.sh /etc/config/luci_statistics ] ; then
		uci set luci_statistics.bacnet='collectd_exec_input'
		uci set luci_statistics.bacnet.cmdline='/etc/collectd-exec-bacnet1.sh'
		uci set luci_statistics.bacnet.cmduser='nobody'
		uci set luci_statistics.bacnet.cmdgroup='nogroup'
		uci commit luci_statistics
	fi
fi
endef

define Package/luci-app-bacnet-client/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./root/etc/config/bacnetclient $(1)/etc/config/bacnetclient
	$(INSTALL_BIN) ./root/etc/collectd-exec-bacnet.sh $(1)/etc
	$(INSTALL_DIR) $(1)/www/luci-static/resources/view
	$(INSTALL_DATA) ./htdocs/luci-static/resources/view/* $(1)/www/luci-static/resources/view
	$(INSTALL_DIR) $(1)/www/luci-static/resources/statistics/rrdtool/definitions
	$(INSTALL_DATA) ./htdocs/luci-static/resources/statistics/rrdtool/definitions/* $(1)/www/luci-static/resources/statistics/rrdtool/definitions
	$(INSTALL_DIR) $(1)/usr/share/luci/menu.d
	$(INSTALL_DATA) ./root/usr/share/luci/menu.d/* $(1)/usr/share/luci/menu.d
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) ./root/usr/share/rpcd/acl.d/* $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DIR) $(1)/usr/libexec/rpcd
	$(INSTALL_BIN) ./root/usr/libexec/rpcd/* $(1)/usr/libexec/rpcd
endef

$(eval $(call BuildPackage,luci-app-bacnet-client))
