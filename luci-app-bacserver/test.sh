#!/bin/bash
#1 root@raspian.ff.lunatiki.de:

rsync -av ./htdocs/luci-static/resources/view/* $1/www/luci-static/resources/view
rsync -av ./root/usr/share/luci/menu.d/* $1/usr/share/luci/menu.d
rsync -av ./root/usr/share/rpcd/acl.d/* $1/usr/share/rpcd/acl.d
