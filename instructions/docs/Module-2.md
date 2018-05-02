# Module - 2 : Setting up OpenShift Container Platform

!!! Summary "Module Agenda"
    - **In this module you will be creating an OpenShift project required for the rest of the sessions**

- From your workstation login to the ``OpenShift Master Node`` with the user name **``cloud-user``** and ``SSH Private Key`` [(Learn how to Login)](https://ksingh7.github.io/data-show/#accessing-the-lab)

```
ssh -i <path to ssh_key.pem> cloud-user@<OpenShift Master Node IP Address>
```  

!!! example "Prerequisite"
    - You must run all the commands logged in as user **cloud-user** on the **OpenShift Master Node** node, unless otherwise specified. 

## Create an OpensShift Project

In order to save your precious lab time, OpenShift Container Platform has already been installed and configured. Before you begin with some data science exercises, lets' create a OpenShift project

- Login to OpenShift Master Node as ``cloud-user``

```
ssh -i <path to ssh_key.pem> cloud-user@<OpenShift Master Node IP Address>
```

- Login to OpenShift

```
oc login -u teamuser1 -p openshift
```

- Create a new project

```
oc new-project jupyterhub
```

- Pull the required container image

```
oc apply -f https://raw.githubusercontent.com/vpavlin/jupyterhub-ocp-oauth/ceph-summit-demo/notebooks.json
```

- Deploy JupyterHub application

```
oc apply -f https://raw.githubusercontent.com/vpavlin/jupyterhub-ocp-oauth/ceph-summit-demo/templates.json
```

- Process JupyterHub application

```
oc process jupyterhub-ocp-oauth HASH_AUTHENTICATOR_SECRET_KEY="meh" | oc apply -f -
```

- You should now have JupyterHub pods and services coming up ( will take some time to fully start)
```
oc get po,svcs
```

- You could also monitor your application from OpenShift Container Platform Console by visiting ``OpenShift Console URL``. The user name and password to access the console is ``teamuser1`` and ``openshift`` respectively.

!!! summary "End of Module"
    **We have reached to the end of Module-2. At this point you have learned how to deploy an application on OCP. In the later modules we will use this application to perform some interesting data analytics work**
