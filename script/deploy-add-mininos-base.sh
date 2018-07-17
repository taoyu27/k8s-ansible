function print_start_deploy_product(){
    local product_name=$1
    echo ""
    echo "#######################"
    echo "# 开始部署 ${product_name}"
    echo "#######################"
    echo ""
}


print_start_deploy_product "添加的minions节点base安装"

. ./init.sh


#KEYFILES="${CUR_DIR}/../roles/ssh/files/authorized_keys"
#cat /dev/null > KEYFILES
#cat /root/.ssh/id_rsa.pub >> KEYFILES
inventory=${INVENTORY:-${INVENTORY_DIR}/inventory}

  ansible_playbook ${inventory} ${PLAYBOOKS_DIR}/add-minions-base.yml "$@"

echo "ansible_playbook  ${PLAYBOOKS_DIR}/add-minions-base.yml -i ${inventory}  "