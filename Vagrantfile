# -*- mode: ruby -*-
# vi: set ft=ruby :

### ###### ###### ###### ###### ###### ###### ######
### Builds VM in which to build DeterDevOpsTryout
### ###### ###### ###### ###### ###### ###### ######

VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version ">=1.7.0"


### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.hostname = ENV['VM_NAME']

  config.vm.box = "relativkreativ/centos-7-minimal"
  config.vm.provider "virtualbox" do |vbox|
    vbox.name = ENV['VM_NAME']
  end

  config.vm.network :forwarded_port, guest: 22,   host: ENV['VM_PORT_PREFIX'] + "22", id: "ssh", disabled: false # SSH
  config.vm.network :forwarded_port, guest: 8080, host: ENV['VM_PORT_PREFIX'] + "80" # Jenkins
  config.vm.network :private_network, type: "dhcp"
  config.ssh.forward_x11 = true

  config.vm.provider "virtualbox" do |vb|
    vb.memory = ENV['VM_MEMORY']
    vb.cpus   = ENV['VM_CPUS']
  end

  config.vm.provision 'init',    type: 'shell', privileged: true, inline: '/vagrant/build-vm/init'
  config.vm.provision 'git-2',   type: 'shell', privileged: true, inline: '/vagrant/build-vm/install-git'
  config.vm.provision 'docker',  type: 'shell', privileged: true, inline: '/vagrant/build-vm/docker'
  config.vm.provision 'jenkins', type: 'shell', privileged: true, inline: '/vagrant/build-vm/jenkins'
  config.vm.provision 'final',   type: 'shell', privileged: true, inline: '/vagrant/build-vm/final'
  config.vm.provision 'verify',  type: 'shell', privileged: false,inline: '/vagrant/build-vm/verify'

end
