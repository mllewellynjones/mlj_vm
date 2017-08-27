#!/bin/bash

##############################################################################
## UBUNTU
##############################################################################
# Bring Ubuntu up to date
echo "Updating..."
apt update -y
apt upgrade -y

##############################################################################
## VIRTUALBOX SPECIFIC
##############################################################################
apt install virtualbox-guest-dkms -y
apt install virtualbox-guest-utils -y
apt install virtualbox-guest-x11 -y

##############################################################################
## GIT
##############################################################################
apt install git
git config --global user.email "m.llewellynjones@gmail.com"
git config --global user.name "Matt Llewellyn-Jones"

##############################################################################
## VIM
##############################################################################
echo "Setting up VIM..."
apt install vim-nox -y

# Get Pathogen
mkdir -p /home/ubuntu/.vim/autoload /home/ubuntu/.vim/bundle
curl -LSso /home/ubuntu/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Get NERDTree
cd /home/ubuntu/.vim/bundle
git clone https://github.com/scrooloose/nerdtree.git

# Get Command-T
apt install ruby-dev -y
cd /home/ubuntu/.vim/bundle
git clone https://github.com/wincent/Command-T.git
cd /home/ubuntu/.vim/bundle/Command-T
sudo rake make

# Get YCM
apt install cmake -y
cd /home/ubuntu/.vim/bundle
git clone https://github.com/Valloric/YouCompleteMe.git
cd /home/ubuntu/.vim/bundle/YouCompleteMe
git submodule update --init --recursive
./install.py --clang-completer

# Syntastic
cd /home/ubuntu/.vim/bundle
git clone --depth=1 https://github.com/scrooloose/syntastic.git

# Fugitive
cd /home/ubuntu/.vim/bundle
git clone git://github.com/tpope/vim-fugitive.git
vim -u NONE -c "helptags vim-fugitive/doc" -c q

##############################################################################
## PYTHON DEVELOPMENT
##############################################################################
echo "Setting up development environment..."

apt install python -y
apt install python-dev -y
apt install python3 -y
apt install python3-dev -y
apt install python-pip -y
apt install python3-pip -y
pip3 install --upgrade pip
pip3 install cookiecutter

pip3 install virtualenv

apt install postgresql -y
apt install python-psycopg2 -y
apt install libpq-dev -y

-u postgres createuser ubuntu -s

##############################################################################
## FILES FROM GIT
##############################################################################
echo "Grabbing files from GIT..."
mkdir -p /home/ubuntu/dotfiles
git clone git://github.com/mllewellynjones/dotfiles.git /home/ubuntu/dotfiles
mv /home/ubuntu/dotfiles/.b* /home/ubuntu/dotfiles/.v* /home/ubuntu
sudo rm -rf /home/ubuntu/dotfiles

mkdir -p /home/ubuntu/scripts
git clone git://github.com/mllewellynjones/scripts.git /home/ubuntu/scripts

##############################################################################
## CONVERT TO DESKTOP
##############################################################################
# Although the GUI isn't required, the support for getting screen resolutions
# correct is far more mature
apt install ubuntu-desktop -y
