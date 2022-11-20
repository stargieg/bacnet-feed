#!/bin/sh

PATH=$PATH:"/Users/patrick/bacnet-stack-test/bin"
export BACNET_IFACE=en7
[ -f /usr/share/libubox/jshn.sh ] && . /usr/share/libubox/jshn.sh
[ -f /usr/local/share/libubox/jshn.sh ] && . /usr/local/share/libubox/jshn.sh

cd /tmp
bacwi -1 > address_cache

get_event() {
	local data=$1
	OOIFS=$IFS
	IFS=$OIFS
	set $data
	printf "%s," "$(bacrp $1 $2 $3 object-name | tr -d '\r')"
	printf "%s," "$(bacrp $1 $2 $3 Description | tr -d '\r')"
	value="$(bacrp $1 $2 $3 present-value 2>/dev/null | tr -d '\r')"
	case $value in
		active*) printf "%s" "$(bacrp $1 $2 $3 active-text | tr -d '\r')";;
		inactive*) printf "%s" "$(bacrp $1 $2 $3 inactive-text | tr -d '\r')";;
		*[0-9])
			printf "%s," "$value"
			printf "%s," "$(bacrp $1 $2 $3 units | tr -d '\r')"
			printf "%s," "$(bacrp $1 $2 $3 low-limit | tr -d '\r')"
			printf "%s," "$(bacrp $1 $2 $3 high-limit | tr -d '\r')"
		;;
	esac
	IFS=$OOIFS
}

get_eventlist() {
	local id="$1"
	local dev=""
	dev=$(bacrp $id device $id object-name | tr -d '\r')
	#bacge $id|grep $id|while read -r line;do
	OIFS=$IFS
	IFS=$'\n'
	for line in $(bacge $id|grep $id);do
		idx=$((idx+1))
		printf "%s" "$idx"","
		printf "%s" "$dev"","
		get_event "$line"
		printf "\n"
	done
	IFS=$OIFS
}

get_objlist() {
	local id="$1"
	local devname=""
	devname="$(bacrp $id device $id object-name | tr -d '\r')"
	devdesc="$(bacrp $id device $id object-name | tr -d '\r')"
	printf "%s,device,%s,%s,%s\n" "$id" "$id" "$devname" "$devdesc"
	json_init
	bacrp $id device $id object-list | tr -d '\r' | iconv -f ISO-8859-1 -t UTF-8 | sed -e 's/{/{"list": [/' -e 's/}/]}/' -e 's/(\([a-z-]*\), \([0-9]*\))/{"\1": \2}/g' > /tmp/obj.json
	json_load_file /tmp/obj.json
	json_select "list"
	json_for_each_item
	i=1;while json_is_a ${i} object;do
		json_select $i
		json_get_keys object_type
		object_type="$(echo $object_type | tr _ -)"
		json_get_var object_instance $object_type
		printf "%s,%s,%s," "$id" "$object_type" "$object_instance"
		printf "%s," "$(bacrp $id $object_type $object_instance object-name | tr -d '\r')"
		printf "%s" "$(bacrp $id $object_type $object_instance Description | tr -d '\r')"
		#local value="$(bacrp $id $object_type $object_instance present-value 2>/dev/null | tr -d '\r')"
		#case $value in
		#	active*) printf "%s" $(bacrp $id $object_type $object_instance active-text | tr -d '\r');;
		#	inactive*) printf "%s" $(bacrp $id $object_type $object_instance inactive-text | tr -d '\r');;
		#	*[0-9])
		#		printf "%s," "$value"
		#		printf "%s" $(bacrp $id $object_type $object_instance units | tr -d '\r')
		#		;;
		#	*)
		#		printf "%s" "$value"
		#	;;
		#esac
		printf "\n"
		json_select ..
		i=$(( i + 1 ))
	done
	json_cleanup
}

main() {
	local idx=0
	for i in $(bacwi | tr -d '\r' | grep -v ';' | cut -d ' ' -f 3);do
		printf "Index, ISP, Name, Beschreibung, Zustand\n"
		get_eventlist "$i" | iconv -f ISO-8859-1 -t UTF-8
		printf "DevID, ObjTyp, ObjID, Name, Beschreibung\n"
		get_objlist "$i" | iconv -f ISO-8859-1 -t UTF-8
		write_objdesc
		#bin/bacwp 104022 analog-input 0 Description 16 -1 7 "Störung"
		desc="neue umlaute"
		#bin/bacwp 104022 analog-input 0 Description 16 -1 7 "$(echo $desc | iconv -f UTF-8 -t ISO-8859-1)"
	done
}

main
