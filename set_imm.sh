#!/bin/bash
#Set where the executable is
ASU="/home/partimag/IBM/asu64 set"
K="--kcs"
module=`lsmod | grep ipmi | wc -l`
if [ $module -ne 3 ]; then

  modprobe ipmi_devintf
  modprobe ipmi_si
  modprobe ipmi_msghandler
fi
#/etc/init.d/ipmievd restart 2 > /dev/null
if [ $# -ne 4 ]; then
  exit 1
fi
IMM_ip=$1
IMM_mask=$2
IMM_gw=$3
IMM_hostname=$4


# This script set IMM IP configuration

$ASU IMM.DHCP1 Disabled $K
$ASU IMM.HostName1 $IMM_hostname $K
$ASU IMM.HostIPAddress1 $IMM_ip $K
$ASU IMM.HostIPSunet1 $IMM_mask $K
$ASU IMM.GatewayIPAddress1 $IMM_gw $K

#force pxeboot next time


$ASU IMM.PXE_NextBootEnabled Enabled $K
