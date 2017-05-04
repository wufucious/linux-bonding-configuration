#!/bin/bash
#SCRIPT_VERSION="2017-07-01-cmcc-private-cloud"
SCRIPT_VERSION="2017-05-01-cmcc-public-cloud"

if [ `whoami` = "root" ];then
echo "user:root"
   else
echo "you need root."
exit
fi

echo "network initializaiton start"
# set -x

source parameters-common-debug
#source parameters-common

source functions-common

distro_check

if [ $distro == "CentOS" ]; then
	source functions-centos
elif [ $distro == "Ubuntu" ]; then
	source functions-ubuntu
else
	echo "unsupported distribution or version"
	exit -1
fi

disable_network_manager

bond_initial

nic_0=$(ip -o link show | grep "$manage_mac_1" | awk '{print $2}'| cut -d ':' -f1)
nic_1=$(ip -o link show | grep "$manage_mac_2" | awk '{print $2}'| cut -d ':' -f1)
nic_2=$(ip -o link show | grep "$storage_mac_1" | awk '{print $2}'| cut -d ':' -f1)
nic_3=$(ip -o link show | grep "$storage_mac_2" | awk '{print $2}'| cut -d ':' -f1)
nic_4=$(ip -o link show | grep "$business_mac_1" | awk '{print $2}'| cut -d ':' -f1)
nic_5=$(ip -o link show | grep "$business_mac_2" | awk '{print $2}'| cut -d ':' -f1)
if [[ -z "$nic_0" || -z "$nic_1" || -z "$nic_2" || -z "$nic_3" || -z "$nic_4" || -z "$nic_5" ]]; then
	echo "one nic not found"
	exit -1
fi

config_nic
start_nic
