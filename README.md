# ansible-tools
Tools and playbooks for use with Ansible



## Packstack tests

Packstack tests are perfomed by a set of scripts:

### review_packstack

./review_packstack virtual_machine_name  branch  'git review ids' tags playbook sleep_time 

```
./review_packstack virtual_machine_name  master  'refs/changes/03/220703/1' tags allinone.yaml 
```
