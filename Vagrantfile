# Require the reboot plugin.

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.synced_folder "./", "/var/www", create: true, group: "www-data", owner: "www-data"
 
  config.vm.network :forwarded_port, guest: 80, host: 8931, auto_correct: true
  config.vm.network :forwarded_port, guest: 8000, host: 8932, auto_correct: true
  
  config.vm.provider "virtualbox" do |v|
    v.name = "MLJ VM"
    v.customize ["modifyvm", :id, "--memory", "1024"]
  end
   
  # Put as much provisioning as possible here 
  config.vm.provision "shell" do |s|
    s.path = "provision/setup.sh"
  end
  
   config.vm.provision :reload

  # Run any commands which need the system to have rebooted 
  config.vm.provision "shell" do |s|
    s.path = "provision/adjust.sh"
  end
end