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
	config_get interval default interval
	[ -z "$interval" ] && interval=900
	export BACNET_INTERVAL="$interval"
	config_get delimeter_name default delimeter_name
	[ -z "$delimeter_name" ] && delimeter_name=":"
	export BACNET_DELIMETER_NAME="$delimeter_name"
	config_get delimeter_desc default delimeter_desc
	[ -z "$delimeter_desc" ] && delimeter_desc="_"
	export BACNET_DELIMETER_DESC="$delimeter_desc"
	config_get delimeter_group_name_count default delimeter_group_name_count
	[ -z "$delimeter_group_name_count" ] && delimeter_group_name_count=1
	export BACNET_DELIMETER_GROUP_NAME_COUNT="$delimeter_group_name_count"
	config_get delimeter_group_desc_count default delimeter_group_desc_count
	[ -z "$delimeter_group_desc_count" ] && delimeter_group_desc_count=2
	export BACNET_DELIMETER_GROUP_DESC_COUNT="$delimeter_group_desc_count"
	DataDir="$(uci get luci_statistics.collectd_rrdtool.DataDir)"
	[ -z "$DataDir" ] && DataDir="/tmp/rrd"
	export RRD_DATADIR="$DataDir"
	log "$BACNET_IFACE $BACNET_IP_PORT $BACNET_BBMD_ADDRESS $BACNET_BBMD_PORT $BACNET_INTERVAL $RRD_DATADIR"
}

