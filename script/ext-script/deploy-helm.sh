

# before your start, you need to download the helm client from github: https://github.com/kubernetes/helm/releases
# you have to down load the tiller image from the gcr.io firstly, if you can not access the google
# and, push the tiller image into your local registry. you can indicate the registry path of image when you 
# start the helm init



. ../init.sh

#KEYFILES="${CUR_DIR}/../roles/ssh/files/authorized_keys"
#cat /dev/null > KEYFILES
#cat /root/.ssh/id_rsa.pub >> KEYFILES
inventory=${INVENTORY:-${INVENTORY_DIR}/inventory}

ansible_playbook ${inventory} ${PLAYBOOKS_DIR}/helm.yml 

echo "ansible_playbook  ${PLAYBOOKS_DIR}/helm.yml -i ${inventory}"