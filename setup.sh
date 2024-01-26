#!/bin/bash

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
echo "axchen7 ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# add my MacBook's public key to authorized_keys
mkdir -p /home/axchen7/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOA5UHYRNLtR1n2llKMR9Dp8/ywG2FQk7Eu0R4oOAt3v axchen7@outlook.com" > /home/axchen7/.ssh/authorized_keys

# edit git global config for axchen7
cd /home/axchen7
sudo -u axchen7 git config --global user.name "Alex Chen"
sudo -u axchen7 git config --global user.email "azc2110@columbia.edu"

# automatically mount shared folders
mkdir -p /mnt/hgfs
echo ".host:/ /mnt/hgfs fuse.vmhgfs-fuse allow_other 0 0" >> /etc/fstab
mount -a

# install VS Code
cd ~
sudo apt install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt install apt-transport-https
sudo apt update
sudo apt install code

# reboot to complete kedr install
reboot