#!/usr/bin/env python
'''
Grabbed from: https://gist.github.com/zkendall/5c58ac81a9f152de2b851360df6539cb

This script converts the output of Ansible's dynamic ec2.py to a flatly formmated static inventory file.
Before running this script run `python ./ec2.py --refresh-cache > ec2-dynamic.json`

See: http://docs.ansible.com/ansible/ec2_module.html

'''

import json
from pprint import pprint
import operator

# Variables to collect
HOST_VAR_NAMES = ['ec2_private_ip_address', 'ec2_private_dns_name']
HOST_VAR_SORTER = 'ec2_private_ip_address'

# Read in ouput from ec2.py
with open('ec2-dynamic.json') as data_file:
    dynamic_inv = json.load(data_file)

# Collect hostvars we care about
hosts_and_vars = {}
for host, values in dynamic_inv['_meta']['hostvars'].items():
    vars_set = {}
    for key, host_vars in values.items():
        if key in HOST_VAR_NAMES:
            vars_set[key] = host_vars
    hosts_and_vars[host] = vars_set

# Sort host definitions by `HOST_VAR_SORTER`
hosts_and_vars = sorted(hosts_and_vars.items(), key=lambda item: item[1][HOST_VAR_SORTER])

# Collect groups we care about -- currently only `tag_...`. TODO: Add support for matching multiple.
groups_by_tag = dict( (group_name, hosts) for group_name, hosts in dynamic_inv.items() if group_name.startswith('tag_'))

# Write out static hosts file
with open ('ec2-static.ini', 'w') as file_out:

    # Define hosts and vars first
    host_props = []
    for host, var_set in hosts_and_vars:
        properties = ['%s=%s' % (key, value) for (key, value) in var_set.items()]
        host_props.append((host, properties))

    # Get max column lengths
    template_widths = {}
    for host, properties in host_props:
        for idx, string in enumerate(properties):
            l = len(string)
            template_widths[idx] = l if l > template_widths.get(idx, 0) else template_widths[idx]

    # Build string template for padded formatting. Pad columns with extra 2 spaces beyond widest column value.
    template = ' '.join([ '{' + str(column) + ':<' + str(int(size) - 1 + 2) + '}' for column, size in template_widths.items() ])

    # Write host and hostvars
    for host, props in host_props:
        vars_string = template.format(*props)
        file_out.writelines('{0:<16} {1}'.format(host, vars_string) + '\n')

    # Write groups and hosts
    for group, hosts in groups_by_tag.items():
        group_name_result = '\n[' + group + ']\n'
        file_out.writelines(group_name_result)

        # Populate group
        file_out.writelines([host + '\n' for host in hosts])
