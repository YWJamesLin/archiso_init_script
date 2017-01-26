#!/bin/sh
# System Initialization After Chrooted

# Specify Services to enable
ServicesToEnable="ntpd nftables sshd"

# HostName
echo ${HOSTNAME} >> /etc/hostname

# Locale ( you can change locale config here)
sed -i 's/#zh_TW.UTF-8 UTF-8/zh_TW.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

# ZoneInfo
if [ -e /etc/localtime ]; then 
  rm /etc/localtime
fi
ln -s /usr/share/zoneinfo/Asia/Taipei /etc/localtime

# Modify Repository (adding archlinuxfr is for convenience to install yaourt and other pre-built AUR package)
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/#\[testing\]/\[testing\]/' /etc/pacman.conf
sed -i 's/#\[community-testing\]/\[community-testing\]/' /etc/pacman.conf
sed -i 's/#\[multilib-testing\]/\[multilib-testing\]/' /etc/pacman.conf
sed -i 's/#\[multilib\]/\[multilib\]/' /etc/pacman.conf
sed -i 's/#Include/Include/g' /etc/pacman.conf
if [ "$(cat /etc/pacman.conf|grep 'archlinuxfr')" == "" ]; then
  cat ~/archlinuxfr >> /etc/pacman.conf
fi

# Enable OnBoot DHCP and DHCPv6 Client on this interface
if [ "${LANIF}" != "" ]; then
  systemctl enable dhcpcd@${LANIF}
fi

# Skel with zsh Default (you may not need this if you use bash)
touch /etc/skel/.zshrc
rm -f /etc/skel/.bash*

# Root Password
echo "Please set your Root Password."
passwd
if [ "${?}" != "0" ]; then
  passwd
fi

# User and Password
useradd -m ${UserName}
echo "Please set up the password of ${UserName}."
passwd ${UserName}
if [ "${?}" != "0" ]; then
  passwd ${UserName}
fi

# Visudo (if you do not install sudo, please remove this block)
echo "Now you have to modify sudoer file. The ViM editor will start 5 seconds later."
for (( i = 5; i > 0; i = i - 1))
do
  printf '%i ' ${i}
  sleep 1
done
visudo
echo ""

# Change Shell (if you use bash, you need not do these)
chsh -s /bin/zsh root
chsh -s /bin/zsh ${UserName}

# makepkg
sed -i "s/CFLAGS=.*$/CFLAGS=\"$(gcc -march=native -E -v - </dev/null 2>&1 | sed -n 's/.* -v - //p')\"/" /etc/makepkg.conf
sed -i 's/CXXFLAGS.*$/CXXFLAGS="${CFLAGS}"/' /etc/makepkg.conf
sed -i "s/#MAKEFLAGS.*$/MAKEFLAGS=\"-j$(($(nproc)*2))\"/" /etc/makepkg.conf

# intel CPU module load (needed in kernel 4.x)
sed -i "s/^MODULES.*$/MODULES=\"crc32_generic crc32c-intel\"/g" /etc/mkinitcpio.conf

# build initramfs image
mkinitcpio -p linux

# Do PostInit of packages
# if there is a matched package in PackageScript, {package}.sh in PackageScript will be executed, as a post-install script
for PackageScriptName in ${pacstrapList}
do
  if [ -e ~/PostInit/PackageScript/${PackageScriptName}.sh ]; then
    . ~/PostInit/PackageScript/${PackageScriptName}.sh
  fi
done

# enable services
systemctl enable ${ServicesToEnable}

# SSH initialize
test ! -d /home/${UserName}/.ssh && mkdir /home/${UserName}/.ssh && chmod 700 /home/${UserName}/.ssh

# Done
echo "PostInit Complete."

# User Init
cp -rf ~/UserInit /home/${UserName}
~/UserInit/UserInit.sh
su - ${UserName} -c "~/UserInit/UserInit.sh"
rm -rf /home/${UserName}/UserInit

# Home Directory permission initialize
chown -R root /root
chgrp -R root /root
chown -R ${UserName} /home/${UserName}
chgrp -R ${UserName} /home/${UserName}