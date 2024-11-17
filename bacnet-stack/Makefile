include $(TOPDIR)/rules.mk

PKG_NAME:=bacnet-stack
PKG_VERSION:=1.3.8
PKG_RELEASE:=1
#PKG_SOURCE_URL:=https://github.com/bacnet-stack/bacnet-stack.git
PKG_SOURCE_URL:=https://github.com/stargieg/bacnet-stack-upstream.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2024-11-03
PKG_SOURCE_VERSION:=server-uci
PKG_MIRROR_HASH:=skip

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/bacnet-stack/Default
  SECTION:=net
  CATEGORY:=Network
  DEFAULT:=m
  TITLE:=BACnet Protocol Stack
  URL:=https://github.com/bacnet-stack
  DEPENDS:=+libpthread +librt
endef

define Package/bacnet-stack/Default/description
  Data Communication Protocol for Building Automation and Control Networks
endef

define Package/bacnet-stack-utils-base
$(call Package/bacnet-stack/Default)
  TITLE+= (Utils Basic)
endef
define Package/bacnet-stack-utils-base/description
  This package is a BACnet utils bacrp,bacepics.
endef

define Package/bacnet-stack-utils-full
$(call Package/bacnet-stack/Default)
  TITLE+= (Utils Full)
  DEPENDS:=bacnet-stack-utils-base
endef
define Package/bacnet-stack-utils-full/description
  This package is a BACnet utils bacpoll,bacmstpcap.
endef

CMAKE_OPTIONS+= \
	-DBACDL_ARCNET:BOOL=OFF \
	-DBACDL_BIP:BOOL=ON \
	-DBACDL_BIP6:BOOL=OFF \
	-DBACDL_BSC:BOOL=OFF \
	-DBACDL_ETHERNET:BOOL=OFF \
	-DBACDL_MSTP:BOOL=OFF \
	-DBAC_ROUTING:BOOL=OFF \
	-DUCI:BOOL=OFF \
	-DSERVER_UCI:BOOL=OFF \
	-DBACNET_PROTOCOL_REVISION=24 \
	-DBACNET_STACK_DEPRECATED_DISABLE:BOOL=ON \
	-DCMAKE_BUILD_TYPE="Release"

UTILS_BASE+=ack-alarm
UTILS_BASE+=dcc
UTILS_BASE+=epics
UTILS_BASE+=event
UTILS_BASE+=getevent
UTILS_BASE+=netnumis
UTILS_BASE+=readfile
UTILS_BASE+=readprop
UTILS_BASE+=readpropm
UTILS_BASE+=readrange
UTILS_BASE+=timesync
UTILS_BASE+=whois
UTILS_BASE+=whoisrouter
UTILS_BASE+=writefile
UTILS_BASE+=writegroup
UTILS_BASE+=writeprop
UTILS_BASE+=writepropm

define Package/bacnet-stack-utils-base/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(foreach bacfile,$(UTILS_BASE),$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(bacfile) $(1)/usr/bin/bac$(bacfile) ;)
	$(LN) /usr/bin/bacgetevent $(1)/usr/bin/bacge
	$(LN) /usr/bin/bacreadprop $(1)/usr/bin/bacrp
	$(LN) /usr/bin/bacreadpropm $(1)/usr/bin/bacrpm
	$(LN) /usr/bin/bacreadrange $(1)/usr/bin/bacrr
	$(LN) /usr/bin/bacwhois $(1)/usr/bin/bacwi
	$(LN) /usr/bin/bacwriteprop $(1)/usr/bin/bacwp
	$(INSTALL_BIN) ./files/eventlist.sh $(1)/usr/bin/
endef

UTILS_FILES=abort
UTILS_FILES+=add-list-element
UTILS_FILES+=apdu
UTILS_FILES+=create-object
UTILS_FILES+=delete-object
UTILS_FILES+=error
#UTILS_FILES+=gateway
UTILS_FILES+=iam
UTILS_FILES+=iamrouter
UTILS_FILES+=initrouter
#UTILS_FILES+=mstpcap
#UTILS_FILES+=mstpcrc
UTILS_FILES+=readbdt
UTILS_FILES+=readfdt
UTILS_FILES+=reinit
UTILS_FILES+=remove-list-element
UTILS_FILES+=scov
UTILS_FILES+=ucov
UTILS_FILES+=uevent
UTILS_FILES+=uptransfer
UTILS_FILES+=whatisnetnum
UTILS_FILES+=whohas

define Package/bacnet-stack-utils-full/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(foreach bacfile,$(UTILS_FILES),$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(bacfile) $(1)/usr/bin/bac$(bacfile) ;)
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/server $(1)/usr/sbin/bacserver
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bacdiscover $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bacpoll $(1)/usr/sbin/
endef


$(eval $(call BuildPackage,bacnet-stack-utils-base))
$(eval $(call BuildPackage,bacnet-stack-utils-full))
