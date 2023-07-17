k3s_bootstrap
=========

This role controls the entire lifecycle of a K3s cluster - installation to uninstallation.
Different areas of the lifecycle are accessed by the ``k3s_state`` variable, usually by passing ``-e "k3s_state=installed"`` (or other state types) when running the ansible-playbook command.

Available states are:
- downloaded
- installed
- restarted
- started
- stopped
- uninstalled
- validated

Requirements
------------
Only uses Ansible builtin modules.

Role Variables
--------------

defaults/main.yml
| **Variable** | **Required** | **Default** | **Choices/Type** | **Comments** |
|--------------|--------------|-------------|------------------|--------------|
| k3s_state | yes | installed | installed, started, stopped, restarted, uninstalled, validated | used to access different areas of the lifecycle controlled by the role |
| k3s_release_version | yes | v1.26.5+k3s1 | any valid k3s version number, or false | sets a specific k3s version to use, if set to "false" we will get the latest |
| k3s_config_file | yes | "/etc/rancher/k3s/config.yaml" | string | Location of the k3s configuration file |
| k3s_config_yaml_d_dir | yes | "/etc/rancher/k3s/config.yaml.d" | string | Location of the k3s configuration directory |
| k3s_containerd_config_file_dir | yes | "/var/lib/rancher/k3s/agent/etc/containerd" | string | Location of the k3s containerd configuration file |
| k3s_build_cluster | yes | true | true, false | When multiple ansible_play_hosts are present, attempt to cluster the nodes. Using false will create multiple standalone nodes. |
| k3s_github_url | yes | https://github.com/k3s-io/k3s | string | URL for k3s github repo |
| k3s_skip_validation | yes | false | true, false | Skip all tasks that validate configuration |
| k3s_skip_env_checks | yes | false | true, false | Skip all tasks that check environment configuration |
| k3s_install_dir | yes | /usr/local/bin | string | Installation directory for k3s |
| k3s_install_hard_links | yes | false | true, false | Install using hard links rather than symbolic links |
| k3s_server_config_yaml_d_files | no | [] | list of paths | A list of templates used for configuring the server. |
| k3s_agent_config_yaml_d_files | no | [] | list of paths | A list of templates used for configuring the agent. |
| k3s_server_manifests_templates | no | [] | list of paths | A list of templates used for pre-configuring the cluster. |
| k3s_server_manifests_urls | no | [] | list of dicts with keys "url" and "filename" | A list of URLs used for pre-configuring the cluster. |
| k3s_server_pod_manifests_templates | no | [] | list of paths | A list of templates used for installing static pod manifests on the control plane. |
| k3s_server_pod_manifests_urls | no | [] | list of dicts with keys "url" and "filename" | A list of URLs used for installing static pod manifests on the control plane. |
| k3s_use_experimental | yes | false | true, false | Use experimental features in k3s? |
| k3s_use_unsupported_config | yes | false | true, false | Allow for unsupported configurations in k3s? Must be set to 'true' when there are less than 3 control nodes | 
| k3s_etcd_datastore | yes | true | true, false | Enable etcd embedded datastore |
| k3s_start_on_boot | yes | true | true, false | Start k3s on system boot |
| k3s_service_requires | no | [] | list | List of required systemd units to k3s service unit. |
| k3s_service_wants | no | [] | list | List of "wanted" systemd unit to k3s (weaker than "requires"). |
| k3s_service_before | no | [] | list |  Start k3s before a defined list of systemd units. |
| k3s_service_after | no | [] | list | Start k3s after a defined list of systemd units. |
| k3s_server | no | {} | dict of dicts | Server configurations |
| k3s_agent | no | {} | dict of dicts | Agent configurations | 
| k3s_become_for_all | yes | true | true, false | Use become privileges for all |
| k3s_become_for_systemd | no | null | true, false | Use become privileges for systemd |
| k3s_become_for_install_dir | no | null | true, false | Use become privileges for install dir |
| k3s_become_for_directory_creation | no | null | true, false | Use become privileges for directory creation |
| k3s_become_for_usr_local_bin | no | null | true, false | Use become privileges for tasks involving /usr/local/bin |
| k3s_become_for_package_install | no | null | true, false | Use become privileges for package installation |
| k3s_become_for_kubectl | no | null | true, false | Use become privileges for kubectl |
| k3s_become_for_uninstall | no | null | true, false | Use become privileges for uninstallation tasks |
| k3s_registries | no | {} | dict of dicts | Private registry configuration. See https://rancher.com/docs/k3s/latest/en/installation/private-registry/ |
| k3s_remove_data | yes | false | true, false | Set to 'true' to remove all K3s data when k3s_state="uninstalled" |
| helm_version | yes | '3.9.2' | string | Helm version number |
| helm_architecture | yes | 'amd64' | string | The CPU architecture of the Helm executable to install |
| helm_mirror | yes | 'https://get.helm.sh' | string | Mirror to download Helm from |
| helm_install_dir | yes | '/usr/local/share/helm' | string | Dir where Helm should be installed |
| helm_download_dir | yes | "{{ x_ansible_download_dir | default(ansible_env.HOME + '/.ansible/tmp/downloads') }}" | string | Directory to store files downloaded for Helm |
| proxy_env | yes | http_proxy: '', https_proxy: '' | dict | dict containing proxy environment variables, if needed, to download binaries |

