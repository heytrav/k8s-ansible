# Kubernetes Ansible

This repository contains ansible for setting up a very basic Kubernetes
cluster. By default it creates:

* 1 Master 
* 2 Nodes


#### Local setup
1. Create an ansible configuration file
   ```
   vim ~/.ansible.cfg
   ```

1. Add the following
   ```
   [defaults]
   inventory = /home/USER/.ansible/inventory
   vault_password_file = /home/USER/.ansible/vault_password
   ```
1. Add the vault password for this project into the `~/.ansible/vault_password` file. You will probably get this from the course instructor.
1. Set up a python virtualenv with Ansible. Currently the easiest way to do
   this is to clone the [Catalyst Cloud Ansible](https://github.com/catalyst/catalystcloud-ansible.git) repository. Once this has downloaded, go into the directory and run:
   ```
   $ cd
   $ git clone https://github.com/catalyst/catalystcloud-ansible.git
   $ cd catalystcloud-ansible
   $ ./install-ansible.sh
   ```
   This will require sudo privileges. Once it is complete you should have a
   functioning python virtualenv with all the dependencies needed to interact
   with the Catalyst Cloud Openstack API. Make sure to source python
   virtualenv
   ```
   source ~/catalystcloud-ansible/ansible-venv/bin/activate
   ```
   *Note:* Recent versions of Ansible (>2.5.5) have broken some OpenStack API
   commands. For this reason you might need to do the following:
   ```
   (ansible-venv) pip uninstall ansible
   (ansible-venv) pip install ansible==2.5.5
   ```
1. Import roles needed for ansible
   ```
   (ansible-venv) ansible-galaxy install -f -r requirements.yml
   ```
1. Run the local setup playbook
   ```
   (ansible-venv) ansible-playbook -i hosts -e prefix=<username> local-setup.yml
   ```
   This creates an inventory file for your cloud hosts as well as a couple
   configuration files that will be used by Ansible to access the OpenStack
   API.
   *Note:* _prefix_ needs to be something unique in order to avoid name
   collisions on the same tenant during training where there might be multiple
   people building instances on the same tenant. A username or hostname are
   usually adequate provided they are unique.


#### Building a cluster

Assuming all went well you should be able to build your Kubernetes cluster

```
(ansible-venv) ansible-playbook -K create-cluster-hosts.yml kubeadm-install.yml  -e prefix=$(hostname) 
```

This will do the following:

* Create cluster hosts
* Install python and docker (17.03) on each of them
* Install kubernetes libraries
* Initialise one host as the _master_
* Join 2 _node_ hosts to the kubernetes cluster



#### Tearing down the cluster

When you are done playing around, do not forget to tear down your cluster. 

```
(ansible-venv) ansible-playbook remove-cluster-hosts.yml -K -e prefix=$(hostname)
```


   
