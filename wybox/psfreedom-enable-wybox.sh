#!/bin/sh
RC=-1

if [ $# != 1 ]; then
  echo "Usage: sh ./psfreedom-enable.sh FW_VERSION"
  exit 0
fi

FW_VERSION=$1


# Stopping WyBox Media Transfert Protocol
echo "Stopping WyBox Media Transfert Protocol"
ngstatus | grep wymtsd > /dev/null
if [ $? = 0 ]; then                                         
    echo "Stopping Wymtsd NG deamon"
    ngzap wymtsd > /dev/null
    ngstop wymtsd > /dev/null
else
    echo "Wymtsd NG deamon already stopped"
fi
pidof wymtsd > /dev/null
if [ $? = 0 ]; then                                         
    echo "Stopping Wymtsd deamon"
    killall wymtsd 2> /dev/null
else
    echo "Wymtsd deamon already stopped"
fi
mount | grep gadget > /dev/null
if [ $? = 0 ]; then                                         
    echo "Unmounting gadget device"
    umount /dev/gadget 2> /dev/null
else
    echo "Gadget device already unmounted"
fi


# Loading PSFreedom module
grep psfreedom /proc/modules > /dev/null
if [ $? != 0 ]; then
    echo "Loading PSFreedom module"
    insmod psfreedom.ko > /dev/null
    if [ $? != 0 ]; then
        echo "Failed to install psfreedom module"
        exit 1
    fi
fi


# PSFreedom module loaded, set PS3 firmware version
echo "PSFREEDOM V$(cat /proc/psfreedom/version)"
echo "Copyright (C) 2010 Youness Alaoui (KaKaRoTo)"
cat /proc/psfreedom/supported_firmwares | grep $FW_VERSION > /dev/null
if [ $? = 0 ]; then
    echo $FW_VERSION > /proc/psfreedom/fw_version
else
    echo "Firmware $FW_VERSION not supported"
    echo "Supported firmwares: $(cat /proc/psfreedom/supported_firmwares)"
fi
echo "PSFreedom ready for firmware $(cat /proc/psfreedom/fw_version)"

