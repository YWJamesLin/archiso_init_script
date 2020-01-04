#! /bin/bash
# Main Program of this Script.
# Please Check whether
#   (1) Mount on Filesystem
#   (2) Connect to the Internet
# are done or not.
# Note. Default EFI Directory is /boot/efi

. ~/config.sh

# Installation start here
cd ~/Init/
./Init.sh
cd ~

# Get package Lists
export pacstrapList="$(cat ~/pacstrapList)"

# Prepare PostSysInit script
cp -a ./PostInit /mnt/root/
cp -a ./UserInit /mnt/root/
arch-chroot /mnt /root/PostInit/PostInit.sh

# Clean PostSysInit script
rm -rf /mnt/root/PostInit
rm -rf /mnt/root/UserInit

# Umount filesystem
umount -R /mnt

# Output Final Message
echo "All Inits complete. You can enjoy your new system!"
