#!/bin/bash -ex
#

WORKSPACE=$(pwd)

BUILDROOT_VERSION="2013.08.1"
BUILDROOT_DL="http://buildroot.uclibc.org/downloads"
BUILDROOT_FILE="${WORKSPACE}/dl/buildroot-${BUILDROOT_VERSION}.tar.bz2"
BUILDROOT_DIR="${WORKSPACE}/build/buildroot-${BUILDROOT_VERSION}"

FIRMWARE_FILE="WiFiSD_v1.8.zip"
FIRMWARE_URL="http://de.transcend-info.com/support/dlcenter/dllogin_t.asp?Link=dlcenter|Driver|WiFiSD_v1.8.zip"

mkdir -p dl
mkdir -p build

# download buildroot
if [ ! -f "${BUILDROOT_FILE}" ]; then
    wget -O ${BUILDROOT_FILE} ${BUILDROOT_DL}/buildroot-${BUILDROOT_VERSION}.tar.bz2
fi

cd build

# extract buildroot
if [ ! -d "${BUILDROOT_DIR}" ]; then
    tar xvjf ${BUILDROOT_FILE}

    # create symbolic links
    for PACKAGE in $(ls -1 ${WORKSPACE}/package); do
        if [ -d "${WORKSPACE}/package/${PACKAGE}" ]; then
            ln -s ${WORKSPACE}/package/${PACKAGE} ${BUILDROOT_DIR}/package/${PACKAGE}
        fi
    done

    cd ${BUILDROOT_DIR}
    cat ${WORKSPACE}/package/001-Add-packages-to-Config.in.patch | patch -p1

    # copy default configuration
    cp ${WORKSPACE}/buildroot.config ${BUILDROOT_DIR}/.config
fi

# download firmware
if [ ! -f "${WORKSPACE}/dl/WiFiSD_v1.8.zip" ]; then
    echo "Please download WiFiSD Firmware (WiFiSD_v1.8.zip) and place it in the dl folder."
    echo "${FIRMWARE_URL}"
    exit 1
fi

# extract firmware archive
if [ ! -d "${WORKSPACE}/build/firmware" ]; then
    mkdir -p ${WORKSPACE}/build/firmware
    cd ${WORKSPACE}/build/firmware
    unzip -x "${WORKSPACE}/dl/WiFiSD_v1.8.zip"
fi

# extract firmware
if [ ! -d "${WORKSPACE}/build/root.orig" ]; then
    mkdir -p ${WORKSPACE}/build/root.orig
    cd ${WORKSPACE}/build/root.orig
    cat ${WORKSPACE}/build/firmware/Firmware_V1.8/initramfs3.gz | dd bs=8 skip=1 | gunzip | cpio -i    
fi

# copy legacy stuff to legacy buildroot package
if [ ! -d "${WORKSPACE}/package/wifisd-legacy/lib" ]; then
    mkdir -p ${WORKSPACE}/package/wifisd-legacy/lib
    MODULES="ar6000.ko gpio_i2c.ko ka2000-sdhc.ko ka2000-sdio.ko"

    for MOD in ${MODULES}; do
        cp -v ${WORKSPACE}/build/root.orig/lib/${MOD} ${WORKSPACE}/package/wifisd-legacy/lib
    done
    cp -rv ${WORKSPACE}/build/root.orig/lib/ath6k ${WORKSPACE}/package/wifisd-legacy/lib
fi

# build
cd ${BUILDROOT_DIR}
make

