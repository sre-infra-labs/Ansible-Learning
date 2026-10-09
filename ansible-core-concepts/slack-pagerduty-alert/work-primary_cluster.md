# Run adhoc cluster commands

## Run adhoc ansible command
```
ansible all -i hosts.yml -m debug -a 'msg="hello there"'
```

## Run playbook
```
ansible-playbook -i hosts.yml playbook-generate-random-password.yml --vault-password-file=vault-password

```