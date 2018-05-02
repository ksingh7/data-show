# Getting Started

!!! example "Lab Tips" 
    - **To start the Test Drive press the ``START`` button from the Lab Home Screen**
    - **Once your lab environment is provisioned, gather the login information from the ``Connection Details`` section**
    - **Your SSH Login Credentials are : User Name: ``student`` Password: ``Redhat18``**
    - **To open this lab guide in a separate browser window use [This Link](https://red-hat-storage.github.io/RHCS_Test_Drive).**
    - **Completing the entire lab content will typically take between 2:30 to 3:00 hours (your mileage may vary)**
    - **Generously use copy-to-clipboard button next to each command.**
    - **Please send your feedback/suggestions or bug reports to karan@redhat.com**
    - **This is a temporary environment for training and learning purposes. Do not host production or test workloads.**

## Introduction
Welcome to the Red Hat Ceph Storage Test Drive. 

For a smooth learning experience, the contents of this test drive have been divided into the following modules. Each of these modules are independent of each other. You can continue the lab in sequence, or, if you would rather pick and choose which modules to work on, and in which ever order you desire, simply fulfill the prerequisite build which is included with each module. 

- [**Module 1 :** Introduction to Red Hat Ceph Storage](https://red-hat-storage.github.io/RHCS_Test_Drive/Module-1/)
- [**Module 2 :** Deploying Red Hat Ceph Storage](https://red-hat-storage.github.io/RHCS_Test_Drive/Module-2/)
- [**Module 3 :** Ceph Block Storage Provisioning](https://red-hat-storage.github.io/RHCS_Test_Drive/Module-3/)
- [**Module 4 :** Ceph Object Storage Provisioning](https://red-hat-storage.github.io/RHCS_Test_Drive/Module-4/)
- [**Module 5 :** Ceph File Storage Provisioning](https://red-hat-storage.github.io/RHCS_Test_Drive/Module-5/)
- [**Module 6 :** Ceph Administration](https://red-hat-storage.github.io/RHCS_Test_Drive/Module-6/)
[]( - [**Module 7 :** Ceph Use Cases](https://red-hat-storage.github.io/RHCS_Test_Drive/Module-7/) )
[]( - [**Module 8 :** Red Hat Ceph Storage Additional Resources](https://red-hat-storage.github.io/RHCS_Test_Drive/Module-8/) )

## Test Drive Prerequisites

For this lab you need the following:

- Workstation with Internet access
- SSH client program installed on your workstation

## Starting the LAB

After you have logged into your Red Hat Test Drive Portal, select ``Red Hat Ceph Stoage 3`` Test Drive.

- To start the Test Drive press ``START`` button in the top bar.
- Generally it takes less than 10 minutes to provision your lab environment.
- In total, you can start the lab 5 times. After that, you will reach your quota of free labs. Contact us if you want to run more labs.

## Accessing the LAB

Once your lab environment is provisioned, you will find login details on the left hand pane in a section labeled ``Connection Details`` 

- ``SSH IP Address``
- ``SSH user name``
- ``SSH Password``

Having all these details, open your terminal or SSH program and run 

```
ssh student@<SSH IP Address>
```

## Terminating the LAB

- Your lab will auto terminate in 180 minutes, however, if you like, you can click the ``End Lab`` button to terminate the lab.
- Tell us about your lab experience and suggestions for improvements in the feedback box.

## Lab Environment Overview

- The lab environment has 6 nodes in total and you will be using ``ceph-admin`` node most of the time. 
- All the nodes have Internet access, however only the ``ceph-admin`` node will be reachable via public IP.

|  **Node Name**|       **Function**         |
|:-------------:|:--------------------------:|
|   ceph-admin  | Ceph (Ansible + Metrics + RGW + Client) |
|   ceph-node1  | Ceph (MON + Filestore OSD)                    |
|   ceph-node2  | Ceph (MON + Filestore OSD)                    |
|   ceph-node3  | Ceph (MON + Filestore OSD)                    |
|   ceph-node4  | Ceph (Bluestore OSD)                        |
|  client-node1  | Ceph Client                     |



## Red Hat Ceph Storage Prerequisites
Setting up Red Hat Ceph Storage (RHCS) requires configuration of the cluster nodes.

- **Operating System :**  Supported version of OS.
- **Registration to RHN :** To get OS/RHCS packages for installation.
- **Separate networks :** For Ceph Public and Cluster traffic.
- **Setting hostname resolutions :** Either local or DNS name resolution 
- **Configuring firewall :**  Allow necessary port to be opened.
- **NTP configuration:** For time synchronization across nodes.
- **Local user account:** User with password less sudo ssh access to all nodes.

!!! success "You are covered"
    The purpose of the Red Hat Ceph Storage Test Drive is to provide you with an environment where you can focus on learning this great technology, without spending time fulfilling prerequisites. All the prerequisites listed above have been taken care of for this course.
