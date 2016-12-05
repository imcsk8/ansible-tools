#!/bin/bash

# Test gerrit patches for packstack

NAME=$1
BRANCH=$2
REVIEW=$3
TAGS=$4
if [[ ${PLAYBOOK} == "" ]]; then
    PLAYBOOK=$5
else 
    echo "Using PLAYBOOK from environment"
fi
TEMPLATE=$6
SLEEP=$7
RELEASE=$8
TAG_SWITCH=""

# Change this to your playbook path
if [[ ${PLAYBOOK_PATH} == "" ]]; then
    PLAYBOOK_PATH="${HOME}/utils/ansible-tools.git/playbooks/packstack/"
else
    echo "Using PLAYBOOK_PATH from environment"
fi

DEFAULT_PLAYBOOK='allinone.yml'

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


if [[ ${PLAYBOOK} == ""  ]]; then
    PLAYBOOK="${PLAYBOOK_PATH}/${DEFAULT_PLAYBOOK}"
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


# Create a screen session for the playbook execution
screen -L -h 1000 -t $NAME -dmS $NAME ansible-playbook -i ./packstack-test-hosts  --extra-vars "name=$NAME branch=$BRANCH reviews=$REVIEW" $PLAYBOOK $TAG_SWITCH

# Create a screen session for viewing the packstack log file
screen -t "$NAME-console" -dmS "$NAME-console" ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null root@$IP 'touch /home/packstack.log; tail -f /home/packstack.log'




