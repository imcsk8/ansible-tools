#!/bin/bash


echo "Prepare RDO environment for installng packstack"

echo "nameserver 8.8.8.8" > /etc/resolv.conf

BRANCH=$1

case ${BRANCH} in
    *newton)
        echo "Using mitaka repos"
        yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-newton/rdo-release-newton-2.noarch.rpm
    ;;
    *mitaka)
        echo "Using mitaka repos"
        yum install -y http://rdoproject.org/repos/openstack-mitaka/rdo-release-mitaka.rpm
    ;;
    *liberty)
        echo "Using liberty repos"
        yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-liberty/rdo-release-liberty-5.noarch.rpm
    ;;
    *kilo)
        echo "Using kilo repos"
        yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-kilo/rdo-release-kilo-2.noarch.rpm
    ;;
    *)
        echo "No branch added using delorean"
        curl http://trunk.rdoproject.org/centos7/current/delorean.repo |tee /etc/yum.repos.d/dlrn.repo
        curl http://trunk.rdoproject.org/centos7/dlrn-deps.repo |tee /etc/yum.repos.d/dlrn-deps.repo
    ;;

esac

yum groupinstall -y 'Development Tools';
yum -y upgrade
