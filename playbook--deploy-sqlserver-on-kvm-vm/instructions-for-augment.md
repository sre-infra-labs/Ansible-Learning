# Objective
I have this kvm based vm named sqlbuntu.
Install sql server 2025 enterprise developer edition on this vm.

## Components to install

- engine and sqlagent
- sqlclient tools like sqlcmd, bcp, powershell.

- On Disk 1 (size 150 gb)
  - keep sql server related files on /var/opt/mssql on existing root fs. No extra partition work on this disk.
  - system databases on this disk in a directory under /var/opt/mssql/data/systemdbs
  - tempdb on this disk, but a separate directory under /var/opt/mssql/data/tempdb
  - normal user databases on this disk in a directory under /var/opt/mssql/data/userdbs

- On Disk 2 (size 120 gb)
  - Use backup file /stale-storage/Softwares/SQL_Server_Setups/SqlServer-Samples-Dbs/StackOverflow2013.bak present on this host, and restore it on disk 2 on sqlbuntu vm.

- ensure sql services (engine & agent) are registered as linux services and starts automatically after reboots
- use port 1433 for engine. open firewall for ports 1433/tcp, udp/1434, tcp/1434, 80/443/tcp, 5022/tcp, ssh ports 22/21

- ensure sqlbuntu is connecting on port 1433 from remote machine list this ryzen9 host.

- use saanvi as user on current host.
- use ansible user for remote sqlbuntu host.
- Password for saanvi user of current host is saved in vault-pass file in this repo.
- Passwordless ssh is already configured for ansible user on sqlbuntu from current host.
- ansible remote user is already part of sudoers.

- for "sa" login, use same password as vault-pass file in this repo. Save this sa password in sensitive-values file and use ansible-vault to encrypt it.

## What NOT to modify

The vm sqlbuntu has 2 ethernets connected.
Ethernet enp1s0 is internal network so that all machines on this network can reach each other. Do not change this network settings.
Its ip is 192.168.100.54 in subnet 192.168.100.0/24 with dns 192.168.100.10.
Ethernet enp7s0 is NAT network so that sqlbuntu can access internet. Ensure that any connectivity in subnet 192.168.0.0/16 happens through enp1s0.
Any communication outside this subnet should happen through enp7s0.
Ensure internet connectivity is also working fine on sqlbuntu machine.

## How to work

Build ansible playbook in directory playbook--deploy-sqlserver-on-kvm-vm. Save all the sensitive information like sa password in value encrypted file sensitive-values. This can should be encrypted/read using ansible-vault & vault-pass file in this repo.

Any variable like sql server version, edition, directory path etc should be configurable using vars/default.yml file.

keep restore of stackoverflow task in separate task file so that I can skip it if I want.

So, augment, you are supposed to build ansible playbook, tasks, roles etc first.
Then run the playbook.

Setup 3 separate 5 minutes timers for yourself so that you can wake up yourself if there is timeout in main thread that is working on the task.

Maintain log of every run so that you can analyze the logs and progress in cases of timeout or errors.

You are allowed to connect to remote machine sqlbuntu to diagnose the issues by reading logs, but you are only allowed to fix, use and run ansible playbooks to make remote server modifications.

## Validation at the End

Perform following task from current ryzen9 host
- ping test to remote host sqlbuntu
- telnet test to remote host sqlbuntu on port 1433
- nc test to remote host sqlbuntu on port 1433
- sqlcmd -S 192.168.100.54 -U sa -P <sa-password> -Q "select 1"
- sqlcmd -S 192.168.100.54 -U sa -d StackOverflow2013 -P <sa-password> -Q "select 1"
- using sys.dm_server_services, verify that sql server engine and sql agent are running.

If any of the above validate fails, then you need to fix it and re-run the playbook.
Keeping repeating the process of validation and fixing the issues until all the validations are successful.