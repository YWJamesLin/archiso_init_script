#!/bin/bash
touch /etc/skel/.zshrc
rm -f /etc/skel/.bash*

chsh -s /bin/zsh root
chsh -s /bin/zsh ${UserName}
