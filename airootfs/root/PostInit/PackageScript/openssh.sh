#! /bin/bash
# PostInit for openssh
sed -i 's/#X11Forwarding .*$/X11Forwarding yes/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin .*$/PermitRootLogin no/' /etc/ssh/sshd_config
