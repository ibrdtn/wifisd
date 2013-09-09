#!/bin/sh

BOOT_PATH=/mnt/sd/boot

# Intercept launch of bodyguard script
if [ -f ${BOOT_PATH}/autorun2.sh ]
then
    echo "install autorun2.sh"
    echo "install autorun2.sh" >> /tmp/log.rcS
    sleep 1
    ${BOOT_PATH}/autorun2.sh install
fi

