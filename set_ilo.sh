#!/bin/bash
module=`lsmod | grep ipmi | wc -l`
if [ $module -ne 3 ]; then

  modprobe ipmi_devintf
  modprobe ipmi_si
  modprobe ipmi_msghandler
fi
#/etc/init.d/ipmievd restart 2 > /dev/null
if [ $# -ne 5 ]; then
  exit 1
fi
ILO_ip=$1
ILO_mask=$2
ILO_gw=$3
ILO_pwd=$4
ILO_hostname=$5


# This script set ILO IP configuration on proliant
# find the LAN number
LAN=`for i in \`seq 1 14\`; do ipmitool lan print $i 2>/dev/null | grep -q ^Set && echo Channel $i; done | awk '{print $2}'`
if [[ ! -z "$LAN" ]]; then
  echo "channel is: $LAN"

  ipmitool lan set $LAN ipsrc static
  ipmitool lan set $LAN ipaddr $ILO_ip
  ipmitool lan set $LAN netmask $ILO_mask
  ipmitool lan set $LAN defgw ipaddr $ILO_gw
  ipmitool user set password 1 $ILO_pwd
  ipmitool -I lan set hostname $ILO_hostname
  ipmitool mc reset cold   # reset ILO interface
else
  echo "no channel found"
exit 1
fi
