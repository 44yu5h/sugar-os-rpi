#!/bin/bash -e

sudo dpkg-reconfigure lightdm
sudo raspi-config nonint do_boot_behaviour B3

mkdir ${ROOTFS_DIR}/home/pi/Activities
cd ${ROOTFS_DIR}/home/pi/Activities
git clone https://github.com/44yu5h/gallery_activity.git
echo "###### Finished 00-run.sh #####"

echo "enabling ipv6.."
sudo sed -i '/net\.ipv6\.conf\.\(all\|default\|lo\)\.disable_ipv6 = 1/d' /etc/sysctl.conf
sudo sysctl -p
