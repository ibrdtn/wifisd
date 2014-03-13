#!/bin/bash -e
#

if [ -z "${1}" ]; then
    echo "specify the card device as first argument, e.g. /dev/sde"
    exit 1
fi

# set sd-card device
DEVICE=${1}

# check if device is mounted
if [ -n "$(mount | grep /dev/sde)" ]; then
    echo "Device is currently mounted. Please unmount first!"
    exit 2
fi

echo "delete existing partitions"
(echo d; echo 2; echo d; echo w) | fdisk ${DEVICE} >/dev/null 2>&1

echo "create first partition"
(echo n; echo p; echo 1; echo; echo +12G; echo t; echo c; echo w) | fdisk ${DEVICE} >/dev/null 2>&1

echo "create second partition"
(echo n; echo p; echo 2; echo; echo; echo t; echo 2; echo c; echo w) | fdisk ${DEVICE} >/dev/null 2>&1

echo "format first partition"
mkfs.vfat ${DEVICE}1 >/dev/null

echo "format second partition"
mkfs.vfat ${DEVICE}2 >/dev/null

echo "mount first partition and copy files"
mount ${DEVICE}1 mnt-sd/
cp -fr sd/* mnt-sd/
RET=1
while [ ${RET} -gt 0 ]; do
    sync
    sleep 1
    set +e
    umount ${DEVICE}1
    RET=$?
    set -e
done

echo "mount second partition and copy files"
mount ${DEVICE}2 mnt-sd-ext/
cp -fr sd-ext/* mnt-sd-ext/
RET=1
while [ ${RET} -gt 0 ]; do
    sync
    sleep 1
    set +e
    umount ${DEVICE}2
    RET=$?
    set -e
done


