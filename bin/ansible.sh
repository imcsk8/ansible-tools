#!/bin/bash

# Test gerrit patches for packstack

NAME=$1
BRANCH=$2
REVIEW=$3
TAGS=$4
PLAYBOOK=$5
TEMPLATE=$6
SLEEP=$7
RELEASE=$8
TAG_SWITCH=""


function create_vm {
    ./clone $1 $2
    ./start $NAME
    echo "Waiting $SLEEP seconds for the VM to come up"
    sleep $SLEEP
    IP=`./virt-addr.pl $NAME`
    echo $IP >> ./packstack-test-hosts
}


if [[ ${TEMPLATE} == "" ]]; then
    TEMPLATE="CentOS-7.0-Template"
fi

PLAYBOOK_PATH='/home/ichavero/ansible-tools.git/playbook/packstack/'
DEFAULT_PLAYBOOK='allinone.yml'

if [[ ${RELEASE} != ""  ]]; then
    PLAYBOOK="allinone-rhos.yml"
    TEMPLATE="RHEL-7.2-Template"
else
    PLAYBOOK=$DEFAULT_PLAYBOOK
fi

echo "Setting playbook to ${PLAYBOOK}"

if [[ ${TAGS} != "" ]]; then
    TAG_SWITCH="--tags ${TAGS}"
fi

if [[ "${SLEEP}" == "" ]]; then
    SLEEP=60
fi



echo "[VM]" > ./packstack-test-hosts 
create_vm $TEMPLATE $NAME



screen -L -h 1000 -t $NAME -dmS $NAME ansible-playbook -i ./packstack-test-hosts  --extra-vars "name=$NAME branch=$BRANCH reviews=$REVIEW" $PLAYBOOK $TAG_SWITCH

screen -t "$NAME-console" -dmS "$NAME-console" ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null root@$IP 'touch /home/packstack.log; tail -f /home/packstack.log'