vars/main.yml
| **Variable** | **Required** | **Default** | **Choices/Type** | **Comments** |
|--------------|--------------|-------------|------------------|--------------|
| k3s_min_version | yes | 1.19.3 | string | Minimum supported version of K3s |
| k3s_ansible_min_version | yes | 2.9.16 | string | Minimum supported version of ansible |
| k3s_valid_states | yes | installed, started, stopped, restarted, downloaded, uninstalled, validated | list of strings | Valid states for this role |
| k3s_arch_lookup | yes | see vars/main.yml | dict of dicts | Map ansible fact gathering architecture to a release name and suffix in github. |
| k3s_release_channel | yes | stable | string | Always default to stable channel, this will change with k3s_release_version |
| k3s_api_releases | yes | https://update.k3s.io/v1-release/channels | string | K3s updates API |
| k3s_github_download_url | yes | "{{ k3s_github_url }}/releases/download" | string | Download location for releases |
| k3s_runtime_config | yes | "{{ (k3s_server \| default({})) \| combine (k3s_agent \| default({})) }}" | string | Generate a runtime config dictionary for validation |
| k3s_controller_list | yes | [] | please leave empty | Empty array for counting the number of control plane nodes |
| k3s_control_plane_port | yes | 6443 | int | Control plane port default |
| k3s_systemd_context | yes | system | string | Default to the "system" systemd context, this will be "user" when running rootless |
| k3s_systemd_unit_dir | yes | "/etc/systemd/{{ k3s_systemd_context }}" | string | Directory for systemd unit files to be installed. As this role doesn't use package management, this should live in /etc/systemd, not /lib/systemd |
| k3s_data_dir | yes | "{{ k3s_runtime_config['data-dir'] \| default('/var/lib/rancher/k3s') }}" | string | Data directory location for k3s | 
| k3s_config_dir | yes | "{{ k3s_config_file \| dirname }}" | string | Config directory location for k3s |
| k3s_audit_dir | no | null | string | Directory for k8s audit config files to be installed |
| k3s_token_location | yes | "{{ k3s_config_dir }}/cluster-token" | string | Directory for gathering the k3s token for clustering. |
| k3s_server_manifests_dir | yes | "{{ k3s_data_dir }}/server/manifests" | string | Path for additional Kubernetes Manifests, see https://rancher.com/docs/k3s/latest/en/advanced/#auto-deploying-manifests | 
| k3s_server_pod_manifests_dir | yes | "{{ k3s_data_dir }}/agent/pod-manifests" | string | Path for static pod manifests that are deployed on the control plane, see https://github.com/k3s-io/k3s/pull/1691 |
| k3s_check_packages | yes | [] | list of dicts | Packages that we need to check are installed |
| k3s_ensure_directories_exist | yes | see vars/main.yml | list of dicts with keys "name" and "path" | Directories that we need to ensure exist |
| k3s_config_exclude | yes | see vars/main.yml | list of dicts with keys "setting" and "correction" | Config items that should not appear in k3s_server or k3s_agent |
| k3s_config_version_check | yes | see vars/main.yml | list of dicts with keys "setting" and "version" | Config items and the versions that they were introduced |
| k3s_experimental_config | yes | see vars/main.yml | list of dicts with keys "setting" and optional "until" | Config items that should be marked as experimental |
| k3s_deprecated_config | yes | see vars/main.yml | list of dicts with keys "setting", "correction", and optional "when" | Config items that should be marked as deprecated |
| k3s_cgroup_subsys | yes | see vars/main.yml | list of dicts with keys "name" and "documentation" | CPU groups and sets config |
| k3s_server | yes | see vars/main.yml | list of dicts | K3s server launch arguments and configuration. Default setting doesn't deploy flannel and sets the cluster pod CIDR | 
| k3s_server_manifests_templates | yes | "manifests/calico/tigera-operator.yaml", "manifests/calico/custom-resources.yaml" | list of strings | Deploy the following k3s server templates. Paths should be relative to the folder where the playbook is being run. |
| k3s_server_environment | yes | KUBECONFING='/etc/rancher/k3s/k3s.yaml' | list of dicts with keys "key" and "value" | Environment values to set on the K3s server |
| k3s_cleanup_paths | yes | see vars/main.yml | list of strings | List of paths that should be removed when k3s_state="uninstalled" |
| helm_os | yes | 'linux' | string |  The OS of the Helm redistributable |
| helm_redis_filename | yes | 'helm-v{{ helm_version }}-{{ helm_os }}-{{ helm_architecture }}.tar.gz' | string | File name of the Helm redistributable file |

