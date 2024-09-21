#!/bin/bash

on_chroot << EOF
	SUDO_USER="${FIRST_USER_NAME}" dpkg-reconfigure lightdm
	SUDO_USER="${FIRST_USER_NAME}" raspi-config nonint do_boot_behaviour B3
EOF

mkdir ${ROOTFS_DIR}/home/pi/Activities
cd ${ROOTFS_DIR}/home/pi/Activities
git clone https://github.com/44yu5h/gallery_activity.git
echo "###### Finished 00-run.sh #####"
