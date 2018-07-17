

. ./init.sh


#KEYFILES="${CUR_DIR}/../roles/ssh/files/authorized_keys"
#cat /dev/null > KEYFILES
#cat /root/.ssh/id_rsa.pub >> KEYFILES
inventory=${INVENTORY:-${INVENTORY_DIR}/inventory}


#ansible_playbook ${inventory} ${PLAYBOOKS_DIR}/node_registry_check.yaml
ansible_playbook ${inventory} ${PLAYBOOKS_DIR}/cluster_network_check.yml
ansible_playbook ${inventory} ${PLAYBOOKS_DIR}/firewalld_check.yml
ansible_playbook ${inventory} ${PLAYBOOKS_DIR}/check_base.yml

echo "ansible_playbook  ${PLAYBOOKS_DIR}/check_base.yml -i ${inventory} "
