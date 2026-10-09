# Role Name

This role helps to register linux host to windows active directory

---
# Role: join_linux_to_ad

This Ansible role joins a Linux machine to a Windows Active Directory domain using realmd and SSSD.

## Variables
- `ad_domain`: FQDN of the AD domain.
- `ad_user`: Username to join the domain.
- `ad_password`: Password for AD user (use Ansible Vault).
- `computer_ou`: Optional. Specify OU for the joined computer.

## Usage
```yaml
- hosts: all
  become: yes
  roles:
    - join_linux_to_ad
```

---

# Manual Deployment Instructions

## Prerequisites

### Set a proper hostname
```
sudo hostnamectl set-hostname server-desktop.lab.com
```

### Update /etc/hosts
```
echo "192.168.100.10 sqlmonitor.lab.com" | sudo tee -a /etc/hosts
```

### Ensure correct time sync (important for Kerberos)
```
sudo apt install chrony -y
sudo systemctl enable --now chrony
```

### Install required packages
```
sudo apt update
sudo apt install -y realmd sssd sssd-tools adcli samba-common-bin oddjob oddjob-mkhomedir packagekit libnss-sss libpam-sss
```

### Discover the Domain
```
realm discover lab.com


lab.com
  configured: no
  server-software: active-directory
  client-software: sssd
  ...
```

### Join the Domain
```
# It will prompt for AD account Administrator password
sudo realm join -v --user=administrator lab.com
sudo realm join -v --user=administrator sqlmonitor.lab.com
```

### Verify Join Status
```
realm list


lab.com
  type: kerberos
  realm-name: LAB.COM
  domain-name: lab.com
  configured: kerberos-member
  ...

```

### Login with Domain User
```
su - 'adwivedi@lab.com'
ssh 'adwivedi@lab.com'@localhost

# Configure automatic home directory creation
sudo pam-auth-update

```

###  (Optional) Allow Specific Domain Users or Groups
```
sudo realm permit 'adwivedi@lab.com'
# Or allow all users
sudo realm permit --all

```

### Troubleshooting Tips
```
# Check /var/log/sssd/ logs for SSSD errors

sudo systemctl restart sssd

# Check if Kerberos ticket works:
kinit 'adwivedi@LAB.COM'
klist
```


