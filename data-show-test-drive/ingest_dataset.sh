#!/bin/bash
sudo yum install -y unzip
wget -O /home/student/auto-pilot/METRICS_DATASET.zip  https://s3.amazonaws.com/bd-dist/kubelet_docker_operations_latency_microseconds-20180427T150114Z-001.zip
unzip /home/student/auto-pilot/METRICS_DATASET.zip
cd /home/student/auto-pilot/kubelet_docker_operations_latency_microseconds
s3cmd mb s3://METRICS_DATASET
s3cmd sync /home/student/auto-pilot/kubelet_docker_operations_latency_microseconds/ s3://METRICS
