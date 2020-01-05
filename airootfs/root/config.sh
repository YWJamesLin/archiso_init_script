#! /bin/bash

params=("LANInterface" "HostName" "UserName" "MirrorCountry")
mountRoot="/mnt"

if ! mountpoint -q "${mountRoot}"; then
  echo "You did not mount your root, please mount your root to ${mountRoot} to continue installation."
  exit 1
fi

# Params of installation
#   LANInterface: LAN Interface name, DHCP and DHCPv6 client services would be enabled onboot.
#   Hostname: HostName of this system
#   UserName: Normal user created during installation
#   MirrorCountry: Country of archlinux mirror
LANInterface=""
HostName="ArchLinux"
UserName="user"
MirrorCountry="TW"

for (( counter=0; counter<${#params[@]}; counter=counter+1 )); do
  confirm=""
  while [ "$confirm" != "yes" ]; do
    read -e -p "Please input ${params[counter]}: " -i "${!params[counter]}" ${params[counter]}
    read -e -p "Your input of ${params[counter]} is \"${!params[counter]}\". Confirm?[yes]: " -i "yes" confirm
  done
  export ${params[counter]}
done
