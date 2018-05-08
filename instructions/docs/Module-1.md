# Module - 1 : Ceph cluster & Object Storage Setup

!!! Summary "Module Agenda"
    - **In this module you will be deploying Red Hat Ceph Storage 3 cluster across 3 nodes using Ansible based deployer called ``ceph-ansible``.**
    - **You will also learn how to configure object storage for S3 API by setting up Ceph Rados Gateway (RGW)**

- From your workstation SSH into ``ceph-node1`` with the user name **``student``** and password **``Redhat18``** [(Need Help..Learn how to Login)](https://ksingh7.github.io/data-show/#accessing-the-lab)

```
ssh student@<IP Address of ceph-node1>
```  

!!! example "Prerequisite"
    - You must run all the commands logged in as user **student** on the **ceph-node1** node, unless otherwise specified. 

## Fast Forward Deployment

In order to save your precious lab time, this section deploys and configures the Ceph Cluster as well as Ceph S3 Object storage in a highly automated way using a all-in-one shell script. 

!!! important
    - **If you are using Fast Forward method of deployment, you could skip the next sections labeled as "Manual Deployment"**

- To start ``Fast Forward Deployer`` run the following command

```
sh /home/student/auto-pilot/setup_ceph_cluster_with_rgw.sh
```

- The ``Fast Forward Deployer`` should take under 10-12 minutes to complete. Once its done, check the status of your Ceph cluster.

```
sudo ceph -s
```

```
[student@ceph-node1 ceph-ansible]$ sudo ceph -s
  cluster:
    id:     908c17fc-1da0-4569-a25a-f1a23f2e101e
    health: HEALTH_OK

  services:
    mon: 3 daemons, quorum ceph-node1,ceph-node2,ceph-node3
    mgr: ceph-node1(active)
    osd: 12 osds: 12 up, 12 in

  data:
    pools:   0 pools, 0 pgs
    objects: 0 objects, 0 bytes
    usage:   1290 MB used, 5935 GB / 5937 GB avail
    pgs:

[student@ceph-node1 ceph-ansible]$
```


## Manual Deployment : Setting up environment for ceph-ansible  

!!! important
    - **If you have choose to follow the above ``Fast Forward Deployment`` method, you should skip the below ``Manual Deployment`` process.**

- Begin by creating a directory for ceph-ansible keys under ``student`` user's home directory.

```
mkdir ~/ceph-ansible-keys
```

- Create a new ansible inventory file which helps ``ceph-ansible`` to know what role needs to be applied on each node.

```
sudo vi /etc/ansible/hosts
```

- In the ``/etc/ansible/hosts`` inventory file add the following

```
[mons]
ceph-node[1:3]

[osds]
ceph-node[1:3]

[mgrs]
ceph-node1

[clients]
ceph-node1

[rgws]
ceph-node1
```

!!! info
    - Since this is a lab environment we are collocating Ceph Mon and Ceph OSD daemons on `ceph-node*` nodes
    - Also ``ceph-node1`` node will host Ceph Client, Ceph Manager and Ceph RGW services

- Before we begin Ceph deployment, make sure that Ansible can reach to all the cluster nodes.

```
ansible all -m ping
```

## Manual Deployment : Configuring Ceph-Ansible Settings

- Visit ``ceph-ansible`` main configuration directory

```
cd /usr/share/ceph-ansible/group_vars/
```

- In the directory you will find ``all.yml`` , ``osds.yml`` and ``clients.yml`` configuration files which are **pre-populated for you** to avoid any typographic errors. Lets look at these configuration files one by one.

!!! tip
    You can skip editing configuration files as they are pre-populated with correct settings to avoid typos and save time.

- ``all.yml`` configuration file most importantly configures
    - Ceph repository, path to RHCS ISO
    - Ceph Monitor network interface ID, public network
    - Ceph OSD backend as ``filestore``
    - Ceph RGW port, threads and interface
    - Ceph configuration settings for pools

```
cat all.yml
```

```
---
dummy:
fetch_directory: ~/ceph-ansible-keys
ceph_repository_type: iso
ceph_origin: repository
ceph_repository: rhcs
ceph_rhcs_version: 3
ceph_rhcs_iso_path: "/home/student/rhceph-3.0-rhel-7-x86_64.iso"

monitor_interface: eth0
mon_use_fqdn: true
public_network: 10.0.1.0/24
osd_objectstore: filestore

radosgw_civetweb_port: 80
radosgw_civetweb_num_threads: 512
radosgw_civetweb_options: "num_threads={{ radosgw_civetweb_num_threads }}"
radosgw_interface: eth0
radosgw_dns_name: "ceph-node1"

ceph_conf_overrides:
  global:
    osd pool default pg num: 64
    osd pool default pgp num: 64
    mon allow pool delete: true
    mon clock drift allowed: 5
    rgw dns name: "ceph-node1"
```


- ``osds.yml`` configuration file most importantly configures
    - Ceph OSD deployment scenario to be collocated (ceph-data and ceph-journal on same device)
    - Auto discover storage device and use them as Ceph OSD
    - Allow Ceph OSD nodes to be ceph admin nodes (optional)

```
cat osds.yml
```

```
---
dummy:
copy_admin_key: true
osd_auto_discovery: true
osd_scenario: collocated
```

- ``clients.yml`` configuration file most importantly configures
    - Allow Ceph client nodes to issue ceph admin commands (optional, not recomended for production)

```
cat clients.yml
```

```
---
dummy:
copy_admin_key: True
```


## Manual Deployment of RHCS Cluster

- To start deploying RHCS cluster, switch to ``ceph-ansible`` root directory

```
cd /usr/share/ceph-ansible
```


- Run ``ceph-ansible`` playbook

```
time ansible-playbook site.yml
```

- This should usually take 10-12 minutes to complete. Once its done, play recap should look similar to below. Make sure play recap does not show any host run failed.

```
PLAY RECAP ******************************************************************
ceph-node1                 : ok=149  changed=29   unreachable=0    failed=0
ceph-node2                 : ok=136  changed=24   unreachable=0    failed=0
ceph-node3                 : ok=138  changed=25   unreachable=0    failed=0

real  10m9.966s
user  2m6.029s
sys 1m1.005s
```


- Finally check the status of your cluster. 

```
sudo ceph -s
```

```
[student@ceph-node1 ceph-ansible]$ sudo ceph -s
  cluster:
    id:     908c17fc-1da0-4569-a25a-f1a23f2e101e
    health: HEALTH_OK

  services:
    mon: 3 daemons, quorum ceph-node1,ceph-node2,ceph-node3
    mgr: ceph-node1(active)
    osd: 12 osds: 12 up, 12 in

  data:
    pools:   0 pools, 0 pgs
    objects: 0 objects, 0 bytes
    usage:   1290 MB used, 5935 GB / 5937 GB avail
    pgs:

[student@ceph-node1 ceph-ansible]$
```


!!! summary "End of Module"
    **We have reached to the end of Module-1. At this point you should have a healthy RHCS cluster up and running with 3 x Ceph Monitors, 3 x Ceph OSDs (12 x OSDs), 1 x Ceph Manager , 1 x Ceph RGW.**
