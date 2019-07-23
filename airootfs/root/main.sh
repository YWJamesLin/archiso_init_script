#! /bin/bash
# Main Program of this Script.
# Please Check whether
#   (1)Mount on Filesystem
#   (2)Choose Mirror
#   (3)Connect to the Internet
#   (4)Choose Package List
# are done or not.
# Note. Default EFI Directory is /boot/efi

# Please specify these variables

#   LAN Interface name
#     There would be dhcp and dhcpv6 client on this inteface onboot.
LANIF=""

#   Hostname
HOSTNAME=""

#   Normal User Name
UserName="user"

#   Configuration
EnableJumboFrame="0"

export LANIF HOSTNAME UserName EnableJumboFrame

# Main Logic Start here
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
