#!/bin/bash

GITHUB='git@github.com:GlennWood'
REPOS='Build Intro Customer Waiter SousChef PizzaChef Mixer WoodbrickOven'

for repo in $REPOS; do
	[ ! -d $repo ] && git clone $GITHUB/$repo.git || git -C $repo pull $GITHUB/$repo.git
done
