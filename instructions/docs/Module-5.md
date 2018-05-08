# Module - 5 : ML using Jupyter Notebooks on Ceph

!!! Summary "Module Agenda"
    - **In this module, you will be creating a model using data stored in Ceph to detect the sentiment of customer trip reports, and uploading the trained model back to Ceph**

!!! example "Prerequisite"
    - **You need to have completed Modules 1-3 before beginning this module**

- The instructions for this excercise are available as Juypter Notebook (``.ipynb``) that you can download from [here](https://raw.githubusercontent.com/ksingh7/data-show/master/data-show-test-drive/Ceph_Data_Show_Lab_2.ipynb) (Right click >> Save Link As ``ipynb``)

- An active JupyterHub instance is required to open this notebook. Use the JupyterHub application that you have deployed in module-2. 
- Login to the ``OpenShift Container Platform Console`` and click on the JupyterHub application endpoint URL from the Overview screen. 

![](images/data-show-images/ocp-jupyterhub-app-url.png)

- Use the following credentials to login into the JupyterHub application
User Name : ``user1``
Password  : ``79e4e0``  

![](images/data-show-images/jupyter-login.png)

!!! Important "Important"
    **If JupyterHub did not deploy cleanly, refer to the troubleshooting steps in Module 2 to redeploy.**

- Click the ``Upload`` button to the right 

![](images/upload1.png) 

- Find the ``Ceph_Data_Show_Lab_2.ipynb`` downloaded at the start of this module and upload it to JupyterHub

- Click on the ``Upload`` button to finish uploading the notebook to JupyterHub ![](images/upload2.png) 

- Select the ``Ceph_Data_Show_Lab_2.ipynb`` notebook to begin building a model for machine learning

- Review the section ``Access Ceph Objbect Storage over S3A``, the configuration here should look like this

![](images/data-show-images/s3a-connection.png)

- Before running any of the cells in the notebook, select the first cell (the beginning of the notebook). Once the first cell is selected, click the ``Run`` button in the toolbar on each cell, stepping through the notebook and its results 

![](images/run.png)


!!! summary "End of Module"
    **We have reached the end of Module-5. In this module, you created a machine learning model using data stored in Ceph and uploaded the model to Ceph for future use.**
