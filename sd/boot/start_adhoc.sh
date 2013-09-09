#!/bin/sh

IP_ADDR="169.254.10.10"
IP_MASK="255.255.0.0"

/usr/bin/system_clean.sh
/sbin/rmmod /lib/ar6000.ko

/sbin/insmod /lib/ar6000.ko
# /sbin/insmod /lib/ka2000-sdio.ko

# wait some time until the interface is ready
sleep 2

# configure wifi interface
#ifconfig mlan0 ${IP_ADDR} netmask ${IP_MASK} up
ifconfig mlan0 up

# start wpa supplicant
wpa_supplicant -imlan0 -Dwext -c/mnt/sd-ext/etc/wpa-adhoc.conf &

# wait some time until wpa_supplicant has finished its work
sleep 5

# configure ad-hoc ip
zcip -f -q mlan0 /mnt/sd-ext/etc/zcip.script

