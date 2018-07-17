


. ./init.sh
. ./deploy-chrony.sh

inventory=${INVENTORY:-${INVENTORY_DIR}/inventory}

ansible_playbook ${inventory} ${PLAYBOOKS_DIR}/base.yml  "$@"
