#!/bin/sh
echo "PSFREEDOM V1.1 19 October 2010      Youness Alaoui (KaKaRoTo)"
echo "Supported firmwares: 2.76, 3.01, 3.10, 3.15, 3.21, 3.40, 3.41"

if [ $# != 1 ]; then
  echo "Usage: sh ./psfreedom-enable.sh 3.41"
  exit 0
fi

FW_VERSION=$1

# Stop WyBox Media Transfert Protocol
ngzap wymtsd > /dev/null
ngstop wymtsd > /dev/null
killall wymtsd 2> /dev/null
umount /dev/gadget 2> /dev/null

# Load PSFreedom module
lsmod | grep psfreedom > /dev/null
if [ $? != 0 ]; then                                         
    insmod psfreedom.ko
fi                                                                   

# Set PS3 fw version
echo $FW_VERSION > /proc/psfreedom/fw_version
echo "PSFreedom ready for PS3 firmware version $FW_VERSION"
