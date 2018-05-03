# Module - 2 : Setting up JupyterHub in OpenShift Container Platform

!!! Summary "Module Agenda"
    - **In this module you will be creating an OpenShift project for JupyterHub required for the rest of the sessions**

- From your workstation login to the ``OpenShift Master Node`` with the user name **``cloud-user``** and ``SSH Private Key`` [(Learn how to Login)](https://ksingh7.github.io/data-show/#accessing-the-lab)

```
ssh -i <path to ssh_key.pem> cloud-user@<OpenShift Master Node IP Address>
```  

!!! example "Prerequisite"
    - You must run all the commands logged in as user **cloud-user** on the **OpenShift Master Node** node, unless otherwise specified. 

## Create an OpenShift Project

In order to save your precious lab time, OpenShift Container Platform has already been installed and configured. Before you begin with some data science exercises, let's create an OpenShift project.

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

- Prepare the OpenShift templates

```
oc apply -f https://raw.githubusercontent.com/vpavlin/jupyterhub-ocp-oauth/ceph-summit-demo/notebooks.json
oc apply -f https://raw.githubusercontent.com/vpavlin/jupyterhub-ocp-oauth/ceph-summit-demo/templates.json
```

- Process the template to deploy the JupyterHub application

```
oc process jupyterhub-ocp-oauth HASH_AUTHENTICATOR_SECRET_KEY="meh" | oc apply -f -
```

- You should now have JupyterHub pods and services coming up ( will take some time to fully start).  The deployment is complete when the jupyterhub-db and jupyter pods are fully running.
```
oc get po,svc
```

- You could also monitor your application from OpenShift Container Platform Console by visiting ``OpenShift Console URL``. The user name and password to access the console is ``teamuser1`` and ``openshift`` respectively.

- Verify you can access JupyterHub by visiting the URL.
```
oc get route jupyterhub -o jsonpath={.spec.host}
```

- Verify you can log into JupyterHub by using the user name and password ``user1`` and ``79e4e0`` respectively.

### Troubleshooting the JupyterHub deployment

Sometimes the JupyterHub deployment to OpenShift runs into race conditions.

- jupyterhub-db never comes up and constantly restarts.  This is often due to the PostgreSQL database not coming up cleanly.  If this occurs, the easiest thing to do is delete the JupyterHub project through the OpenShift Container Platform Console or via the command line.

```
oc delete project jupyterhub
```

- You receive a ``500 Internal Error``.  Do another deployment/rollout of JupyterHub which forces a restart of the server container and after connecting again to database.
```
oc rollout latest jupyterhub
```

!!! summary "End of Module"
    **We have reached to the end of Module-2. At this point you have learned how to deploy an application on OCP. In the later modules we will use this application to perform some interesting data analytics work**
