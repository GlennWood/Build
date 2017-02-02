# Build
The build environment (Jenkins) for DeterDevOpsTryout

## Building the Build Environment

* Get the source code

    git clone git@github.com:GlennWood/Build.git
    Build/git-deterdevopstryout.sh

* Build the VM

This takes about 10 minutes on a MacBook Pro

    cd Build
    source ./environment ; vagrant up

To start over from scratch

    source ./environment ; vagrant destroy -f ; vagrant up

* Work in the VM

    vagrant ssh

Or

    ssh -p 6722 vagrant:vagrant@localhost

* Start docker containers

(this will be automated soon)

    sudo su -
    docker-compose -f docker-compose.yml -f docker-compose.ci.yml up -d

## References

* [Using Docker](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-centos-7)
