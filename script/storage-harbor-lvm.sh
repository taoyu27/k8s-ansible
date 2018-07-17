function print_start_deploy_product(){
    local product_name=$1
    echo ""
    echo "#######################"
    echo "# 开始部署 ${product_name}"
    echo "#######################"
    echo ""
}

check_inventory() {
	inv_dir=$(dirname $1)
	if [ ! -e "${inv_dir}/group_vars" ]; then
		echo "Inventory directory ${inv_dir} is missing group_vars directory"
		exit 1
	fi
}

ansible_playbook() {
	inventory=$1
	check_inventory ${inventory}
	ansible-playbook -i "$@"
}

print_start_deploy_product "配置harbor机器的镜像存储卷"


CUR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

INVENTORY_DIR="${CUR_DIR}/../inventory"
PLAYBOOKS_DIR="${CUR_DIR}/../playbooks"
#KEYFILES="${CUR_DIR}/../roles/ssh/files/authorized_keys"
#cat /dev/null > KEYFILES
#cat /root/.ssh/id_rsa.pub >> KEYFILES
inventory=${INVENTORY:-${INVENTORY_DIR}/inventory}

ansible_playbook ${inventory} ${PLAYBOOKS_DIR}/harbor-lvm.yml "$@"

echo "ansible_playbook  ${PLAYBOOKS_DIR}/docker-lvm.yml -i ${inventory} "$@""