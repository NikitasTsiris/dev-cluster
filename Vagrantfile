# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "dev-vm" do |node|

    node.vm.box               = "generic/ubuntu1804"
    node.vm.box_check_update  = true

    node.vm.network "private_network" , ip: "192.168.121.220"
    node.vm.hostname          = "dev-cluster"

    node.vm.provider :libvirt do |v|
      v.cpu_mode = "host-passthrough"
      v.memory  = 8129
      v.nested  = true
      v.cpus    = 8
    end

    config.vm.provision "shell", path: "install-kubernetes.sh"

  end
end
