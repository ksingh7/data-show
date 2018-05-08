#!/bin/bash
mkdir ~/ceph-ansible-keys

sudo touch /etc/ansible/hosts
sudo ex -sc '1i|   ' -cx /etc/ansible/hosts

sudo sed -i '$a\[mons]' /etc/ansible/hosts
sudo sed -i '$a\ceph-node[1:3]' /etc/ansible/hosts
sudo sed -i '$a\    ' /etc/ansible/hosts

sudo sed -i '$a\[osds]' /etc/ansible/hosts
sudo sed -i '$a\ceph-node[1:3]' /etc/ansible/hosts
sudo sed -i '$a\    ' /etc/ansible/hosts

sudo sed -i '$a\[mgrs]' /etc/ansible/hosts
sudo sed -i '$a\ceph-node1' /etc/ansible/hosts
sudo sed -i '$a\    ' /etc/ansible/hosts

sudo sed -i '$a\    ' /etc/ansible/hosts
sudo sed -i '$a\[rgws]' /etc/ansible/hosts
sudo sed -i '$a\ceph-node1' /etc/ansible/hosts
sudo sed -i '$a\    ' /etc/ansible/hosts

cd /usr/share/ceph-ansible
time ansible-playbook site.yml

sudo chown -R student:student /etc/ceph
ceph osd erasure-code-profile set my_ec_profile k=2 m=1 ruleset-failure-domain=host
ceph osd pool create ecpool 128 128 erasure my_ec_profile
ceph osd pool application enable ecpool benchmarking

sudo chown -R student:student /etc/ceph

sudo systemctl status ceph-radosgw@rgw.ceph-node1.service
sudo netstat -plunt | grep -i rados

sudo radosgw-admin user create --uid='user1' --display-name='First User' --access-key='S3user1' --secret-key='S3user1key'
sudo radosgw-admin subuser create --uid='user1' --subuser='user1:swift' --secret-key='Swiftuser1key' --access=full

swift -A http://ceph-node1/auth/1.0  -U user1:swift -K 'Swiftuser1key' post container-1
swift -A http://ceph-node1/auth/1.0  -U user1:swift -K 'Swiftuser1key' list

#echo "address=/.ceph-node1/10.0.1.111" | sudo tee -a /etc/dnsmasq.conf
sudo systemctl restart dnsmasq ;

#sudo sed -i '/search/anameserver 127.0.0.1' /etc/resolv.conf

ping -c 2 anything-bucket-name.ceph-node1

s3cmd --access_key=S3user1 --secret_key=S3user1key --no-ssl --host=ceph-node1 --host-bucket="%(bucket)s.ceph-node1" --dump-config > /home/student/.s3cfg

printf "\n"
echo "******************* Ceph Installation and Configuration Commpleted **********************"
printf "\n"
printf "\n"

echo "****************************************************************************************"
echo "Ceph S3 Object Storage Endpoint Details"
echo "****************************************************************************************"
echo "Ceph Object Storage Endpoint : http://10.0.1.111"
echo "Ceph S3 Access Key : S3user1 "
echo "Ceph S3 Secret Key : S3user1key "
echo "****************************************************************************************"
