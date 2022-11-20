#!/bin/bash
#1 root@raspian.ff.lunatiki.de:

scp ./root/etc/config/bacnetclient $1/etc/config/bacnetclient
scp ./htdocs/luci-static/resources/view/* $1/www/luci-static/resources/view
scp ./root/usr/share/luci/menu.d/* $1/usr/share/luci/menu.d
scp ./root/usr/share/rpcd/acl.d/* $1/usr/share/rpcd/acl.d
scp ./root/usr/libexec/rpcd/* $1/usr/libexec/rpcd
