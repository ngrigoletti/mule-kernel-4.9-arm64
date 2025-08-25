#!/bin/sh

MULE_REPO=https://repository-master.mulesoft.org/nexus/content/repositories/releases
MULE_VERSION=4.9.0
TANUKI_REPO=https://download.tanukisoftware.com/wrapper
TANUKI_SO=macosx
TANUKI_CPU=arm
TANUKI_BIT=64
TANUKI_VERSION=3.5.51

# Download Mule Kernel runtime
MULE_URL=${MULE_REPO}/org/mule/distributions/mule-standalone/${MULE_VERSION}/mule-standalone-${MULE_VERSION}.tar.gz
echo "Downloading ${MULE_URL}"
curl -O ${MULE_URL}
tar -xzvf mule-standalone-${MULE_VERSION}.tar.gz

# Download Tanuki wrapper
TANUKI_URL=${TANUKI_REPO}/${TANUKI_VERSION}/wrapper-${TANUKI_SO}-${TANUKI_CPU}-${TANUKI_BIT}-${TANUKI_VERSION}.tar.gz
echo "Downloading ${TANUKI_URL}"
curl -O ${TANUKI_URL}
tar -xzvf wrapper-${TANUKI_SO}-${TANUKI_CPU}-${TANUKI_BIT}-${TANUKI_VERSION}.tar.gz

# Add Tanuki support for specific platform
LIB_NAME=$(ls ./wrapper-${TANUKI_SO}-${TANUKI_CPU}-${TANUKI_BIT}-${TANUKI_VERSION}/lib/libwrapper.*)
LIB_EXT="${LIB_NAME##*.}"
cp ./wrapper-${TANUKI_SO}-${TANUKI_CPU}-${TANUKI_BIT}-${TANUKI_VERSION}/lib/libwrapper.${LIB_EXT} ./mule-standalone-${MULE_VERSION}/lib/boot/tanuki/libwrapper-${TANUKI_SO}-${TANUKI_CPU}-${TANUKI_BIT}.${LIB_EXT}
cp ./wrapper-${TANUKI_SO}-${TANUKI_CPU}-${TANUKI_BIT}-${TANUKI_VERSION}/lib/wrapper.jar ./mule-standalone-${MULE_VERSION}/lib/boot/tanuki/wrapper-3.2.3.jar
cp ./wrapper-${TANUKI_SO}-${TANUKI_CPU}-${TANUKI_BIT}-${TANUKI_VERSION}/bin/wrapper ./mule-standalone-${MULE_VERSION}/lib/boot/tanuki/exec/wrapper-${TANUKI_SO}-${TANUKI_CPU}-${TANUKI_BIT}

# Cleaning
rm mule-standalone-${MULE_VERSION}.tar.gz
rm wrapper-${TANUKI_SO}-${TANUKI_CPU}-${TANUKI_BIT}-${TANUKI_VERSION}.tar.gz
rm -rf wrapper-${TANUKI_SO}-${TANUKI_CPU}-${TANUKI_BIT}-${TANUKI_VERSION}

# Fix mule script
gsed -i 's/case "$PROC_ARCH" in/case "$PROC_ARCH" in\n        arm64 | aarch64)\n            DIST_ARCH="arm"\n            DIST_BITS="64"\n            break;;/' ./mule-standalone-${MULE_VERSION}/bin/mule