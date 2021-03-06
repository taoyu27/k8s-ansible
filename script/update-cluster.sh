#!/bin/bash

# Copyright 2015 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

function print_start_deploy_product(){
    local product_name=$1
    echo ""
    echo "########################################"
    echo "# 开始更新 ${product_name}"
    echo "########################################"
    echo ""
}


. ./init.sh


print_start_deploy_product "基础环境"
bash ./deploy-base.sh
sleep 15

print_start_deploy_product "etcd_cluster"
bash ./deploy-etcd.sh
sleep 15

print_start_deploy_product "k8s_基础包"
bash ./deploy-kubernetes.sh
sleep 15

print_start_deploy_product "k8s_master环境"
bash ./deploy-master.sh
sleep 15

print_start_deploy_product "k8s_minion_node环境"
bash ./deploy-mininos.sh
sleep 15

print_start_deploy_product "k8s_addons"
bash ./deploy-k8s-addons.sh
sleep 15

echo "##################################################"
echo "# 更新环境完成，请等待10分钟后检查个服务的运行情况"
echo "##################################################"
