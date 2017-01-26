#! /bin/bash
# PostInit for grub
grub-install --target=x86_64-efi --bootloader-id=Arch_Linux --efi-directory=/boot/efi --recheck
grub-mkconfig -o /boot/grub/grub.cfg
