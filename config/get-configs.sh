#!/bin/bash

  JOBS='Customer Waiter SousChef PizzaChef Mixer WoodbrickOven'
  pushd /var/lib/jenkins
  for job in $JOBS; do
	[ ! -d jobs/$job ] && mkdir jobs/$job
	cp jobs/$job/config.xml /vagrant/config/$job.xml
  done
  popd
