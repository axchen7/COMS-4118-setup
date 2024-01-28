#!/bin/bash

USERNAME="axchen7"
GIT_NAME="Alex Chen"
GIT_EMAIL="azc2110@columbia.edu"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "Run `su -` to switch to root before running this script"
    exit 1
fi

# add bullseye-backports source (for open-vm-tools arm64 on Debian 11)
echo "deb http://deb.debian.org/debian/ bullseye-backports main" >> /etc/apt/sources.list

# install packages
apt update
apt upgrade
apt install -y sudo git build-essential net-tools linux-headers-$(uname -r)
apt install -y vim open-vm-tools cmake
# use avahi-daemon to broadcast hostname
apt install -y avahi-daemon

# install kedr
cd ~
git clone https://github.com/cs4118/kedr
cd kedr/sources
mkdir build
cd build
cmake ..
make -j$(nproc)
make install

# add user to sudo group
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# edit git global config
cd /home/$USERNAME
sudo -u $USERNAME git config --global user.name "$GIT_NAME"
sudo -u $USERNAME git config --global user.email "$GIT_EMAIL"

# automatically mount shared folders
mkdir -p /mnt/hgfs
echo ".host:/ /mnt/hgfs fuse.vmhgfs-fuse allow_other 0 0" >> /etc/fstab
mount -a

# copy contents of /mnt/hgfs/.ssh to ~/.ssh
cp -r /mnt/hgfs/.ssh /home/$USERNAME/.ssh

# reboot to complete kedr install
reboot