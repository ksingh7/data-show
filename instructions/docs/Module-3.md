# Module - 3 : Introduction to S3A & Loading Sample Data Set

!!! Summary "Module Agenda"
    - **In this module, you will be introduced to the S3A filesystem client**
    - **Locally download sample data sets of metrics data and sample trip reports.**
    - **Create a bucket and ingest the local data set to your Ceph object store**

- From your workstation, SSH into ``ceph-node1`` node as user **``student``** and password **``Redhat18``** [(Need Help..Learn how to Login)](https://ksingh7.github.io/data-show/#accessing-the-lab)

```
ssh student@<IP Address of ceph-node1 node>
```

!!! example "Prerequisite"
    - **You need to have completed Modules 1-2 before beginning this module**

## Introduction

The S3A filesystem client comes from Apache Hadoop and can be utilized by Spark and other tools to interact with a S3 compatible object storage system. S3A is the most feature complete and robust client for interacting with S3 compatible object storage systems, successor to the S3N and S3 filesystem clients. While S3A makes every attempt to map the HDFS API closely to the S3 API, there are some semantic differences inherrent to object storage (Reference: Hadoop Wiki):

* Eventual Consistency, with Amazon S3, or Multi-site Ceph. Creation, updates, deletes may not be visible for an undefined time.
* Non-atomic rename and delete operations. Renaming or deleting large directories takes time proportional to the number of entries and visible to other processes during this time, and indeed, until the eventual consistency has been resolved.

## Endpoints, Credentials, and SSL

The default endpoint for S3A routes requests to Amazon S3 with SSL (TLS). When interacting with a Ceph object store you will need to change a few S3A configuration parameters, notably the endpoint should be the DNS name or IP address of your Ceph object storage API endpoint.

- Endpoint (``fs.s3a.endpoint``)
- SSL (``fs.s3a.connection.ssl.enabled``)

!!! tip
     If HTTP(S) is included in the endpoint definition, then the SSL property is automatically adjusted as appropriate. We will use this convention in the later module when we update the Jupyter Notebook.

## Loading the sample data sets into Ceph object storage

To load the data sets into your Ceph object store we will use S3cmd, a python CLI tool for interacting with S3 compatible object stores. For convenience S3cmd was pre-installed on ``ceph-node1``.

- If you have not already done, SSH into ``ceph-node1`` as **student** user and **``Redhat18``** password.

- Locally download the sample data sets on ``ceph-node``.

```
wget -O /home/student/kubelet_docker_operations_latency_microseconds.zip https://s3.amazonaws.com/bd-dist/kubelet_docker_operations_latency_microseconds.zip
```

```
wget -O /home/student/trip_report.tsv https://s3.amazonaws.com/bd-dist/trip_report.tsv

```

- Unzip the sample metrics data set

```
unzip /home/student/kubelet_docker_operations_latency_microseconds.zip -d /home/student/METRICS
```

!!! tip
     The S3 API provides two ways to route requests to a particular bucket. The first is to use a bucket domain name prefix, meaning the API request will be sent to whichever IP address the <bucket_name>.<endpoint> hostname resolves to. If a wildcard DNS subdomain is not configured for the S3 endpoint, or if the endpoint domain name is not configured in Ceph, then requests using this convention will fail. The second way of routing requests is to use path style access, meaning the API request will be sent to <endpoint>/<bucket_name>. We will create a bucket with all upper case letters, as this convention instructs the S3A client to use the latter, path style approach.

- Configure ``S3cmd``

```
s3cmd --access_key=S3user1 --secret_key=S3user1key --no-ssl --host=ceph-admin --host-bucket="%(bucket)s.ceph-admin" --dump-config > /home/student/.s3cfg
```

- Create bucket for loading the sample metrics data set into Ceph object store

```
s3cmd mb s3://METRICS
```

Next, we will use the ``sync`` S3cmd command to synchronize the local directory with the downloaded data set with the newly created bucket. This is roughly equivalent to using rsync between two filesystems.

- Sync local directory with METRICS bucket

```
s3cmd sync /home/student/METRICS/ s3://METRICS
```

- Verify that metrics dataset is safe and sound in Ceph Object Storage

```
s3cmd ls s3://METRICS/kubelet_docker_operations_latency_microseconds/
```

- Create bucket for loading the sample trip report data set into Ceph object store

```
s3cmd mb s3://SENTIMENT
```

- Copy local trip report file to SENTIMENT bucket

```
s3cmd put /home/student/trip_report.tsv s3://SENTIMENT/data/trip_report.tsv

```

- Verify that trip report dataset is safe and sound in Ceph Object Storage

```
s3cmd ls s3://SENTIMENT/data/
```

- Now we have our sample data sets ready to be used in Ceph object store.

!!! summary "End of Module"
    **We have reached the end of Module-3. In this module, you downloaded the sample data sets and uploaded them to your Ceph object store using S3cmd. In the next module you will do some basic analysis on these data sets**
