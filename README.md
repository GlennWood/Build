# Build
The build environment (Jenkins) for DeterDevOpsTryout

## Prerequisites

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)

    vagrant plugin install vagrant-vbguest

## Building the Build Environment

* Get the source code

    git clone git@github.com:GlennWood/Build.git
    Build/git-deterdevopstryout.sh

* Build the VM

This takes about 10 minutes on a MacBook Pro

    cd Build
    source ./environment ; vagrant up

To start over from scratch

    source ./environment ; vagrant destroy -f ; time vagrant up

* Rebuild and/or Destroy VM

Sometimes heroic efforts are required to rebuild a VM; `vagrant destroy` reports that 
the VM doesn't exist, while `vagrant up` says it already exists (this can happen sometimes 
if you abort a `vagrant up` while it is in the initial phase of building the VM).
Two scripts have been composed to deal with this situation:

    scripts/destroy-vm $VM_NAME
    scripts/rebuild-vm $VM_NAME

(`rebuild-vm` starts its process with a `destroy-vm`)


* Work in the VM

    vagrant ssh

Or

    ssh -p 6722 root@localhost

* Start docker containers

(this will be automated soon)

    sudo su -
    docker-compose -f docker-compose.yml -f docker-compose.ci.yml up -d

* The Jenkins Server

Now you have the following URL - [http://localhost:6780](http://localhost:6780) (the "67" comes from VM_PORT_PREFIX in the `environment` file).

You will need to go there to manually initialize Jenkins (this will be automated eventually).

Then "Create First Admin User". Suggestions `admin:pa55word`, full name "Jenkins Administrator" 
and your own email address. Install the suggested plugins (this might be automated eventually).

Now manually `New Items` the build jobs as empty, but named jobs.
Name them `Customer`, `Waiter`, `SousChef`, `PizzaChef`, `Mixer` and `WoodbrickOven`,
then execute `config/get-configs.sh` and `service jenkins restart`.
This will be [automated](https://wiki.jenkins-ci.org/display/JENKINS/Remote+access+API) soon 
by [jenkinsapi](https://pypi.python.org/pypi/jenkinsapi) and [python-jenkins](https://pypi.python.org/pypi/python-jenkins/).

You may want to install [Jenkins Dependency Graph](https://wiki.jenkins-ci.org/display/JENKINS/Dependency+Graph+View+Plugin).


## References

* [The Research Software Engineer](https://dirkgorissen.com/2012/09/13/the-research-software-engineer/)
* [Science Code Manifesto](http://sciencecodemanifesto.org/)

* [Install Jenkins](https://www.vultr.com/docs/how-to-install-jenkins-on-centos-7)
* [Using Docker](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-centos-7)

* [Apache Maven FAQ](https://maven.apache.org/general.html)
* [Jenkins Tutorial: How to Execute Python Scripts](http://www.craftycomputing.com/run-python-scripts-jenkins/)

* [Install Ruby](https://www.ruby-lang.org/en/documentation/installation/)
* [Ruby binaries](http://phusion.github.io/traveling-ruby/) and [Getting Started](https://github.com/phusion/traveling-ruby#getting-started)
* [The Go Programming Language](https://golang.org/doc/install)
* [Nuitka (python to binary)](http://nuitka.net/doc/user-manual.html)
