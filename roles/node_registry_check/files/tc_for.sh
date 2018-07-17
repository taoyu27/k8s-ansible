source /tmp/tc_registry_ip.txt
Num=${#registry_ip[@]}
echo "----------start-------------" >> /tmp/tc_telnet_result.txt
for ((a=0;a<$Num;a++))
do
  /tmp/tc_node_registry_check.sh ${registry_port[`echo $a`]} ${registry_ip[`echo $a`]} >> /tmp/tc_telnet_result.txt
  printf "\n" >> /tmp/tc_telnet_result.txt
done
echo "----------end-------------" >> /tmp/tc_telnet_result.txt
cat /tmp/tc_telnet_result.txt
rm -rf /tmp/tc_*
