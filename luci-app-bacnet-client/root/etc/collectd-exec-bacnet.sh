#!/bin/sh
#opkg install collectd-mod-exec

[ -f /lib/functions.sh ] && . /lib/functions.sh
[ -f /usr/share/libubox/jshn.sh ] && . /usr/share/libubox/jshn.sh

set -o pipefail

HOST="$COLLECTD_HOSTNAME"
INTERVAL=$(echo ${COLLECTD_INTERVAL:-8} | cut -d . -f 1)
BACNET_INTERVAL="900"

log() {
	if [ "$BACNET_DEBUG" == "1" ] ; then
		logger -t collectd-bacnet "$@"
	fi
}

get_config() {
	config_load bacnetclient
	export BACNET_IFACE=""
	config_get iface default iface "br-lan"
	[ -z "$iface" ] || export BACNET_IFACE="$iface"
	export BACNET_IP_PORT=""
	config_get port default port
	#set random src port with bbmd
	#rand="$(echo -n $(head -n 1 /dev/urandom 2>/dev/null | md5sum | cut -b 1-5))"
	#port="$(printf "%d" "0x$rand")"
	[ -z "$port" ] || export BACNET_IP_PORT="$port"
	export BACNET_BBMD_ADDRESS=""
	config_get bbmd_addr default bbmd_addr
	[ -z "$bbmd_addr" ] || export BACNET_BBMD_ADDRESS="$bbmd_addr"
	export BACNET_BBMD_PORT=""
	config_get bbmd_port default bbmd_port
	[ -z "$bbmd_port" ] || export BACNET_BBMD_PORT="$bbmd_port"
	export BACNET_DENY_LIST=""
	config_get deny_list default deny_list
	[ -z "$deny_list" ] || export BACNET_DENY_LIST="$deny_list"
	export BACNET_DEBUG="0"
	config_get debug default debug
	[ -z "$debug" ] || export BACNET_DEBUG="$debug"
	export BACNET_INTERVAL="900"
	config_get interval default interval
	[ -z "$interval" ] || export BACNET_INTERVAL="$interval"
	log "$BACNET_IFACE $BACNET_IP_PORT $BACNET_BBMD_ADDRESS $BACNET_BBMD_PORT $BACNET_INTERVAL"
}

