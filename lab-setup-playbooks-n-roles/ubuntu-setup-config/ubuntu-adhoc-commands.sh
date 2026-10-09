:<<'INITIAL_BASIC_SETUP'
-> Ensure ip address & hostname is set correctly on ubuntu managed host
-> Create ansible user with ansible password, and sudo access

INITIAL_BASIC_SETUP

# find a keyword in facts
ansible msi -m setup | grep msi

# get host name
ansible msi -m setup -a 'filter=ansible_fqdn'
ansible msi -m setup -a 'filter=ansible_os_family'



