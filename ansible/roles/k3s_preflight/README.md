k3s_preflight
=========

This role installs a number of prerequisites before a K3s cluster can be configured and installed.
It also installs Helm, chrony, and all necessary GPU drivers for hosts identified as having GPUs.

Requirements
------------

No extra requirements, role only uses Ansible builtin modules.

Role Variables
--------------

defaults/main.yml

| **Variable** | **Required** | **Default** | **Choices/Type** | **Comments** |
|--------------|--------------|-------------|------------------|--------------|
|helm_version  | yes          | '3.9.2'     | string           | Valid full Helm release version number  |
|helm_architecture  | yes          | 'amd64'  | string         | The CPU architecture of the Helm executable to install |
|helm_mirror| yes | 'https://get.helm.sh' | string | Mirror to download Helm from |
|helm_install_dir | yes | '/usr/local/share/helm' | string | Dir where Helm should be installed |
|helm_download_dir | yes | "{{ x_ansible_download_dir | default(ansible_env.HOME + '/.ansible/tmp/downloads') }}" | string | Directory to store files downloaded for Helm |
|proxy_env | yes | http_proxy: '', https_proxy: '' | dict | dict containing proxy environment variables if needed to download Helm binaries |


vars/main.yml

| **Variable** | **Required** | **Default** | **Choices/Type** | **Comments** |
|--------------|--------------|-------------|------------------|--------------|
| helm_os | yes | 'linux' | string | The OS of the Helm redistributable |
| helm_redis_filename | yes | 'helm-v{{ helm_version }}-{{ helm_os }}-{{ helm_architecture }}.tar.gz' | string | File name of the Helm redistributable file |


hostvars
| **Variable** | **Required** | **Default** | **Choices/Type** | **Comments** |
|--------------|--------------|-------------|------------------|--------------|
| gpu_node | no | | true, false | set to true in hostvars when a host has a GPU installed and will act as a GPU node in the cluster |

Dependencies
------------
No dependencies on other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```YAML
---
# site.yml
- name: K3s preflight
  become: yes
  gather_facts: True
  hosts: k3s_cluster
  max_fail_percentage: 0
  roles:
    - role: k3s_preflight
```

```YAML
# inventory.yml
# inventory file for a cluster
k3s_cluster:
  vars:
    # set the proxy variables for when downloading files (e.g. helm, k3s) from github
    proxy_env: 
        http_proxy: 'http://proxy:9090'
        https_proxy: 'http://proxy:9090'

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
