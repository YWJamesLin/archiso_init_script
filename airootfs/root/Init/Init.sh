#!/bin/bash
# System Initialization Before Chrooted

# Modify Repository
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/#\[core-testing\]/\[core-testing\]/' /etc/pacman.conf
sed -i 's/#\[extra-testing\]/\[extra-testing\]/' /etc/pacman.conf
sed -i 's/#\[multilib-testing\]/\[multilib-testing\]/' /etc/pacman.conf
sed -i 's/#\[multilib\]/\[multilib\]/' /etc/pacman.conf
sed -i 's/#Include/Include/g' /etc/pacman.conf

# Package List
Packages="Basis Intel Kodi IBus FCITX Network Server Wireless XWindowApp XWindowDM XWindowDesktopApp XWindowMultiMedia"

# Package List Fetching
pacstrapList=""
for PackageList in ${Packages}
do
  for PackageName in $(cat "./PackageLists/${PackageList}")
  do
    pacstrapList="${pacstrapList} ${PackageName}"
  done
done
# Use mirror from specified country
curl -s "https://archlinux.org/mirrorlist/?country=${MirrorCountry}&use_mirror_status=on" | sed 's/^#Server/Server/' > /etc/pacman.d/mirrorlist

# Pacstrap packages
pacstrap -i /mnt ${pacstrapList}

# Create package List
if [ -e ~/pacstrapList ]; then
  rm -rf ~/pacstrapList
fi
echo ${pacstrapList} >> ~/pacstrapList

if [ "$?" != "0" ]; then
  echo "Package Installation Error!!"
  exit 1
fi

# Generate File System Table
genfstab -Up /mnt > /mnt/etc/fstab
