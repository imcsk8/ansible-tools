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
python setup.py install_puppet_modules

echo "installing temporal dependencies"
yum install -y python-pip
easy_install oslo.privsep
