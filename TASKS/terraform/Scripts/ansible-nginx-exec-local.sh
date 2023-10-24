#!/bin/bash

# add env variables for ansible which are supposed to ignore key checking
export ANSIBLE_HOST_KEY_CHECKING=False

# ansible playbook with an argument for the inventory ip address
ansible-playbook -i $1, -u ubuntu --private-key=$2 ../../../Ansible/playbook_nginx_inst.yml
