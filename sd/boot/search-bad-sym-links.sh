#!/bin/sh

SOURCE=${1}
BUSYBOX_EXT=${SOURCE}/busybox-armv5l

if [ $# -lt 1 ]; then
    exit 0
fi

PATHs="/bin /usr/bin"
BUSYBOX_CAPABILITIES="$(/bin/busybox --list)"
BUSYBOX_EXT_CAPABILITIES="$(${BUSYBOX_EXT} --list)"

check_cap() {
    for CAP in ${BUSYBOX_CAPABILITIES}; do
        if [ "${CAP}" == "${1}" ]; then
            echo "yes"
	    return 0
        fi
    done
    echo "no"
}

check_cap_ext() {
    for CAP in ${BUSYBOX_EXT_CAPABILITIES}; do
        if [ "${CAP}" == "${1}" ]; then
            echo "yes"
	    return 0
        fi
    done
    echo "no"
}

for myPATH in ${PATHs}
do
	CMDs=$(${BUSYBOX_EXT} ls -l ${myPATH} | ${BUSYBOX_EXT} grep busybox$ | ${BUSYBOX_EXT} awk -F ' ' ' { print $9 } ')

	for CMD in ${CMDs}; do
		# check if the command is not supported by the old busybox
		if [ "$(check_cap ${CMD})" == "no" ]; then
			# check if the command is supported by the extended busybox
			if [ "$(check_cap_ext ${CMD})" == "yes" ]; then
				echo "${myPATH}/${CMD}"
			fi
		fi
	done

done

exit 0

