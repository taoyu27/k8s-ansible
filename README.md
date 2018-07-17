前置条件：
     
     本次部署前需要在jenkins上的iso_build视图中使用 fast_iso_build 进行 产品的发布和打包操作，以求获取到最新的 安装包 、 安装源包和镜像包。
     
初始化集群
执行部署

1. 登录parsar平台： http://172.16.74.25/nebula/instances

   Username: fast@chinacloud.com.cn

   Password: 12345678
   
2. 新建4个虚拟机（推荐4G/4核）,请使用k8s-base镜像或者标准的centos-mini镜像生成

  a)         Autodeployserver, 部署服务器     Harbor镜像仓库
  
  b)         Master， 控制节点
  
  c)         Node1， 工作节点
  
  d)         Node2，工作节点

3. 新建数据卷，并挂在到相应虚拟机

  a)         harbor镜像仓库挂载数据卷
  
       新建两个数据卷，
       
        l  Harbor-docker-lvm用于docker storage  （vdb）
        
        l  Harbor-storage 用于镜像数据备份   （vdc）
        
       挂载之前创建的2个数据卷（注意： 先挂载size较小的数据卷，然后挂载size较大的）


   b)         Master节点挂载数据卷
   
       新建数据卷用于docker storage， master-docker-lvm    （vdb）
       
       挂载数据卷
       
   c)         Node1节点挂载数据卷
   
       新建数据卷用于docker storage，node1-docker-lvm      （vdb）
       
       挂载数据卷
       
   d)         Node2节点挂载数据卷
   
       新建数据卷用于docker storage，node2-docker-lvm      （vdb）
       
       挂载数据卷

4. 登录节点并设置相应信息(username: root,  password: huacloud)   [使用k8s-base镜像建的虚拟机需要如下设置， 其他的镜像生成不需要]

   a)         登录Autodeployserver，master，node所在虚拟机
   
   b)        选择1 设置hostname，并遵循xx.xx的规则,如：harbor.com, master.com.. 并选择2 设置网络
   
   c)         选择3）退出



5. 手动部署部署节点环境

   a)         登陆autodeployserver，root/huacloud
   
   b)         下载文件
   

    cd /opt
    wget http://172.16.101.146/repo_install_bags/mir2-ansible.tar.gz
    wget http://172.16.101.146/repo_install_bags/chinacloud_repo.tar.gz
    wget http://172.16.101.146/chinacloud_mir2_iso/harbor_data_fast_xxxxxxx_xxxxx.tar.gz

c)         解压文件到指定位置


    cd /opt
    mkdir -p /opt/repo/latest
    tar -zxf  chinacloud_repo.tar.gz -C /opt/repo/latest
    tar -zxvf  mir2-ansible.tar.gz  -C /tmp&&cd  /tmp/ansible/script
    bash  install-ansible.sh



6. 修改inventory变量文件

   a)         登录autodeployserver, root/huacloud
   
   b)         修改一下配置信息
   
    [root@autodeploy ~]# vim /etc/ansible/inventory/inventory

    ......
    registry ansible_host=172.16.71.222 ansible_user=root ansible_ssh_pass=huacloud （和autodeployserver合并）
    master ansible_host=172.16.63.200 ansible_user=root ansible_ssh_pass=huacloud
    node1 ansible_host=172.16.63.201 ansible_user=root ansible_ssh_pass=huacloud
    node2 ansible_host=172.16.63.202 ansible_user=root ansible_ssh_pass=huacloud
    .......
    ....

7. 修改group_vars/all.yaml文件

   a)         登录autodeployserver, root/huacloud
   
   b)         修改以下变量
   
   [root@autodeploy ~]# vim /etc/ansible/inventory/group_vars/all.yml
    
    pv_name: /dev/sda3 ---------------> pv_name: /dev/vdb (用fdisk -l查询外挂数据卷名称)

    reposerver: 172.16.71.222