hostvars
| **Variable** | **Required** | **Default** | **Choices/Type** | **Comments** |
|--------------|--------------|-------------|------------------|--------------|
| ansible_user | yes | | string | The user on the remote to run the ansible as |
| ansible_host | yes | | string | IP of the remote |
|k3s_control_node|yes| | true, false | should be set to true for all hosts that will be k3s control nodes |
|k3s_lead_control_node|yes| false | true, false | should be set to true for ONLY ONE k3s control node host |
| k3s_etcd_datastore | yes | | true, false | Set to true when the host will run the embedded etcd datastore. Ideally set to true for all hosts that will be control nodes |
| k3s_agent.node-ip | yes | | string | IP of the remote |
| gpu_node | no | | true, false | set to true in hostvars when a host has a GPU installed and will act as a GPU node in the cluster |

groupvars
| **Variable** | **Required** | **Default** | **Choices/Type** | **Comments** |
|--------------|--------------|-------------|------------------|--------------|
| k3s_env | yes | '' | string | used for the k3s api name reference, can be anything that describes the type of the cluster |
| k3s_vip | yes | | IP address | unassigned IP address to be used as the HA loadbalanced address |
| k3s_vip_port | yes | | integer | port to use for the HA loadbalancer, e.g. 8443 |
| k3s_encryption_secret | yes | | b64 encoded 16, 24, 32 char string | Encryption string for CIS compliant encryption of data in the K3s etcd datastore. Do not put this in the inventory file in plain text, this is a sensitive secret. |


Dependencies
------------
No dependencies on other roles.

k3s_preflight and k3s_ha need to be run before running this with k3s_state="installed".

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```YAML
---
# site.yml
- name: K3s bootstrap
  become: yes
  gather_facts: True
  hosts: k3s_cluster
  max_fail_percentage: 0
  roles:
    - role: k3s_bootstrap
```

```YAML
# inventory.yml
# inventory file for a cluster
k3s_cluster:
  vars:
    # ha variables
    k3s_env: 'application'
    k3s_vip: 172.21.136.5
    k3s_vip_port: 8443
    # K3s and Helm versions
    k3s_release_version: 'v1.26.5+k3s1'
    helm_version: '3.9.2'
    # List of manifests to auto-deploy to this cluster on K3s install
    k3s_server_manifests_templates:
      - "manifests/calico/tigera-operator.yaml"
      - "manifests/calico/custom-resources.yaml"
      - "manifests/nvidia/runtimeclass.yaml"
      - "manifests/opagatekeeper/gatekeeper.yaml"

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
