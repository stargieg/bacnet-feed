#!/bin/sh
#opkg install collectd-mod-exec

INTERVAL=$(echo ${COLLECTD_INTERVAL:-60} | cut -d . -f 1)
INTERVAL=$((INTERVAL*10))
rm -f /tmp/collect.txt
rm -f /tmp/collect.txt.old
while true; do
	if [ ! -f /tmp/collect.txt ] ; then
		touch /tmp/collect.get 2>/dev/null
		sleep 10
		continue
	fi
	cat /tmp/collect.txt
	mv /tmp/collect.txt /tmp/collect.txt.old
	sleep "$INTERVAL"
done