8. 在autodeployserver与节点之间建立无秘钥登录

    a)         登录autodeployserver, root/huacloud
    
    b)         执行以下命令
    
    [root@autodeploy opt]# cd /etc/ansible/script
    
    [root@autodeploy script]# ./install-ssh.sh

9. 配置direct-lvm模式

   a)         登录autodeployserver, root/huacloud
   
   b)         cd /etc/ansible/script/
   
   c)         执行以下命令
   
   [root@autodeploy script]# ./storage-setup-lvm.sh


    部署harbor镜像仓库 （如果使用公共镜像库，此步骤可以省略， 省略请在inventory的[machines:children]中删除registries，避免影响公共的镜像库）
    
    d)         登录autodeployserver节点， root/huacloud
    
    e)         格式化外接数据卷（/dev/vdc），并挂载到/harbor(新建),并将harbor数据卷解压到指定位置
    
    [root@harbor tmp]#  fdisk /dev/vdc (按需分区)
    
    [root@harbor tmp]# mkdir  -p  /data
    
    [root@harbor tmp]#  mkfs.xfs  /dev/vdc1
    
    [root@harbor tmp]#  mount  /dev/vdc1  /data
    
    root@harbor tmp]#   cd  /opt/&&tar -zxf  harbor_data_fast_xxxxx_xxx.tar.gz  -C  /


    f)          登录部署节点，并执行以下脚本
    
    [root@autodeploy opt]# cd /etc/ansible/script
    
    [root@autodeploy script]# ./deploy-registry.sh
    
    g)         安装完后请登陆harbor
    
    http://{ autodeployserver_ip}    登陆：用户名：admin  密码： Harbor12345
    
    其中至少包含 kubernetes 项目，并且至少包含 k8s-dns*  hypercube  pause-amd64 flannel 等等基础镜像

10. 部署kubernetes集群

    a)         登录autodeployserver, root/huacloud
    
    b)         cd /etc/ansible/script/
    
    c)         执行以下命令
    
    [root@autodeploy script]# ./deploy-cluster.sh

后期集群添加节点

1.建立虚拟机并挂载存储卷，并登陆配置主机名 、网络 、 对存储卷进行分区。

    和初始化集群相同。并保证存储卷的的docker分区与其他分区相同 都是/dev/vdb1
    
    例子： 添加一个新节点  172.16.63.203
2.新配置inventory变量文件

    a)         登录autodeployserver, root/huacloud
    
    b)         修改一下配置信息
    
    [root@autodeploy ~]# vim /etc/ansible/inventory/inventory
    
    #### 设置首次 部署节点名称、节点IP、管理员账号密码 ########
    registry ansible_host=172.16.71.222 ansible_user=root ansible_ssh_pass=huacloud
    master ansible_host=172.16.63.200 ansible_user=root ansible_ssh_pass=huacloud
    node1 ansible_host=172.16.63.201 ansible_user=root ansible_ssh_pass=huacloud
    node2 ansible_host=172.16.63.202 ansible_user=root ansible_ssh_pass=huacloud

    #### 添加部署新minion节点的节点名称、节点IP 、管理员账号密码 ########
    node3 ansible_host=172.16.63.203 ansible_user=root ansible_ssh_pass=huacloud

    #### 角色定义
    [registries]
    registry

    [masters]
    master

    [minions]
    node1
    node2

    ### 将新添加的节点放入add_minions组             ###################
    [add_minions]
    node3
3.配置新节点的direct-lvm模式

   a)         登录autodeployserver, root/huacloud
   
   b)         cd /etc/ansible/script/
   
   c)         执行以下命令
   
   [root@autodeploy opt]# cd /etc/ansible/script
   
   [root@autodeploy script]# ./add-minions-lvm.sh
   
4. 部署kubernetes集群

   a)         登录autodeployserver, root/huacloud
   
   b)         cd /etc/ansible/script/
   
   c)         执行以下命令
   
   [root@autodeploy opt]# cd /etc/ansible/script
   
   [root@autodeploy script]# ./deploy-add-mininos.sh