while true; do
	get_config
	if [ ! -f /tmp/devlist.json ] ; then
		touch /tmp/devlist.json.get
		log "sleep 10 /tmp/devlist.json.get"
		sleep 10
		continue
	fi
	devids=""
	json_load_file /tmp/devlist.json
	json_select "list"
	k=1;while json_is_a ${k} object;do
		json_select ${k}
		json_get_var devid devid
		deny=0
		for deny_id in $BACNET_DENY_LIST ; do
			if [ "$devid" == "$deny_id" ] ; then
				deny=1
			fi
		done
		if [ "$deny" == "0" ] ; then
			devids="$devids $devid"
		fi

		k=$(( k + 1 ))
		json_select ..
	done
	log "devids: $devids"
	json_cleanup
	if [ "$devids" == "" ] ; then
		touch /tmp/devlist.json.get
		log "sleep 10 /tmp/devlist.json.get no device"
		sleep 10
		continue
	fi
	interval_offset=0
	for devid in $devids; do
		if [ ! -f /tmp/objlist_$devid.json ] ; then
			touch /tmp/objlist.json.get
			touch /tmp/objlist_$devid.json.get
			log "sleep 10 /tmp/objlist_$devid.json.get"
			sleep 10
			interval_offset="$BACNET_INTERVAL"
			continue
		fi
		json_load_file /tmp/obj$devid.json
		json_select "list"
		objs=""
		l=1;while json_is_a ${l} object;do
			json_select ${l}
			json_get_keys object_type
			#FIME space and underline
			if [ "$object_type" == " trend_log" ] ; then
				json_get_var object_instance $object_type
				objs="$objs $object_instance"
			fi
			json_select ..
			l=$(( l + 1 ))
		done
		log "objs: $objs"
		json_cleanup
		if [ "$objs" == "" ] ; then
			touch /tmp/objlist.json.get
			touch /tmp/objlist_$devid.json.get
			log "sleep 10 /tmp/objlist_$devid.json.get no objects"
			sleep 10
			interval_offset="$BACNET_INTERVAL"
			continue
		fi
		for obj_id in $objs ; do
			log "bacrp $devid trend-log $obj_id 141"
			count="$(bacrp $devid trend-log $obj_id 141 | tr -d '\r')"
			[ "$?" == "0" ] || continue
			log "bacrp $devid trend-log $obj_id 132"
			ref="$(bacrp $devid trend-log $obj_id 132 | tr -d '\r')"
			[ "$?" == "0" ] || continue
			j=1
			ref_devid="$devid"
			for opt in $ref ; do
				case $j in
				1) [ "$opt" == "-1" ] || ref_devid="$opt" ;;
				2) ref_object_type="$opt" ;;
				3) ref_object_instance="$opt" ;;
				4) ref_object_property="$opt" ;;
				esac
				j=$(( j + 1 ))
			done
			dev_name="$(bacrp $ref_devid device $ref_devid object-name | tr -d '\r' | tr -s ' ' '_' | sed 's/\ä/ae/g;s/\Ä/Ae/g;s/\ö/oe/g;s/\Ö/Oe/g;s/\ü/ue/g;s/\Ü/Ue/g;s/\ß/ss/g')"
			[ "$?" == "0" ] || continue
			object_name="$(bacrp $ref_devid $ref_object_type $ref_object_instance object-name | tr -d '\r' | tr -s ' ' '_' | sed 's/\ä/ae/g;s/\Ä/Ae/g;s/\ö/oe/g;s/\Ö/Oe/g;s/\ü/ue/g;s/\Ü/Ue/g;s/\ß/ss/g')"
			[ "$?" == "0" ] || continue
			Description="$(bacrp $ref_devid $ref_object_type $ref_object_instance Description | tr -d '\r' | tr -s ' ' '_'| sed 's/\ä/ae/g;s/\Ä/Ae/g;s/\ö/oe/g;s/\Ö/Oe/g;s/\ü/ue/g;s/\Ü/Ue/g;s/\ß/ss/g')"
			[ "$?" == "0" ] || continue
			ret=0
			case $ref_object_type in
				analog*)
					log "bacrp $ref_devid $ref_object_type $ref_object_instance units"
					value_units="$(bacrp $ref_devid $ref_object_type $ref_object_instance units | tr -d '\r')"
					ret="$?"
					;;
				binary*)
					log "bacrp $ref_devid $ref_object_type $ref_object_instance state"
					value_units="binary"
					ret="$?"
					;;
				*)
					value_units="unknown"
					count=-1
					;;
			esac
			[ "$ret" == "0" ] || continue
			case $value_units in
				cubic-meters-per-hour)
					collectd_plugin="flowrate"
					collectd_types="flow"
				;;
				percent-relative-humidity)
					collectd_plugin="humidity"
					collectd_types="humidity"
				;;
				parts-per-million)
					collectd_plugin="ppm"
					collectd_types="objects"
				;;
				degrees-celsius)
					collectd_plugin="thermal"
					collectd_types="temperature"
				;;
				percent)
					collectd_plugin="control"
					collectd_types="percent"
				;;
				binary)
					collectd_plugin="binary"
					collectd_types="bool"
				;;
				*)
					count=-1
				;;
			esac
			range=10
			drange=$range
			srange=1
			new=0
			plugin_id="$object_name"":""$Description"
			[ -f "/tmp/rrd/$dev_name/$collectd_plugin-$plugin_id/$collectd_types.rrd" ] || new="1"
			while [ $count -ge $drange ] ; do
				status=0
				if [ "$new" == "1" ] ; then
					log "bacrr $devid trend-log $obj_id log-buffer 1 $srange $range"
					bacrr $devid trend-log $obj_id log-buffer 1 $srange $range > /tmp/bactrt.json 2>/dev/null || status=1
				else
					epoche=$(rrdtool last "/tmp/rrd/$dev_name/$collectd_plugin-$plugin_id/$collectd_types.rrd")
					date_slot=$(date -d "@$epoche" "+%Y/%m/%d")
					time_slot=$(date -d "@$epoche" "+%H:%M:%S")
					log "bacrr $devid trend-log $obj_id log-buffer 3 $date_slot $time_slot 60"
					bacrr $devid trend-log $obj_id log-buffer 3 $date_slot $time_slot 60 > /tmp/bactrt.json 2>/dev/null || status=1
					count=-1
				fi
				grep -q list /tmp/bactrt.json || status=1
				drange=$(( drange + range ))
				srange=$(( srange + range ))
				if [ "$status" == "0" ] ; then
					json_load_file /tmp/bactrt.json
					json_select "list"

					i=1;while json_is_a ${i} array;do
							json_select $i
							json_get_var time 1
							json_get_var timeval 2
							case $ref_object_type in
								binary*)
									if [ "$timeval" == "active" ] ; then
										timeval=1
									else
										timeval=0
									fi
									;;
							esac
							utime=$(date -d "$time" -D "%Y-%m-%dT%H:%M:%S" +"%s")
							log "PUTVAL $dev_name/$collectd_plugin-$plugin_id/$collectd_types interval=$INTERVAL $utime:$timeval"
							echo "PUTVAL $dev_name/$collectd_plugin-$plugin_id/$collectd_types interval=$INTERVAL $utime:$timeval"
							i=$(( i + 1 ))
							json_select ..
					done

					json_select ..
					json_cleanup
				fi
				rm -f /tmp/bactrt.json
			done
			utime=$(date +"%s")
			value="$(bacrp $ref_devid $ref_object_type $ref_object_instance $ref_object_property | tr -d '\r')"
			case $ref_object_type in
				binary*)
					if [ "$value" == "active" ] ; then
						value=1
					else
						value=0
					fi
					;;
			esac
			log "PUTVAL $dev_name/$collectd_plugin-$plugin_id/$collectd_types interval=$INTERVAL $utime:$value"
			echo "PUTVAL $dev_name/$collectd_plugin-$plugin_id/$collectd_types interval=$INTERVAL $utime:$value"
		done
		log "devid $devids $devid"
	done
	log "sleep $(( BACNET_INTERVAL - interval_offset ))"
	sleep "$(( BACNET_INTERVAL - interval_offset ))"
done
