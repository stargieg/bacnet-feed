# OpenWrt bacnet stackfeed

## Description

This is the OpenWrt "bacnet"-feed containing open-source BACnet Protocol Stack in C.

## Usage

This repository is intended to be layered on-top of an OpenWrt buildroot.
If you do not have an OpenWrt buildroot installed, see the documentation at:
[OpenWrt Buildroot – Installation](https://openwrt.org/docs/guide-developer/build-system/install-buildsystem) on the OpenWrt support site.

This feed is not enabled by default. Your feeds.conf should contain a line like:
```
src-git bacnet https://github.com/stargieg/bacnet-feed.git
```

To install all its package definitions, run:
```
grep " packages" feeds.conf.default > feeds.conf
echo "src-git bacnet https://github.com/stargieg/bacnet-feed.git >> feeds.conf
./scripts/feeds update packages
./scripts/feeds update bacnet
./scripts/feeds install -a -p bacnet
./scripts/feeds uninstall libwebsockets 2>/dev/null
```

### Usage of OpenWRT SDK

[Using the SDK](https://openwrt.org/docs/guide-developer/toolchain/using_the_sdk)

This example is for the most common use mips_24kc arch

```
wget https://downloads.openwrt.org/releases/23.05.5/targets/ath79/generic/openwrt-sdk-23.05.5-ath79-generic_gcc-12.3.0_musl.Linux-x86_64.tar.xz
tar -x -f openwrt-sdk-23.05.5-ath79-generic_gcc-12.3.0_musl.Linux-x86_64.tar.xz
cd openwrt-sdk-23.05.5-ath79-generic_gcc-12.3.0_musl.Linux-x86_64
grep " base" feeds.conf.default > feeds.conf
grep " packages" feeds.conf.default >> feeds.conf
echo "src-git bacnet https://github.com/stargieg/bacnet-feed.git" >> feeds.conf
./scripts/feeds update
./scripts/feeds install -a -p bacnet
./scripts/feeds uninstall libwebsockets 2>/dev/null
cat << EOF > .config
# CONFIG_ALL_NONSHARED is not set
# CONFIG_ALL_KMODS is not set
# CONFIG_ALL is not set
CONFIG_NO_STRIP=y
# CONFIG_AUTOREBUILD is not set
# CONFIG_AUTOREMOVE is not set
# CONFIG_IMAGEOPT is not set
CONFIG_PACKAGE_bacnet-stack-utils-arcnet=m
CONFIG_PACKAGE_bacnet-stack-utils-bip=m
CONFIG_PACKAGE_bacnet-stack-utils-bip6=m
CONFIG_PACKAGE_bacnet-stack-utils-ethernet=m
CONFIG_PACKAGE_bacnet-stack-utils-mstp=m
CONFIG_PACKAGE_luci-app-bacnet-client=m
CONFIG_PACKAGE_bacnet-stack-server=m
CONFIG_PACKAGE_luci-app-bacserver=m
CONFIG_PACKAGE_bacnet-stack-router=m
CONFIG_PACKAGE_bacnet-stack-router-mstp=m
CONFIG_PACKAGE_luci-app-bacrouter=m
CONFIG_PACKAGE_bacnet-stack-sc-hub=m
# CONFIG_PACKAGE_libwebsockets-mbedtls-full is not set
# CONFIG_PACKAGE_libwebsockets-mbedtls-small is not set
CONFIG_PACKAGE_libwebsockets-openssl-full=m
# CONFIG_PACKAGE_libwebsockets-openssl-small is not set
EOF
make defconfig
make package/feeds/bacnet/bacnet-stack/compile
make package/feeds/bacnet/bacnet-stack-server/compile
make package/feeds/bacnet/bacnet-stack-router/compile
make package/feeds/bacnet/bacnet-stack-router-mstp/compile
make package/feeds/bacnet/bacnet-stack-router-ipv6/compile
make package/feeds/bacnet/bacnet-stack-sc-hub/compile
make package/feeds/bacnet/luci-app-bacrouter/compile
make package/feeds/bacnet/luci-app-bacnet-client/compile
make package/feeds/bacnet/luci-app-bacserver/compile
```
After the compilation is finished, the generated .ipk files are placed in the bin/packages directories inside the directory you extracted the SDK into.

### Usage of OpenWRT IB

[Using the imagebuilder (IB)](https://openwrt.org/docs/guide-user/additional-software/imagebuilder)

This example is for the most common use mips_24kc arch

```
wget https://downloads.openwrt.org/releases/23.05.5/targets/ath79/generic/openwrt-imagebuilder-23.05.5-ath79-generic.Linux-x86_64.tar.xz
tar -x -f openwrt-imagebuilder-23.05.5-ath79-generic.Linux-x86_64.tar.xz
cd openwrt-imagebuilder-23.05.5-ath79-generic.Linux-x86_64
cat << EOF >> repositories.conf
src/gz bacnet http://feeds.lunatiki.de/bacnet/releases/23.05.5/mips_24kc
EOF
wget -O keys/152ccf91cd6bfbdd http://feeds.lunatiki.de/bacnet/releases/23.05.5/mips_24kc/152ccf91cd6bfbdd
make image PROFILE="glinet_gl-mifi" PACKAGES="luci-app-bacrouter"
```
After the build is finished, the generated firmware files are placed in the bin/targets directories inside the directory you extracted the IB into.

## Binary Packages (opkg)

You can install prebuild packages via opkg.
Add feed public key and feed url
### releases/23.05.5 ath79 generic
```
wget -O /etc/opkg/keys/152ccf91cd6bfbdd http://feeds.lunatiki.de/bacnet/releases/23.05.5/mips_24kc/152ccf91cd6bfbdd
echo 'src/gz bacnet http://feeds.lunatiki.de/bacnet/releases/23.05.5/mips_24kc' >> /etc/opkg/customfeeds.conf
```
### releases/23.05.5 bcm27xx bcm2709
```
wget -O /etc/opkg/keys/152ccf91cd6bfbdd http://feeds.lunatiki.de/bacnet/releases/23.05.5/arm_cortex-a7_neon-vfpv4/152ccf91cd6bfbdd
echo 'src/gz bacnet http://feeds.lunatiki.de/bacnet/releases/23.05.5/arm_cortex-a7_neon-vfpv4' >> /etc/opkg/customfeeds.conf
```
### releases/23.05.5 ipq806x generic
```
wget -O /etc/opkg/keys/152ccf91cd6bfbdd http://feeds.lunatiki.de/bacnet/releases/23.05.5/arm_cortex-a15_neon-vfpv4/152ccf91cd6bfbdd
echo 'src/gz bacnet http://feeds.lunatiki.de/bacnet/releases/23.05.5/arm_cortex-a15_neon-vfpv4' >> /etc/opkg/customfeeds.conf
```
### releases/23.05.5 x86 64
```
wget -O /etc/opkg/keys/152ccf91cd6bfbdd http://feeds.lunatiki.de/bacnet/releases/23.05.5/x86_64/152ccf91cd6bfbdd
echo 'src/gz bacnet http://feeds.lunatiki.de/bacnet/releases/23.05.5/x86_64' >> /etc/opkg/customfeeds.conf
```
### releases/23.05.5 x86 generic
```
wget -O /etc/opkg/keys/152ccf91cd6bfbdd http://feeds.lunatiki.de/bacnet/releases/23.05.5/i386_pentium4/152ccf91cd6bfbdd
echo 'src/gz bacnet http://feeds.lunatiki.de/bacnet/releases/23.05.5/i386_pentium4' >> /etc/opkg/customfeeds.conf
```


Install demo apps, server or router
```
opkg update
opkg install bacnet-stack-utils-base
# or
opkg install luci-app-bacserver
# or
opkg install luci-app-bacrouter
# or
opkg install luci-app-bacnet-client
```

## Development

Documentation for developing and extending bacnet stack can be found on [Github](https://github.com/bacnet-stack/) , the [Documantation](https://bacnet.sourceforge.net/) and the [Chat](https://bacnet-stack.slack.com/archives/C07KB8MHX19)

