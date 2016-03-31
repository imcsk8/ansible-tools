#!/bin/bash


echo "Prepare RDO environment for installng packstack"

BRANCH=$1

case ${BRANCH} in
    *mitaka)
        echo "Using mitaka repos"
        curl http://trunk.rdoproject.org/centos7-mitaka/current-passed-ci/delorean.repo | tee /etc/yum.repos.d/delorean.repo
    ;;
    *liberty)
        echo "Using liberty repos"
        yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-liberty/rdo-release-liberty-2.noarch.rpm
    ;;
    *kilo)
        echo "Using kilo repos"
        yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-kilo/rdo-release-kilo-1.noarch.rpm
    ;;
    *juno)
        echo "Using juno repos"
        yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-juno/rdo-release-juno-1.noarch.rpm
    ;;
    *)
        echo "No branch added using delorean"
        curl http://trunk.rdoproject.org/centos7-master/delorean-deps.repo |tee /etc/yum.repos.d/delorean-deps.repo
        curl http://trunk.rdoproject.org/centos7-master/current/delorean.repo |tee /etc/yum.repos.d/delorean.repo
        #yum install -y https://rdoproject.org/repos/rdo-release.rpm
    ;;

esac

yum groupinstall -y 'Development Tools';
yum -y upgrade