while true; do
	get_config
	if [ ! -f /tmp/devlist.json ] ; then
		touch /tmp/devlist.json.get 2>/dev/null
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
		touch /tmp/devlist.json.get 2>/dev/null
		log "sleep 10 /tmp/devlist.json.get no device"
		sleep 10
		continue
	fi
	interval_offset=0
	for devid in $devids; do
		if [ ! -f /tmp/objlist_$devid.json ] ; then
			touch /tmp/objlist.json.get 2>/dev/null
			touch /tmp/objlist_$devid.json.get 2>/dev/null
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
			touch /tmp/objlist.json.get 2>/dev/null
			touch /tmp/objlist_$devid.json.get 2>/dev/null
			log "sleep 10 /tmp/objlist_$devid.json.get no objects"
			sleep 10
			interval_offset="$BACNET_INTERVAL"
			continue
		fi
		dev_name="$(bacrp $devid device $devid object-name)"
		[ "$?" == "0" ] || continue
		dev_name="$(echo $dev_name | tr -d '\r' | tr -s ' ' '_' | sed 's/\ä/ae/g;s/\Ä/Ae/g;s/\ö/oe/g;s/\Ö/Oe/g;s/\ü/ue/g;s/\Ü/Ue/g;s/\ß/ss/g')"
		[ -z "$dev_name" ] && continue

		config_load bacnetclient
		config_get delimeter_name "$devid" delimeter_name
		[ -z "$delimeter_name" ] && delimeter_name="$BACNET_DELIMETER_NAME"
		config_get delimeter_desc "$devid" delimeter_desc
		[ -z "$delimeter_desc" ] && delimeter_desc="$BACNET_DELIMETER_DESC"
		config_get delimeter_group_name_count "$devid" delimeter_group_name_count
		[ -z "$delimeter_group_name_count" ] && delimeter_group_name_count="$BACNET_DELIMETER_GROUP_NAME_COUNT"
		config_get delimeter_group_desc_count "$devid" delimeter_group_desc_count
		[ -z "$delimeter_group_desc_count" ] && delimeter_group_desc_count="$BACNET_DELIMETER_GROUP_DESC_COUNT"

		for obj_id in $objs ; do
			log "bacrp $devid trend-log $obj_id 141"
			count="$(bacrp $devid trend-log $obj_id 141)"
			[ "$?" == "0" ] || continue
			count="$(echo $count | tr -d '\r')"
			log "bacrp $devid trend-log $obj_id 132"
			ref="$(bacrp $devid trend-log $obj_id 132)"
			[ "$?" == "0" ] || continue
			ref="$(echo $ref | tr -d '\r')"
			j=1
			ref_devid=""
			for opt in $ref ; do
				case $j in
				1) [ "$opt" == "-1" ] || ref_devid="$opt" ;;
				2) ref_object_type="$opt" ;;
				3) ref_object_instance="$opt" ;;
				4) ref_object_property="$opt" ;;
				esac
				j=$(( j + 1 ))
			done
			if [ -z "$ref_devid" ] ; then
				ref_devid="$devid"
			else
				dev_name="$(bacrp $ref_devid device $ref_devid object-name)"
				[ "$?" == "0" ] || continue
				dev_name="$(echo $dev_name | tr -d '\r' | tr -s ' ' '_' | sed 's/\ä/ae/g;s/\Ä/Ae/g;s/\ö/oe/g;s/\Ö/Oe/g;s/\ü/ue/g;s/\Ü/Ue/g;s/\ß/ss/g')"
				[ -z "$dev_name" ] && continue
			fi
			object_name="$(bacrp $ref_devid $ref_object_type $ref_object_instance object-name)"
			[ "$?" == "0" ] || continue
			object_name="$(echo $object_name | tr -d '\r' | tr -s ' ' '_' | sed 's/\ä/ae/g;s/\Ä/Ae/g;s/\ö/oe/g;s/\Ö/Oe/g;s/\ü/ue/g;s/\Ü/Ue/g;s/\ß/ss/g')"
			[ -z "$object_name" ] && continue
			Description="$(bacrp $ref_devid $ref_object_type $ref_object_instance Description)"
			[ "$?" == "0" ] || continue
			Description="$(echo $Description | tr -d '\r' | tr -s ' ' '_'| sed 's/\ä/ae/g;s/\Ä/Ae/g;s/\ö/oe/g;s/\Ö/Oe/g;s/\ü/ue/g;s/\Ü/Ue/g;s/\ß/ss/g')"
			ret=0
			case $ref_object_type in
				analog*)
					log "bacrp $ref_devid $ref_object_type $ref_object_instance units"
					value_units="$(bacrp $ref_devid $ref_object_type $ref_object_instance units)"
					ret="$?"
					value_units="$(echo $value_units | tr -d '\r')"
					;;
				binary*)
					log "bacrp $ref_devid $ref_object_type $ref_object_instance state"
					value_units="binary"
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
				pascals)
					collectd_plugin="pascals"
					collectd_types="pressure"
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
			del="$delimeter_name"
			delc="$delimeter_group_name_count"
			plugin_instance_name=$(echo $object_name | cut -d "$del" -f -$delc)
			delc=$((delc + 1))
			plugin_id_name=$(echo $object_name | cut -d "$del" -f $delc-)
			if [ "$Description" == "" ] ; then
				plugin_instance="$plugin_instance_name"
				plugin_id="$plugin_id_name"
			else
				del="$delimeter_desc"
				delc="$delimeter_group_desc_count"
				plugin_instance_description=$(echo $Description | cut -d "$del" -f -$delc)
				delc=$((delc + 1))
				plugin_id_description=$(echo $Description | cut -d "$del" -f $delc-)
				del="$delimeter_desc"
				plugin_instance="$plugin_instance_name""$del""$plugin_instance_description"
				del="$delimeter_name"
				plugin_id="$plugin_id_name""$del""$plugin_id_description"
			fi
			[ -f "$RRD_DATADIR/$dev_name/bac-$plugin_instance/$collectd_types-$plugin_id.rrd" ] || new="1"
			while [ $count -ge $drange ] ; do
				status=0
				if [ "$new" == "1" ] ; then
					log "bacrr $devid trend-log $obj_id log-buffer 1 $srange $range"
					bacrr $devid trend-log $obj_id log-buffer 1 $srange $range > /tmp/bactrt.json 2>/dev/null || status=1
				else
					epoche=$(rrdtool last "$RRD_DATADIR/$dev_name/bac-$plugin_instance/$collectd_types-$plugin_id.rrd")
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
							if [ "$timeval" == "Null" ] ; then
								log "Null $dev_name/bac-$plugin_instance/$collectd_types-$plugin_id"
							else
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
								log "PUTVAL $dev_name/bac-$plugin_instance/$collectd_types-$plugin_id interval=$INTERVAL $utime:$timeval"
								echo "PUTVAL $dev_name/bac-$plugin_instance/$collectd_types-$plugin_id interval=$INTERVAL $utime:$timeval"
							fi
							i=$(( i + 1 ))
							json_select ..
					done

					json_select ..
					json_cleanup
				fi
				rm -f /tmp/bactrt.json
			done
			utime=$(date +"%s")
			value="$(bacrp $ref_devid $ref_object_type $ref_object_instance $ref_object_property)"
			[ "$?" == "0" ] || continue
			value="$(echo $value | tr -d '\r')"
			case $ref_object_type in
				binary*)
					if [ "$value" == "active" ] ; then
						value=1
					else
						value=0
					fi
					;;
			esac
			log "PUTVAL $dev_name/bac-$plugin_instance/$collectd_types-$plugin_id interval=$INTERVAL $utime:$value"
			echo "PUTVAL $dev_name/bac-$plugin_instance/$collectd_types-$plugin_id interval=$INTERVAL $utime:$value"
#			log "PUTVAL $dev_name/$collectd_plugin-$plugin_id/$collectd_types interval=$INTERVAL $utime:$value"
#			echo "PUTVAL $dev_name/$collectd_plugin-$plugin_id/$collectd_types interval=$INTERVAL $utime:$value"
		done
		log "devid $devids $devid"
	done
	log "sleep $(( BACNET_INTERVAL - interval_offset ))"
	sleep "$(( BACNET_INTERVAL - interval_offset ))"
done
