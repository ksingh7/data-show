# Data Show

Playbooks to setup data show lab environment

# Setup

You'll need to have Ansible >= 2.4 installed on the machine you plan on
launching the lab from.

To setup the environment in EC2 you'll need to boot the environment:

```ansible-playbook -i hosts boot.yml```

You will need to export a few environmental variables that are specific to
your environment:

```
export AWS_ACCESS_KEY="Your AWS Access Key"
export AWS_SECRET_KEY="Your AWS Secret Key"
export MY_IP="Your IP Address"
export AWS_KEYNAME="Your AWS SSH Key Name"
```

You will also want to disable host key checking since the new instances will
have SSH fingerprints unknown to your local machine:

```export ANSIBLE_HOST_KEY_CHECKING=False```

You can check to see if the instances are ready by pinging them with ansible:

```ansible -i ec2.py -u ec2-user -m ping all```

You can ping either the spark or ceph groups of instances using a tag filter:

```
ansible -i ec2.py -u ec2-user -m ping tag_group_spark
ansible -i ec2.py -u ec2-user -m ping tag_group_ceph
```

Once the environment is running, it's time to configure it

```ansible-playbook -i ec2.py configure.yml```

The ceph-ansible playbooks depend on very specific group names, this won't work
out well with dynamic inventory groups that have a tag_ prefix. What we can do
instead is use the dynamic inventory script to dump to a file, then use a
script to convert it into a static inventory file to be used with ceph-ansible:

```
python ./ec2.py --refresh-cache > ec2-dynamic.json
dynamic2flat.py
sed -i '' 's/tag_//g' ec2-static.ini
sed -i '' 's/_yes//g' ec2-static.ini
sed -i '' 's/group_//g' ec2-static.ini
``` 

Then we can run playbooks a la:

```ansible-playbook -i ec2-static.ini ../ceph-ansible/site.yml```
