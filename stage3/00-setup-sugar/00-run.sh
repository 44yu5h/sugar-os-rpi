#!/bin/bash -e

on_chroot << EOF
sudo -u root apt install lightdm xserver-xorg sucrose -y
sudo -u root dpkg-reconfigure lightdm
sudo -u root raspi-config nonint do_boot_behaviour B3
EOF

# Set the default session to Sugar
CONFIG_FILE="/etc/lightdm/lightdm.conf"
if grep -q "\[Seat:\*\]" "$CONFIG_FILE"; then
  sudo sed -i '/^\[Seat:\*\]/a user-session=sugar' "$CONFIG_FILE"
else
  echo -e "[Seat:*]\nuser-session=sugar" | sudo tee -a "$CONFIG_FILE"
fi
echo "Default session set to Sugar."

mkdir ${ROOTFS_DIR}/home/pi/Activities
cd ${ROOTFS_DIR}/home/pi/Activities
# clone Activities here
echo "Sugar is successfully installed."

# re-enabling ipv6..
sudo sed -i '/net\.ipv6\.conf\.\(all\|default\|lo\)\.disable_ipv6 = 1/d' /etc/sysctl.conf
sudo sysctl -p
