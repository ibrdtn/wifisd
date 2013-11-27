#!/bin/sh -e
#

# nightlies
#JENKINS_URL="http://jenkins.ibr.cs.tu-bs.de/jenkins/job/buildroot-ibrdtn-static/defconfig=ibrdtn_arm_defconfig,label=moped/lastSuccessfulBuild/artifact/output/target"

# stable
JENKINS_URL="http://jenkins.ibr.cs.tu-bs.de/jenkins/job/ibrdtn-release-buildroot/defconfig=ibrdtn_arm_defconfig,label=moped/lastSuccessfulBuild/artifact/output/target"

mkdir -p ./sd-ext/sbin
mkdir -p ./sd-ext/bin

wget -O ./sd-ext/sbin/dtnd ${JENKINS_URL}/usr/sbin/dtnd

TOOLS="dtnping dtnoutbox dtninbox dtnsend dtnrecv dtnstream dtntracepath dtntrigger"

for T in ${TOOLS}; do
  wget -O ./sd-ext/bin/${T} ${JENKINS_URL}/usr/bin/${T}
done

