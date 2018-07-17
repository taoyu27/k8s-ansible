#!/bin/bash


CUR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PKG_SOURCE="${CUR_DIR}/../"
PKG_DES="/etc/ansible/"



echo "运行本脚本会将本机设置为mir2的自动化部署节点（mir2-autodeploy），请按照提示输入主机名和本机IP地址!"
sleep 3

export COLUMNS=100

tty | egrep "pts" && stty erase ^H

function changeLineOrAddToLastLine(){
    filePath="$1"
    oldlineContext="$2"
    newlineContext="$3"

    count=`/bin/egrep "$oldlineContext" "$filePath" | wc -l`
    if [ $count -eq 0 ];then
        # 添加到末尾
        echo "${newlineContext}" >> "$filePath"
    else
        # 修改
        oldlineContext=$(echo "${oldlineContext}" |sed -e 's/\//\\\//g' )
        oldlineContext=$(echo "${oldlineContext}" |sed -e 's/\&/\\\&/g' )
        newlineContext=$(echo "${newlineContext}" |sed -e 's/\//\\\//g' )
        newlineContext=$(echo "${newlineContext}" |sed -e 's/\&/\\\&/g' )
        sed -i "s/.*${oldlineContext}.*/${newlineContext}/g" "$filePath"
    fi
}

function setHostName(){
    clear
    echo " 请按照提示输入主机名，此操作将重新设置主机名， 如果不想重新设置， 请直接回车:"
    read -p "Enter localhost hostname:" HOSTNAME
    HOSTNAME_LOCAL=`hostname`
    if [ "${HOSTNAME}" !=  "" ];
       then
       hostname ${HOSTNAME}
       if [ -x /usr/bin/hostnamectl ];then
            /usr/bin/hostnamectl --static set-hostname ${HOSTNAME}
            return 0
       else
            return 1
       fi
    else
       hostname ${HOSTNAME_LOCAL}
       if [ -x /usr/bin/hostnamectl ];then
            /usr/bin/hostnamectl --static set-hostname ${HOSTNAME_LOCAL}
            return 0
       else
            return 1
        fi
    fi
}


function set_sys(){
      SE_LINUX=`getenforce`
     if [ ${SE_LINUX} == "Enforcing" ]
        then
           setenforce 0
     	   sed -i "s/^SELINUX=.*$/SELINUX=disabled/g" /etc/selinux/config
     	   systemctl stop firewalld
     	   systemctl disable firewalld
     	   systemctl stop NetworkManager
     	   systemctl disable NetworkManager
        else
           systemctl stop firewalld
     	   systemctl disable firewalld
     	   systemctl stop NetworkManager
     	   systemctl disable NetworkManager
     fi
	 #change ssh_config
     sed -i "s/#UseDNS yes/UseDNS no/g" /etc/ssh/sshd_config
     systemctl restart sshd
	 sed -i "s#HISTSIZE=1000#HISTSIZE=10000#g" /etc/profile
     echo "HISTTIMEFORMAT=\"%Y-%m-%d %H:%M:%S \`whoami\` : \"" >>/etc/profile
     echo -ne "
* soft nofile 65536
* hard nofile 65536
">>/etc/security/limits.conf
	}

function set_repo(){
     if [ -d "/etc/yum.repos.d/useless" ]
        then
        mv /etc/yum.repos.d/CentOS*.repo /etc/yum.repos.d/useless 2>/dev/null
        mv /etc/yum.repos.d/epel*.repo /etc/yum.repos.d/useless 2>/dev/null
        else
        mkdir -p /etc/yum.repos.d/useless
        mv /etc/yum.repos.d/CentOS*.repo /etc/yum.repos.d/useless  2>/dev/null
        mv /etc/yum.repos.d/epel*.repo /etc/yum.repos.d/useless  2>/dev/null
     fi

     cat <<EOF >> /etc/yum.repos.d/local.repo
[localpackages]
name=local packages
baseurl=file:///opt/repo/latest/
enabled=1
gpgcheck=0
EOF

     yum install -y lighttpd
     sed -i "s#80#82#g" /etc/lighttpd/lighttpd.conf >/dev/null
     sed -i 's#var.server_root =.*$#var.server_root =  \"/opt/repo\"#g' /etc/lighttpd/lighttpd.conf
     sed -i 's#server.document-root.*$#server.document-root = server_root#g'  /etc/lighttpd/lighttpd.conf
     sed -i "s#disable#enable#g" /etc/lighttpd/conf.d/dirlisting.conf >/dev/null
     systemctl enable lighttpd
     systemctl restart lighttpd
	}

function set_ansible ()
 { 
  
   yum install ansible python-pip -y

  cp -r ${PKG_SOURCE}  ${PKG_DES} 
 
}
 

set_sys
setHostName
set_repo
set_ansible
