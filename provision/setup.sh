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
su - ubuntu -c 'git config --global user.email "m.llewellynjones@gmail.com"'
su - ubuntu -c 'git config --global user.name "mllewellynjones"'
su - ubuntu -c 'git config --global push.default simple'
su - ubuntu -c 'git config --global credential.https://github.com.username mllewellynjones'

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
pip3 install virtualenvwrapper

apt install postgresql -y
apt install python-psycopg2 -y
apt install libpq-dev -y

sudo -u postgres createuser ubuntu -s

apt install expect -y

##############################################################################
## FILES FROM GIT
##############################################################################
echo "Grabbing files from GIT..."
su - ubuntu -c 'mkdir -p /home/ubuntu/dotfiles'
su - ubuntu -c 'git clone https://github.com/mllewellynjones/dotfiles.git /home/ubuntu/dotfiles'

su - ubuntu -c 'mkdir -p /home/ubuntu/scripts'
su - ubuntu -c 'git clone https://github.com/mllewellynjones/scripts.git /home/ubuntu/scripts'

su - ubuntu -c 'mkdir -p /home/ubuntu/mlj_vm'
su - ubuntu -c 'git clone https://github.com/mllewellynjones/scripts.git /home/ubuntu/mlj_vm'

##############################################################################
## RUN SOME OF THE SCRIPTS
##############################################################################
/home/ubuntu/scripts/default_password.exp
su - ubuntu -c '/home/ubuntu/dotfiles/setup_symlinks.sh'

##############################################################################
## CONVERT TO DESKTOP
##############################################################################
# Although the GUI isn't required, the support for getting screen resolutions
# correct is far more mature
apt install ubuntu-desktop -y
/home/ubuntu/scripts/adjust.sh
