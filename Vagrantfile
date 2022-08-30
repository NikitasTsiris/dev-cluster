# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<-SCRIPT
cd /home/vagrant/
git clone https://github.com/NikitasTsiris/dev-cluster.git
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.define "dev-vm" do |node|

    node.vm.box               = "generic/ubuntu2004"
    node.vm.box_check_update  = false

    node.vm.network "private_network" , ip: "192.168.121.220"
    node.vm.hostname          = "dev-cluster"

    node.vm.provider :libvirt do |v|
      v.cpu_mode = "host-passthrough"
      v.memory  = 12288
      v.nested  = true
      v.cpus    = 10
    end

    config.vm.provision "shell", inline: $script , privileged = false

  end
end
