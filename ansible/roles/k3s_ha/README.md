k3s_ha
=========

This role configures a pacemaker cluster using chrony to provide HA and a load-balancer IP in front of the designed K3s control nodes. 

Requirements
------------

Only uses Ansible builtin modules.

Role Variables
--------------

defaults/main.yml
| **Variable** | **Required** | **Default** | **Choices/Type** | **Comments** |
|--------------|--------------|-------------|------------------|--------------|
|corosync_authkey_file|yes|'/etc/corosync/authkey'|string|path to put the corosync authkey file|
|corosync_bindnet_interface|yes|'vlan361'|string|defines the network interface used for the pacemaker cluster|
|corosync_config_file|yes|'/etc/corosync/corosync.conf'|string|path to the corosync config file|
|nginx_config_file|yes|'/etc/nginx/nginx.conf'|string|path to the nginx config file|

vars/main.yml
| **Variable** | **Required** | **Default** | **Choices/Type** | **Comments** |
|--------------|--------------|-------------|------------------|--------------|
|k3s_controller_list|yes|[]|list|please leave empty|
|k3s_lead_controller_list|yes|[]|list|please leave empty|

hostvars
| **Variable** | **Required** | **Default** | **Choices/Type** | **Comments** |
|--------------|--------------|-------------|------------------|--------------|
|k3s_control_node|yes| | true, false | should be set to true for all hosts that will be k3s control nodes |
|k3s_lead_control_node|yes| false | true, false | should be set to true for ONLY ONE k3s control node host |

groupvars
| **Variable** | **Required** | **Default** | **Choices/Type** | **Comments** |
|--------------|--------------|-------------|------------------|--------------|
| chrony_server_configs| yes | [] | list of strings | each string in the list defines a chrony server, e.g. 'server 192.168.10.10 iburst' |
| k3s_env | yes | '' | string | used for the k3s api name reference, can be anything that describes the type of the cluster |
| k3s_vip | yes | | IP address | unassigned IP address to be used as the HA loadbalanced address |
| k3s_vip_port | yes | | integer | port to use for the HA loadbalancer, e.g. 8443 |


Dependencies
------------
No dependencies on other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```YAML
---
# site.yml
- name: K3s HA
  become: yes
  gather_facts: True
  hosts: k3s_cluster
  max_fail_percentage: 0
  roles:
    - role: k3s_ha
```

```YAML
# inventory.yml
# inventory file for a cluster
k3s_cluster:
  vars:
    # ha variables
    chrony_server_configs:
      - 'server 192.168.10.10 iburst'
      - 'server 192.168.10.51 iburst'
      - 'server 192.168.69.54 iburst'
    k3s_env: 'application'
    k3s_vip: 172.21.136.5
    k3s_vip_port: 8443
    corosync_bindnet_interface: 'vlan361'

  hosts:
    k3s-app-ctrl1:
      ansible_user: root
      ansible_host: 172.21.136.1
      k3s_control_node: true
      k3s_lead_control_node: true
      k3s_etcd_datastore: true
      k3s_agent:
        node-ip: 172.21.136.1
      gpu_node: false
  
    k3s-worker-1:
      ansible_user: root
      ansible_host: 172.21.136.2
      k3s_control_node: false
      k3s_lead_control_node: false
      k3s_etcd_datastore: false
      k3s_agent:
        node-ip: 172.21.136.2
      gpu_node: true
```

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
