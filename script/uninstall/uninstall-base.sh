 
. ../init.sh


#KEYFILES="${CUR_DIR}/../roles/ssh/files/authorized_keys"
#cat /dev/null > KEYFILES
#cat /root/.ssh/id_rsa.pub >> KEYFILES
inventory=${INVENTORY:-${INVENTORY_DIR}/inventory}
ansible_playbook ${inventory} ${PLAYBOOKS_DIR}/base-erase.yml "$@"
echo "ansible_playbook  ${PLAYBOOKS_DIR}/base-erase.yml -i ${inventory} "$@""