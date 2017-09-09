#!/bin/bash

##############################################################################
## CONSTANTS
##############################################################################
VM_USER=mlj
VM_PASSWORD=secret
PG_VERSION=9.5
DB_USER=$VM_USER
DB_PASSWORD=$VM_PASSWORD


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
## USER
##############################################################################
sudo useradd "$VM_USER" -m -g sudo
echo "$VM_USER:$VM_PASSWORD" | sudo chpasswd
echo "$VM_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/$VM_USER"


##############################################################################
## GIT
##############################################################################
apt install git
su - $VM_USER -c 'git config --global user.email "m.llewellynjones@gmail.com"'
su - $VM_USER -c 'git config --global user.name "mllewellynjones"'
su - $VM_USER -c 'git config --global push.default simple'
su - $VM_USER -c 'git config --global credential.https://github.com.username mllewellynjones'


##############################################################################
## VIM
##############################################################################
echo "Setting up VIM..."
apt install vim-nox -y

# Pathogen
mkdir -p "/home/$VM_USER/.vim/autoload" "/home/$VM_USER/.vim/bundle"
curl -LSso "/home/$VM_USER/.vim/autoload/pathogen.vim" https://tpo.pe/pathogen.vim

# NERDTree
cd "/home/$VM_USER/.vim/bundle"
git clone https://github.com/scrooloose/nerdtree.git

# Command-T
apt install ruby-dev -y
cd "/home/$VM_USER/.vim/bundle"
git clone https://github.com/wincent/Command-T.git
cd "/home/$VM_USER/.vim/bundle/Command-T"
sudo rake make

# Syntastic
cd "/home/$VM_USER/.vim/bundle"
git clone --depth=1 https://github.com/scrooloose/syntastic.git

# Fugitive
cd "/home/$VM_USER/.vim/bundle"
git clone git://github.com/tpope/vim-fugitive.git
vim -u NONE -c "helptags vim-fugitive/doc" -c q

# Python Mode
cd "/home/$VM_USER/.vim/bundle"
git clone https://github.com/python-mode/python-mode.git

# Tagbars
cd "/home/$VM_USER/.vim/bundle"
git clone https://github.com/majutsushi/tagbar.git


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

apt install "postgresql-$PG_VERSION" -y
apt install python-psycopg2 -y
apt install libpq-dev -y
apt install "postgresql-contrib-$PG_VERSION" -y

sudo -u postgres createuser $VM_USER -s

apt install exuberant-ctags

##############################################################################
## FILES FROM GIT
##############################################################################
echo "Grabbing files from GIT..."
su - $VM_USER -c 'mkdir -p /home/'"$VM_USER"'/dotfiles'
su - $VM_USER -c 'git clone https://github.com/mllewellynjones/dotfiles.git /home/'"$VM_USER"'/dotfiles'
su - $VM_USER -c '/home/'"$VM_USER"'/dotfiles/setup_symlinks'

su - $VM_USER -c 'mkdir -p /home/'"$VM_USER"'/scripts'
su - $VM_USER -c 'git clone https://github.com/mllewellynjones/scripts.git /home/'"$VM_USER"'/scripts'
su - $VM_USER -c '/home/'"$VM_USER"'/scripts/setup_symlinks'

su - $VM_USER -c 'mkdir -p /home/'"$VM_USER"'/mlj_vm'
su - $VM_USER -c 'git clone https://github.com/mllewellynjones/mlj_vm.git /home/'"$VM_USER"'/mlj_vm'


##############################################################################
## POSTGRES SETUP
##############################################################################
PG_CONF="/etc/postgresql/$PG_VERSION/main/postgresql.conf"
PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"
PG_DIR="/var/lib/postgresql/$PG_VERSION/main"

# Edit postgresql.conf to change listen address to '*':
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"

# Append to pg_hba.conf to add password auth:
echo "host    all             all             all                     md5" >> "$PG_HBA"

# Explicitly set default client_encoding
echo "client_encoding = utf8" >> "$PG_CONF"

# Restart so that all new config is loaded:
service postgresql restart

cat << EOF | su - postgres -c psql
-- Create the database user:
CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';

-- Create the database:
CREATE DATABASE $DB_USER WITH OWNER=$DB_USER
EOF


##############################################################################
## CONVERT TO DESKTOP
##############################################################################
# Although the GUI isn't required, the support for getting screen resolutions
# correct is far more mature
apt install ubuntu-desktop -y


##############################################################################
## TURN OFF ERROR REPORTING
##############################################################################
sed -i "s/enabled=1/enabled=0/" /etc/default/apport 
service apport restart
