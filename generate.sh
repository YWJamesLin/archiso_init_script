#!/bin/sh
# Generate ArchISO Image
# 2015.08.13 Created By YWJamesLin

if [ -d /usr/share/archiso ]; then
  rm -rf /usr/share/archiso/
fi
pacman -S archiso
cp -af ./airootfs packages.x86_64 /usr/share/archiso/configs/releng/
sed -i 's/systemctl enable /systemctl enable nftables /' /usr/share/archiso/configs/releng/airootfs/root/customize_airootfs.sh
cp -a ./nftables.conf /usr/share/archiso/configs/releng/airootfs/etc/
cd /usr/share/archiso/configs/releng && ./build.sh -v
