function print_start_deploy_product(){
    local product_name=$1
    echo ""
    echo "#######################"
    echo "# 开始部署 ${product_name}"
    echo "#######################"
    echo ""
}


print_start_deploy_product "新添加的minions节点"

. ./init.sh


#KEYFILES="${CUR_DIR}/../roles/ssh/files/authorized_keys"
#cat /dev/null > KEYFILES
#cat /root/.ssh/id_rsa.pub >> KEYFILES
inventory=${INVENTORY:-${INVENTORY_DIR}/inventory}

  ansible_playbook ${inventory} ${PLAYBOOKS_DIR}/add-minions.yml "$@"
  ansible_playbook ${inventory} ${PLAYBOOKS_DIR}/roleset.yml "$@"

echo "ansible_playbook  ${PLAYBOOKS_DIR}/mininos.yml -i ${inventory}  "