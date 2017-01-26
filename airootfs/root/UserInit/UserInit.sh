#!/bin/sh
# User Environment Initialization
# you can add some customize script here

# ViM (I use other open source vimrc script and sed something as my vim env.)
git clone git://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_basic_vimrc.sh
sed -i 's/set cmdheight=/"set cmdheight=/' ~/.vimrc
sed -i 's/set foldcolumn=/"set foldcolumn=/' ~/.vimrc 
sed -i '142i " Show line numbers' ~/.vimrc
sed -i '143i set nu' ~/.vimrc
sed -i 's/colorscheme desert/ colorscheme default/' ~/.vimrc
sed -i 's/set shiftwidth.*$/set shiftwidth=2/' ~/.vimrc
sed -i 's/set tabstop.*$/set shiftwidth=2/' ~/.vimrc

# zsh (I use oh-my-zsh and my theme as my zsh env.)
curl -L http://install.ohmyz.sh | sh
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
sed -i 's/ZSH_THEME=.*$/ZSH_THEME="YWJLTheme"/' ~/.zshrc
sed -i 's/plugins=.*$/plugins=(git zsh-syntax-highlighting)/' ~/.zshrc
git clone git://github.com/YWJamesLin/YWJLTheme.git ~/YWJLTheme
cp ~/YWJLTheme/YWJLTheme.zsh-theme ~/.oh-my-zsh/themes/
rm -rf ~/YWJLTheme
sed -i 's/mod_time=1/mod_time=0/' ~/.oh-my-zsh/themes/YWJLTheme.zsh-theme
if [ "${USER}" == "root" ]; then
  cat ~/UserInit/common/zsh/zshrc_root >> ~/.zshrc
else
  cat ~/UserInit/common/zsh/zshrc_user >> ~/.zshrc
fi

# Done
echo "UserInit Complete."
