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

* The Jenkins Server

Now you have the following URL - http://localhost:6780 (the "67" comes from VM_PORT_PREFIX in the `environment` file).

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

* [Install Jenkins](https://www.vultr.com/docs/how-to-install-jenkins-on-centos-7)
* [Jenkins Dependency Graph](https://wiki.jenkins-ci.org/display/JENKINS/Dependency+Graph+View+Plugin)

* [Using Docker](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-centos-7)

