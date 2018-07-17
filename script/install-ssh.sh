

. ./init.sh


#KEYFILES="${CUR_DIR}/../roles/ssh/files/authorized_keys"
#cat /dev/null > KEYFILES
#cat /root/.ssh/id_rsa.pub >> KEYFILES
inventory=${INVENTORY:-${INVENTORY_DIR}/inventory}

ansible_playbook ${inventory} ${PLAYBOOKS_DIR}/ssh.yml 

echo "ansible-playbook  ${PLAYBOOKS_DIR}/ssh.yml -i ${inventory} "
