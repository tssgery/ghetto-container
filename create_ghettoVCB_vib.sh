#!/bin/bash
# William Lam
# www.virtuallyghetto.com
# Script to build ghettoVCB VIB using VIB Author (can use with lamw/vibauthor Docker Container)

GVCB_REPO=https://github.com/lamw/ghettoVCB.git
GVCB_REPO_DIR=ghettoVCB
GVCB_TEMP_DIR=/tmp/ghettoVCB-$$

# Ensure git is installed
git version > /dev/null 2>&1
if [ $? -eq 1 ]; then
	echo "Git not installed, exiting ..."
	exit 1
fi

# Ensure vibauthor is installed
vibauthor --version > /dev/null 2>&1
if [ $? -eq 1 ]; then
	echo "vibauthor not installed, exiting ..."
	exit 1
fi

# Ensure no existing ghettoVCB repo exists
if [ -e ${GVCB_REPO_DIR} ]; then
	rm -rf ${GVCB_REPO_DIR}
fi

# Clone ghettoVCB repo
git clone ${GVCB_REPO}
cd ${GVCB_REPO_DIR}
GVCB_DATE=$(date --date="$(git log -n1 --format="%cd" --date="iso")" '+%Y-%m-%dT%H:%I:%S')
GVCB_COMMIT_HASH=$(git log -n1 --format="%H")
cd /root

# Setting up VIB spec confs
VIB_DESC_FILE=${GVCB_TEMP_DIR}/descriptor.xml
VIB_PAYLOAD_DIR=${GVCB_TEMP_DIR}/payloads/payload1

# Create ghettoVCB temp dir
mkdir -p ${GVCB_TEMP_DIR}
# Create VIB spec payload directory
mkdir -p ${VIB_PAYLOAD_DIR}

# Create ghettoVCB VIB descriptor.xml
cat > ${VIB_DESC_FILE} << __GHETTOVCB__
<vib version="5.0">
  <type>bootbank</type>
  <name>ghettoVCB</name>
  <version>1.0.0-0.0.0</version>
  <vendor>virtuallyGhetto</vendor>
  <summary>ghettoVCB VM backup and restore script</summary>
  <description>${GVCB_COMMIT_HASH}</description>
  <release-date>${GVCB_DATE}</release-date>
  <urls>
    <url key="ghettoVCB">https://github.com/lamw/ghettoVCB</url>
  </urls>
  <relationships>
    <depends>
    </depends>
    <conflicts/>
    <replaces/>
    <provides/>
    <compatibleWith/>
  </relationships>
  <software-tags>
  </software-tags>
  <system-requires>
    <maintenance-mode>false</maintenance-mode>
  </system-requires>
  <file-list>
  </file-list>
  <acceptance-level>community</acceptance-level>
  <live-install-allowed>true</live-install-allowed>
  <live-remove-allowed>true</live-remove-allowed>
  <cimom-restart>false</cimom-restart>
  <stateless-ready>true</stateless-ready>
  <overlay>false</overlay>
  <payloads>
    <payload name="payload1" type="vgz"></payload>
  </payloads>
</vib>
__GHETTOVCB__

# Create ghettoVCB bin/conf directories
GVCB_BIN_DIR=${VIB_PAYLOAD_DIR}/opt/ghettovcb/bin
GVCB_CONF_DIR=${VIB_PAYLOAD_DIR}/etc/ghettovcb
mkdir -p ${GVCB_BIN_DIR}
mkdir -p ${GVCB_CONF_DIR}

# Copy ghettoVCB files to bin/conf directories
cp ${GVCB_REPO_DIR}/*.sh ${GVCB_BIN_DIR}
cp ${GVCB_REPO_DIR}/*.conf ${GVCB_CONF_DIR}
cp ${GVCB_REPO_DIR}/*_template ${GVCB_CONF_DIR}

# Create ghettoVCB VIB + offline bundle
vibauthor -C -t ${GVCB_TEMP_DIR} -v /output/vghetto-ghettoVCB.vib -O /output/vghetto-ghettoVCB-offline-bundle.zip -f

# Remove ghettoVCB temp dir
rm -rf ${GVCB_TEMP_DIR}
