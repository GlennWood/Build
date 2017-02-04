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

  vm_port_prefix = ENV['VM_PORT_PREFIX']
  config.vm.network :forwarded_port, guest: 22,    host: vm_port_prefix + "22", id: "ssh", disabled: false # SSH
  config.vm.network :forwarded_port, guest: 8080,  host: vm_port_prefix + "80" # Jenkins
  config.vm.network :forwarded_port, guest: 80,    host: vm_port_prefix + "97" # nginx, et.al.
  config.vm.network :forwarded_port, guest: 2812,  host: vm_port_prefix + "98" # Monit
  config.vm.network :forwarded_port, guest: 10000, host: vm_port_prefix + "99" # Webmin

  config.vm.network :private_network, type: "dhcp"
  config.ssh.forward_x11 = true
  #TODO gotta install vb_guest before we can do this
  #Ref https://github.com/dotless-de/vagrant-vbguest
  # %> vagrant plugin install vagrant-vbguest
  config.vbguest.auto_update = ENV['VBGUEST_AUTO_UPDATE']

  config.vm.provider "virtualbox" do |vb|
    vb.memory = ENV['VM_MEMORY']
    vb.cpus   = ENV['VM_CPUS']
  end

  ### Create a sync_folder for each git repo in VM_GIT_REPOS
  gits = ENV['VM_GIT_REPOS'].split(':')
  for git in gits do
    repo = git.gsub(/.*\//, '');
    config.vm.synced_folder git,  '/git/' + repo
  end

  ### Add user's RSA key to VM's authorized_keys
  config.ssh.username = 'vagrant'
  config.ssh.insert_key = false
  ## Ref https://github.com/mitchellh/vagrant/issues/992
  config.ssh.private_key_path = [
    private_key_path,
    insecure_key_path # to provision the first time
  ]
  config.vm.provision :shell, :inline => $authorized_keys

=begin

  config.vm.provision 'file', source: '~/.m2/settings.xml', destination: '~/.m2/settings.xml'

  config.vm.define 'ubuntu-16.04-' + ENV['VM_MODE'] do |os|
    os.vm.box = 'bento/ubuntu-16.04' ; # 'ubuntu-16.04-minimal'
  end
  config.vm.define 'ubuntu-15.10-' + ENV['VM_MODE'] do |os|
    # 'adaptiveme/vivid64' and 'bossjones/scarlett-base-15-10' won't ssh auth # 'kisphp/ubuntu15' thinks it's 12.04! 'gex/base' won't download!
    os.vm.box = 'bento/ubuntu-15.10' #'vivid-server-cloudimg-amd64-vagrant-disk1'
  end
  config.vm.define 'ubuntu-14.04-' + ENV['VM_MODE'] do |os|
    os.vm.box = 'phusion/ubuntu-14.04-amd64'; #FOR DEMO (Vaibhav's) #'bento/ubuntu-14.04' ; # 'ubuntu/trusty64'
  end

  config.vm.define 'fedora-24-' + ENV['VM_MODE'] do |os|
    os.vm.box = 'bento/fedora-24' # 'box-cutter/fedora24' adequate, but let's try bento's
  end
  config.vm.define 'fedora-23-' + ENV['VM_MODE'] do |os|
    os.vm.box = 'bento/fedora-23' # 'box-cutter/fedora23' adequate, but let's try bento's
  end
  config.vm.define 'fedora-22-' + ENV['VM_MODE'] do |os|
    os.vm.box = 'bento/fedora-22' # 'box-cutter/fedora22' adequate, but let's try bento's
  end

  config.vm.define 'centos-7-' + ENV['VM_MODE'] do |os|
    os.vm.box = 'bento/centos-7.2' # 'relativkreativ/centos-7-minimal' adequate, but let's try bento's
  end
  config.vm.define 'centos-6-' + ENV['VM_MODE'] do |os|
    os.vm.box = 'bento/centos-6.7' # 'relativkreativ/centos-6-minimal' # adequate, but let's try bento's; 'centos/6' # 'An error occurred while downloading the remote file.'
  end

=end


  config.vm.provision 'init',    type: 'shell', privileged: true, inline: '/vagrant/build-vm/init'

  config.vm.provision 'docker',  type: 'shell', privileged: true, inline: '/vagrant/build-vm/docker'
  config.vm.provision 'jenkins', type: 'shell', privileged: true, inline: '/vagrant/build-vm/jenkins'
  config.vm.provision 'git-2',   type: 'shell', privileged: true, inline: '/vagrant/build-vm/install-git 2.11.0'
  config.vm.provision 'python',  type: 'shell', privileged: true, inline: '/vagrant/build-vm/install-python 3.4.6'
  config.vm.provision 'ruby',    type: 'shell', privileged: true, inline: '/vagrant/build-vm/install-ruby'
  config.vm.provision 'go',      type: 'shell', privileged: true, inline: '/vagrant/build-vm/install-go'
  config.vm.provision 'coffee',  type: 'shell', privileged: true, inline: '/vagrant/build-vm/install-coffeescript'

  config.vm.provision 'boost',   type: 'shell', privileged: true, inline: '/vagrant/build-vm/install-boost 1.63.0 --with-system --with-thread'
  config.vm.provision 'crow',    type: 'shell', privileged: true, inline: '/vagrant/build-vm/install-crow'

  config.vm.provision 'nginx',   type: 'shell', privileged: true, inline: '/vagrant/build-vm/install-nginx'
  config.vm.provision 'webmin',  type: 'shell', privileged: true, inline: '/vagrant/build-vm/install-webmin'
  config.vm.provision 'monit',   type: 'shell', privileged: true, inline: '/vagrant/build-vm/install-monit'
  config.vm.provision 'munin',   type: 'shell', privileged: true, inline: '/vagrant/build-vm/install-munin'

  config.vm.provision 'final',   type: 'shell', privileged: true, inline: '/vagrant/build-vm/final'
  config.vm.provision 'verify',  type: 'shell', privileged: false,inline: '/vagrant/build-vm/verify'

end

## ########################################################
### Ref http://superuser.com/a/992220
require "open3"
include Open3
module HostShell
    class Config < Vagrant.plugin('2', :config)
        attr_accessor :command
    end
    class Plugin < Vagrant.plugin('2')
        name "host_shell"
        config(:host_shell, :provisioner) do
            Config
        end
        provisioner(:host_shell) do
            HostProvisioner
        end
    end
    class HostProvisioner < Vagrant.plugin('2', :provisioner)
        def provision
          result = system "#{config.command}"
        end
    end
end

module GuestShell
    class Config < Vagrant.plugin('2', :config)
        attr_accessor :command
    end
    class Plugin < Vagrant.plugin('2')
        name "guest_shell"
        config(:guest_shell, :provisioner) do
            Config
        end
        provisioner(:host_shell) do
            Provisioner
        end
    end
    class Provisioner < Vagrant.plugin('2', :provisioner)
        def provision
          result = system "cat #{config.command} | ssh root@localhost -p " + ENV['VM_PORT_PREFIX'] + "22"
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

## ########################################################
$clone_or_pull_repos = <<SCRIPT
## TODO: pull DevOps, then chain to DevOps/build/bin/clone-or-pull-repos

  sudo su - git
    mkdir .ssh && chmod 0700 .ssh
    if [ ! -f .ssh/id_rsa ]; then
      echo -n "${bold}On the next screen, please paste the contents of a github authorized id_rsa; hit enter here when you are ready...${norm}"
      read
      vi .ssh/id_rsa
      chown git:git .ssh/id_rsa && chmod 0600 .ssh/id_rsa
    fi
    for repo in $GIT_REPOS; do
      [ -d ~/$repo ] && git -C ~/$repo pull || git clone $GIT_REPO/${repo}.git
    done
  
    ### If they exist, symlink Jenkins workspaces into here
    if [ -n "$JENKINS_HOME" ]; then
      gpasswd -a jenkins git
      [ -d $JENKINS_HOME/workspace ] || mkdir -p $JENKINS_HOME/workspace
      for repo in $GIT_REPOS; do
         ln -sf /home/git/$repo $JENKINS_HOME/workspace/$repo
      done
    fi

  exit
  
  ### If jenkins account exists, share git's id_rsa with it
  if [ -n "$JENKINS_HOME" ]; then
    [ ! -d $JENKINS_HOME/.ssh ] && mkdir $JENKINS_HOME/.ssh && chown jenkins:jenkins $JENKINS_HOME/.ssh && chmod 0700 $JENKINS_HOME/.ssh
    cp /home/git/.ssh/id_rsa $JENKINS_HOME/.ssh/
    chown jenkins:jenkins $JENKINS_HOME/.ssh/id_rsa && chmod 0600 $JENKINS_HOME/.ssh/id_rsa
  fi

  echo $PATH | grep '/home/git/DevOps/build/bin' || export PATH=/home/git/DevOps/build/bin:$PATH
SCRIPT
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
