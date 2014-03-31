#!/bin/sh -e
#

# nightlies
#JENKINS_URL="http://jenkins.ibr.cs.tu-bs.de/jenkins/job/buildroot-ibrdtn-static/defconfig=ka_wifisd_defconfig,label=buildroot-build/lastSuccessfulBuild/artifact/output/target"

# stable
JENKINS_URL="http://jenkins.ibr.cs.tu-bs.de/jenkins/job/ibrdtn-release-buildroot/defconfig=ka_wifisd_defconfig,label=buildroot-build/lastSuccessfulBuild/artifact/output/target"

mkdir -p ./sd-ext/sbin
mkdir -p ./sd-ext/bin
mkdir -p ./sd-ext/tmp

wget -O ./sd-ext/sbin/dtnd ${JENKINS_URL}/usr/sbin/dtnd

TOOLS="dtnping dtnoutbox dtninbox dtnsend dtnrecv dtnstream dtntracepath dtntrigger"

for T in ${TOOLS}; do
  wget -O ./sd-ext/bin/${T} ${JENKINS_URL}/usr/bin/${T}
done

