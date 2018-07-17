#!/usr/bin/python
 
import json
import commands
import re
 
def get_ansible_check_k8s():
    source = commands.getoutput("""kubectl get ds|grep nginx""")
    output= source.split(' ')
    tu = [item for item in filter(lambda x:x != '', output)]
    if len(tu) > 0:
       kubectl_get_dict =  {"NAME":tu[0],"DESIRED":tu[1],"CURRENT":tu[2],"READY":tu[3],"UP-TO-DATE":tu[4],"AVAILABLE":tu[5],"NODE-SELECTOR":tu[6],"AGE":tu[7]}
       return kubectl_get_dict
    else:
       return 0

    
def main():
    global module
    module = AnsibleModule(
        argument_spec = dict(
            get_facts=dict(default="yes", required=False),
        ),
        supports_check_mode = True,
    )
 
    ansible_facts_dict = {
        "changed" : False,
        "ansible_facts": {
            }
    }
 
    if module.params['get_facts'] == 'yes':
       ansible_get_result = get_ansible_check_k8s()
       ansible_facts_dict['ansible_facts'] = ansible_get_result
       a = ansible_facts_dict['ansible_facts']
       if a == 0:
          print "kubectl get resources failed  : No resources found. "
          return 100
       else:
          if a['DESIRED'] == a['READY'] and a['READY'] == a['AVAILABLE']:
             print "check pass"
             print json.dumps(ansible_facts_dict)
             return 0
          else:
             print "check error"
             print json.dumps(ansible_facts_dict)
             return 10


 
from ansible.module_utils.basic import *
from ansible.module_utils.facts import *
main()
