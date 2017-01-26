#! /bin/bash
# PostInit for lightdm
sed -i 's/#greeter-session=.*$/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf
cp ~/PostInit/common/lightdm/44-custom.conf /etc/X11/xinit/xinitrc.d/
systemctl set-default graphical
systemctl enable lightdm
