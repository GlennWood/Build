# -*- mode: ruby -*-
# vi: set ft=ruby :

### ###### ###### ###### ###### ###### ###### ######
### Builds VM in which to build DeterDevOpsTryout
### ###### ###### ###### ###### ###### ###### ######

VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version ">=1.7.0"

## ########################################################
## From https://github.com/mitchellh/vagrant/issues/992
private_key_path = ENV['HOME'] + '/.ssh/id_rsa'
insecure_key_path = File.join(Dir.home, ".vagrant.d", "insecure_private_key")
private_key = IO.read(private_key_path)
public_key  = IO.read(private_key_path + '.pub')

## ########################################################
$authorized_keys = <<-SCRIPT
  echo '#{public_key}' >> /home/vagrant/.ssh/authorized_keys
  chmod 0600 /home/vagrant/.ssh/authorized_keys
  chown vagrant:vagrant /home/vagrant/.ssh/*
SCRIPT
## ########################################################

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

  config.ssh.username = 'vagrant'
  config.ssh.insert_key = false
  ## From https://github.com/mitchellh/vagrant/issues/992
  config.ssh.private_key_path = [
    private_key_path,
    insecure_key_path # to provision the first time
  ]
  config.vm.provision :shell, :inline => $authorized_keys

  config.vm.provision 'init',    type: 'shell', privileged: true, inline: '/vagrant/build-vm/init'
  config.vm.provision 'docker',  type: 'shell', privileged: true, inline: '/vagrant/build-vm/docker'
  config.vm.provision 'jenkins', type: 'shell', privileged: true, inline: '/vagrant/build-vm/jenkins'
  config.vm.provision 'git-2',   type: 'shell', privileged: true, inline: '/vagrant/build-vm/install-git 2.11.0'
  config.vm.provision 'python',  type: 'shell', privileged: true, inline: '/vagrant/build-vm/install-python'
  config.vm.provision 'ruby',    type: 'shell', privileged: true, inline: '/vagrant/build-vm/install-ruby'
  config.vm.provision 'go',      type: 'shell', privileged: true, inline: '/vagrant/build-vm/install-go'
  config.vm.provision 'coffee',  type: 'shell', privileged: true, inline: '/vagrant/build-vm/install-coffeescript'
  config.vm.provision 'boost',   type: 'shell', privileged: true, inline: '/vagrant/build-vm/install-boost 1.63.0 --with-system --with-thread'
  config.vm.provision 'crow',    type: 'shell', privileged: true, inline: '/vagrant/build-vm/install-crow'
  config.vm.provision 'final',   type: 'shell', privileged: true, inline: '/vagrant/build-vm/final'
  config.vm.provision 'verify',  type: 'shell', privileged: false,inline: '/vagrant/build-vm/verify'

end

require "open3"
include Open3

### Ref http://superuser.com/a/992220
module HostCommand
    class Config < Vagrant.plugin('2', :config)
        attr_accessor :command
    end
    class Plugin < Vagrant.plugin('2')
        name "host_shell"
        config(:host_shell, :provisioner) do
            Config
        end
        provisioner(:host_shell) do
            Provisioner
        end
    end
    class Provisioner < Vagrant.plugin('2', :provisioner)
        def provision
          result = system "#{config.command}"
        end
    end
end
## ########################################################
## Ref http://stackoverflow.com/a/16363159
class String
def black;          "\e[30m#{self}\e[0m" end
def red;            "\e[31m#{self}\e[0m" end
def green;          "\e[32m#{self}\e[0m" end
def brown;          "\e[33m#{self}\e[0m" end
def blue;           "\e[34m#{self}\e[0m" end
def magenta;        "\e[35m#{self}\e[0m" end
def cyan;           "\e[36m#{self}\e[0m" end
def gray;           "\e[37m#{self}\e[0m" end

def bg_black;       "\e[40m#{self}\e[0m" end
def bg_red;         "\e[41m#{self}\e[0m" end
def bg_green;       "\e[42m#{self}\e[0m" end
def bg_brown;       "\e[43m#{self}\e[0m" end
def bg_blue;        "\e[44m#{self}\e[0m" end
def bg_magenta;     "\e[45m#{self}\e[0m" end
def bg_cyan;        "\e[46m#{self}\e[0m" end
def bg_gray;        "\e[47m#{self}\e[0m" end

def bold;           "\e[1m#{self}\e[22m" end
def italic;         "\e[3m#{self}\e[23m" end
def underline;      "\e[4m#{self}\e[24m" end
def blink;          "\e[5m#{self}\e[25m" end
def reverse_color;  "\e[7m#{self}\e[27m" end
end
## ########################################################

#if File.file?('./vagrant.lock') || File.file?('/var/run/isi/' + ENV['VM_MACHINE'] + '.vagrant.lock') then
#  print "Vagrant lockfile for " + ENV['VM_MACHINE'] + " exists; terminating\n"
#  exit(false)
#end

if ARGV[0].eql? "ssh" then
  ENV['VM_PORT_PREFIX'] = "<default>"
else
  if ENV['VM_NAME'].nil? || ENV['VM_MEMORY'].nil? || ENV['VM_CPUS'].nil? || ENV['VM_PORT_PREFIX'].nil? then
    puts "This Vagrantfile requires VM_NAME, VM_MEMORY, VM_CPUS and VM_PORT_PREFIX environment variables."
    puts "This is customarily set by " + "source ./environment".bold.cyan + " before the " + "vagrant ".bold.green + ARGV[0].bold.green
    exit(false)
  end
end
