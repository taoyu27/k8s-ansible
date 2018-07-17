#### 设置首次 部署节点名称、节点IP、管理员账号密码 ########
registry ansible_host=172.16.71.222 ansible_user=root ansible_ssh_pass=huacloud
lb1  ansible_host=172.16.63.198 ansible_user=root ansible_ssh_pass=huacloud
lb2 ansible_host=172.16.63.199 ansible_user=root ansible_ssh_pass=huacloud
master1 ansible_host=172.16.63.200 ansible_user=root ansible_ssh_pass=huacloud
master2 ansible_host=172.16.63.201 ansible_user=root ansible_ssh_pass=huacloud
master3 ansible_host=172.16.63.202 ansible_user=root ansible_ssh_pass=huacloud
node1 ansible_host=172.16.63.203 ansible_user=root ansible_ssh_pass=huacloud
node2 ansible_host=172.16.63.204 ansible_user=root ansible_ssh_pass=huacloud

#### 添加部署新minion节点的节点名称、节点IP 、管理员账号密码 ########
#node3 ansible_host=172.16.63.205 ansible_user=root ansible_ssh_pass=huacloud



#### 角色定义
###### harbor镜像服务器组
[registries]
registry

###### 负载均衡服务器组
[lbs]
lb1 STATE=MASTER     PRI=100  INTERFACE_NAME=eth0
lb2 STATE=BACKUP     PRI=98   INTERFACE_NAME=eth0

###### master服务器组
[masters]
master1
master2
master3

###### 工作节点服务器组
[minions]
node1
node2
### 将新添加的节点放入add_minions组             ###################
[add_minions]
#node3

[kubernetes:children]
masters
minions
add_minions

[machines:children]
kubernetes
registries
lbs

[helm]
master1

[chrony_server]
registry

[chrony_clients:children]
masters
minions
lbs

###### etcd服务器组
[etcd]
master1
master2
master3

