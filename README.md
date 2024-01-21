# Columbia COMS 4118 Setup Script

This repository contains a `setup.sh` script that brings a fresh Debian 11 installation (in VMware Fusion) up to speed for COMS 4118: Operating Systems. To create the VM, follow the instructions at https://columbia-os.github.io/dev-guides/debian-vm-setup.html, but stop before the "Setting up your Debian VM" section. Feel free to omit installing the "Debian desktop environment". Also, make sure shared folders are enabled for the VM.

Essentially, run the non-graphical installer with everything left as default, except choose a suitable hostname, root password, full name, username, password, and timezone.

Run `su -` to become root, then run `./setup.sh`. (You can also log in straight as `root` in the serial console.)

Note: to clone this repo into the the Debian VM, you may need to first run `apt install git` to install git. Then, run `git clone https://github.com/axchen7/COMS-4118-setup`.
