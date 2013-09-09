#!/bin/sh

BUSYBOX_EXT=/bin/busybox-ext
SOURCE=${1}

if [ $# -lt 1 ]; then
    exit 0
fi

if [ ! -f "${SOURCE}/bad-sym-links.list" ]; then
    echo "${SOURCE}/bad-sym-links.list missing"

    # generate bad-sym-links.list
    chmod 755 ${SOURCE}/search-bad-sym-links.sh
    ${SOURCE}/search-bad-sym-links.sh ${SOURCE} > ${SOURCE}/bad-sym-links.list
fi

# Install extended busybox
cp ${SOURCE}/busybox-armv5l ${BUSYBOX_EXT}
chmod 755 ${BUSYBOX_EXT}

for BADSYM in $(cat ${SOURCE}/bad-sym-links.list)
do
	rm ${BADSYM}
done

# install commands support by the new busybox
${BUSYBOX_EXT} --install -s

# add script: vim -> vi
cat > /bin/vim << EOF
#!/bin/sh -e

vi \$@
EOF
chmod 755 /bin/vim

exit 0

