#!/bin/bash

# Deploy packstack

BRANCH=$1
REVIEWS=$2

IFS=':' read -r -a REVIEWS <<< "$2"

if [[ ${BRANCH} == "" ]]; then
    BRANCH="master"
fi

cd
git clone -b $BRANCH https://github.com/openstack/packstack.git packstack
cd packstack


git config --global user.email "packstack_tester@example.com"
git config --global user.name "Packstack Tester"

for review in "${REVIEWS[@]}"; do
    if [[ ${review} != "" ]]; then
        PICK="git fetch https://review.openstack.org/openstack/packstack $review && git cherry-pick FETCH_HEAD"
    else
        PICK=""
    fi

    if [[ ${PICK} != "" ]]; then
        echo "Applying ${PICK}"
        eval "${PICK}"
    fi
done

python setup.py install
cd ~/packstack
export GEM_HOME=/tmp/opm-install
yum install -y rubygems
gem install r10k
/tmp/opm-install/bin/r10k puppetfile install -v
cp -r packstack/puppet/modules/packstack /usr/share/openstack-puppet/modules

echo "installing temporal dependencies"
yum install -y python-pip
easy_install oslo.privsep
