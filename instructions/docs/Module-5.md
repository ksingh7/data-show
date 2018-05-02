# Module - 5 : Ceph File Storage Provisioning

!!! Summary "Module Agenda"
    - **In this module, you will learn how to configure Ceph Metadata Server (MDS)**
    - **You will then use CephFS to provision, mount and use a shared filesystem based on Ceph**
    - **By the end of this module, you will have an understanding of Ceph Filesystem.**


- From your workstation, login to the ``ceph-admin`` node as user **``student``** [(Learn how to Login)](https://red-hat-storage.github.io/RHCS_Test_Drive/#starting-the-lab)

```
ssh student@<IP Address of ceph-admin node>
```

!!! example "Prerequisite"
    - **This module is independent of the other modules. If you intend to follow this module, please make sure that you have a running Ceph cluster before you begin.**
    - **You could setup a Ceph cluster using either of these two methods
    1) Follow the hands-on instructions in Module-2 and deploy the Ceph cluster
    2) From ``ceph-admin`` node, execute the following script to setup a Ceph cluster  
       ``sh /home/student/auto-pilot/setup_ceph_cluster.sh ``**
    - **Once you have a running Ceph cluster you will be ready to continue with this module.**
    - **You must run all the commands using user ``student`` on the ``ceph-admin`` node, unless otherwise specified.**

## Introduction

The Ceph File System (CephFS) is a file system compatible with POSIX standards that provides file access to a Ceph Storage Cluster. CephFS requires at least one Metadata Server (MDS) daemon. The MDS daemon manages metadata related to files stored on the Ceph File System and also coordinates access to the shared Ceph Storage Cluster.

## Deploying Ceph Metadata Server (MDS)

- In most cases, the default settings for MDS in ``ceph-ansible`` are appropriate. To setup MDS, we just need to update the Ansible inventory file with MDS host detail

- Edit Ansible inventory file ``/etc/ansible/hosts`` 

```
sudo vim /etc/ansible/hosts
```

- Add the following section, save and exit from file editor

```
[mdss]
ceph-admin
```

- Switch directory to the ``ceph-ansible`` root

```
cd /usr/share/ceph-ansible
```


- Run the ``ceph-ansible`` playbook and limit it to ``mdss`` 

```
time ansible-playbook site.yml --limit mdss
```

- Give user ``student `` access to the Ceph CLI 

```
sudo chown -R student:student /etc/ceph
```

!!! tip
     Ansible is idempotent. If it is run multiple times, it has the same effect as running it once. Therefore, there is no harm in running it again. Configuration changes will not take place after its initial application.

- Once your Ansible playbook run has finished, ensure there are no failed items under ``PLAY RECAP`` 

## Setting up Ceph Filesystem

- Create a CephFS data pool

```
ceph osd pool create cephfs-data 64
```

- Create a CephFS meta data pool

```
ceph osd pool create cephfs-metadata 64
```

- Create Ceph Filesystem

```
ceph fs new cephfs cephfs-metadata cephfs-data
```

- Enable the cephfs application for Ceph data and metadata pools

```
ceph osd pool application enable cephfs-data cephfs ; ceph osd pool application enable cephfs-metadata cephfs ; 
```


- Check the Ceph Filesystem status

```
ceph fs status cephfs
```

- Create a CephFS client user named ``client.cephfs`` with necessary permissions on Ceph MON, MDS and OSD

```
ceph auth get-or-create client.cephfs mon 'allow r' mds 'allow rw' osd 'allow rwx pool=cephfs-metadata,allow rwx pool=cephfs-data'
```

## Accessing Ceph Filesystem

- To access CephFS, you will need to extract and place a CephFS secret key on to the client node

```
ceph auth get client.cephfs | grep -i key | cut -d ' ' -f 3 > /tmp/ceph.client.cephfs.secret
```

- Copy the CephFS secret file to ``client-node1`` 

```
scp /tmp/ceph.client.cephfs.secret client-node1: ;
```

- Connect to ``client-node1`` in order to mount the Ceph Filesystem

```
ssh client-node1
```

- Switch to ``root`` user

```
sudo su -
```

- Create a mount point 

```
mkdir /mnt/cephfs
```

- Then, mount the Ceph Filesystem using the ``mount`` command and add an option, ``-o``, providing your CephFS secret file

```
mount -t ceph 10.100.0.11:6789,10.100.0.12:6789,10.100.0.13:6789:/ /mnt/cephfs/ -o name=cephfs,secretfile=/home/student/ceph.client.cephfs.secret
```

- Verify that the Ceph Filesystem is mounted

```
df -h /mnt/cephfs
```

- Next, let's copy a medium-sized file to the Ceph Filesystem

```
cp /home/student/rhceph-3.0-rhel-7-x86_64.iso /mnt/cephfs/
```

- Verify the copied files

```
ls -l /mnt/cephfs ; df -h /mnt/cephfs
```

You can also mount the same Ceph Filesystem on other nodes in the cluster. As an example, let's mount cephfs to the ``ceph-admin`` node as well

- Login to ``ceph-admin`` node , switch to root user ``sudo su - `` and create mount point for cephfs

```
ssh ceph-admin
```

```
sudo su -
```

```
mkdir /mnt/cephfs
```

- Again, mount the Ceph Filesystem as you did in the previous example, using the ``mount`` command and adding an option, ``-o``, to provide your CephFS secret file

```
mount -t ceph 10.100.0.11:6789,10.100.0.12:6789,10.100.0.13:6789:/ /mnt/cephfs/ -o name=cephfs,secretfile=/tmp/ceph.client.cephfs.secret
```

- Verify the contents of Ceph Filesystem. As expected, the contents will be same as we saw on ``client-node1``

```
ls -l  /mnt/cephfs
```

!!! summary "End of Module" 
    **We have reached the end of Module-5. In this module, you have learned how to install, configure and use Ceph as a distributed shared filesystem. In the next module, you will learn Ceph Administration.**
