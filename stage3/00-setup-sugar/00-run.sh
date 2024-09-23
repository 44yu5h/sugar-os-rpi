#!/bin/bash -e

# disabling ipv6 for now..
sudo bash -c 'echo -e "\nnet.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\nnet.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf'
sudo sysctl -p

on_chroot << EOF
sudo -u root apt install lightdm xserver-xorg sucrose -y
sudo -u root dpkg-reconfigure lightdm
sudo -u root raspi-config nonint do_boot_behaviour B3
sudo -u root apt remove sugar-browse-activity -y
EOF

# Temporary fix for browse-activity: installing libsoup3.0 and webkit2gtk-4.1 + exporting GI_TYPELIB_PATH
export GI_TYPELIB_PATH=${ROOTFS_DIR}/usr/lib/girepository-1.0

# Set the default session to Sugar
CONFIG_FILE=${ROOTFS_DIR}/etc/lightdm/lightdm.conf
if grep -q "\[Seat:\*\]" "$CONFIG_FILE"; then
  sudo sed -i '/^\[Seat:\*\]/a user-session=sugar' "$CONFIG_FILE"
else
  echo -e "[Seat:*]\nuser-session=sugar" | sudo tee -a "$CONFIG_FILE"
fi
echo "Default session set to Sugar."

mkdir ${ROOTFS_DIR}/home/pi/Activities
cd ${ROOTFS_DIR}/home/pi/Activities

# Cloning the Sugar activities
git clone https://github.com/44yu5h/rpi_camera_activity
git clone https://github.com/44yu5h/rpi_control_center
git clone https://github.com/44yu5h/turtleart-activity
git clone https://github.com/44yu5h/gallery_activity
git clone https://github.com/sugarlabs/browse-activity # removed v207 above; added latest (v208 as of now)
git clone https://github.com/sugarlabs/flappy
git clone https://github.com/sugarlabs/musicblocks

echo "Sugar is successfully installed."

# re-enabling ipv6..
sudo sed -i '/net\.ipv6\.conf\.\(all\|default\|lo\)\.disable_ipv6 = 1/d' /etc/sysctl.conf
sudo sysctl -p
