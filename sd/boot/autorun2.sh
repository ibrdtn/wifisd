#!/bin/sh

BOOT_PATH=/mnt/sd/boot
EXT_PATH=/mnt/sd-ext

if [ "${1}" == "install" ]; then
	# prepare permissions for later execution
	chmod 755 ${BOOT_PATH}/start_adhoc.sh

	# replace bodyguard script
	cp ${BOOT_PATH}/autorun2.sh /usr/bin/bodyguard.sh
	chmod 755 /usr/bin/bodyguard.sh

	# Install extended busybox
	chmod 777 ${BOOT_PATH}/install_busybox.sh
	${BOOT_PATH}/install_busybox.sh ${BOOT_PATH}

	# copy proper hosts
	cp ${BOOT_PATH}/hosts /etc/hosts

	# mount the second partition
	mkdir -p ${EXT_PATH}
	mount -t vfat -o iocharset=utf8,rw /dev/mmcblk0p2 ${EXT_PATH}

# disable refresh_sd
cat > /usr/bin/refresh_sd << EOF
#!/bin/sh -e
exit 0
EOF
	chmod 755 /usr/bin/refresh_sd

	exit 0
fi

# remount sd-card read-only
RET=1
while [ ${RET} != 0 ]; do
	sleep 1
	umount /mnt/sd
	RET=$?
done
mount -t vfat -o shortname=winnt,iocharset=utf8,ro /dev/mmcblk0p1 /mnt/sd

# disable kcard_app
/usr/bin/kcard_app.sh stop

# Start Wifi adhoc mode
${BOOT_PATH}/start_adhoc.sh

# generate and set hostname
MD5_ID=$(ifconfig mlan0 | head -n1 | awk '{print $5}' | md5sum | awk '{print $1}')
echo "wifisd-${MD5_ID:24}" > /etc/hostname
hostname -F /etc/hostname

# start telnet server
rcS6

# Start IBR-DTN
if [ -x "${EXT_PATH}/sbin/dtnd" ]; then
	${EXT_PATH}/sbin/dtnd -i mlan0 -c ${EXT_PATH}/etc/dtnd.conf &
fi

echo "autorun2.sh finished" >> /tmp/log.rcS

