# Data Show

Playbooks to setup data show lab environment

# Setup

You'll need to have Ansible >= 2.4 installed on the machine you plan on launching the lab from.

To setup the environment in EC2 you'll need to boot the environment

```ansible-playbook -i hosts boot.yml```

Once the environment is running, it's time to configure it

```ansible-playbook -i ec2.py configure.yml```
