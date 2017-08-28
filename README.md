Getting Started
======

First install:
- Virtualbox
- Vagrant

Then:
- Get the reload plugin with: 

  `vagrant plugin install vagrant-reload`
    
- `cd` to where you want the machine and run: 

  `git clone git://github.com/mllewellynjones/mlj_vm.git`

- Run `vagrant up` and go and get a coffee, this takes a long time

- `vagrant ssh` into the VM and change the ubuntu password (or create a new user)

- Log into the VM through VirtualBox

To Do
=====

- Set up default passwords for Ubuntu user with Expects
- Look into Celery for message passing between guest and host processes (with port forwarding)
- Add scripts folder to PATH in .bashrc
- Include virtualenv wrapper by default
- Checkout mlj_vm into VM for ongoing updates
- Modify dotfiles to use symlinks
