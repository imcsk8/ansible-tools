#!/bin/bash


echo "Prepare RDO environment for installng packstack"

BRANCH=$1

case ${BRANCH} in
    *liberty)
        yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-liberty/rdo-release-liberty-2.noarch.rpm
    ;;
    *kilo)
        yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-kilo/rdo-release-kilo-1.noarch.rpm
    ;;
    *juno)
        yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-juno/rdo-release-juno-1.noarch.rpm
    ;;
    *)
        echo "No branch added using delorean"
        curl http://trunk.rdoproject.org/centos7/delorean-deps.repo |tee /etc/yum.repos.d/delorean-deps.repo
        curl http://trunk.rdoproject.org/centos7/current/delorean.repo |tee /etc/yum.repos.d/delorean.repo
        yum install -y https://rdoproject.org/repos/rdo-release.rpm
    ;;

esac

yum groupinstall -y 'Development Tools';
yum -y upgrade