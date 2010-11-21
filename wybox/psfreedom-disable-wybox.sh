#!/bin/sh
RC=0

grep psfreedom /proc/modules > /dev/null
if [ $? = 0 ]; then
    echo "Unloading PSFreedom module"
    rmmod psfreedom
    if [ $? != 0 ]; then
        echo "Failed to unload PSFreedom module"
        exit 1
    fi
fi

mount | grep gadget > /dev/null
if [ $? != 0 ]; then                                         
    echo "Mounting gadget device"
    mount -t gadgetfs-mtp gadgetfs /dev/gadget
else
    echo "Gadget device already mounted"
fi

pidof wymtsd > /dev/null
if [ $? != 0 ]; then                                         
    echo "Starting Wymtsd deamon"
    /usr/bin/wymtsd &
else
    echo "Wymtsd deamon already started"
fi

echo "PSFreedom disabled"
