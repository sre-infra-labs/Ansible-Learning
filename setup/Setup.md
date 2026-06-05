# For fixing internet issue on RHEL
```
saanvi@sqlred:~$ ip a
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    inet 192.168.100.55/24 brd 192.168.100.255 scope global noprefixroute enp1s0
3: enp7s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    inet 192.168.122.237/24 brd 192.168.122.255 scope global dynamic noprefixroute enp7s0

Target Config
----------------
Nic enp1s0 should only have a static route for 192.168.0.0/16 via 192.168.100.1
Nic enp7s0 should have the default route (already given by DHCP, just need to stop enp1s0 from overriding it)

# 1. See the current connection profile names
nmcli connection show

# 2. Fix enp1s0:
#    - never install a default route from this interface
#    - add a static route covering all of 192.168.0.0/16 via the lab gateway
sudo nmcli connection modify enp1s0 \
  ipv4.never-default yes \
  ipv4.routes "192.168.0.0/16 192.168.100.1"

# 3. Fix enp7s0:
#    - ensure it IS allowed to provide the default route (DHCP gives 192.168.122.1)
sudo nmcli connection modify enp7s0 \
  ipv4.never-default no

# 4. Apply changes (bring connections down and back up)
sudo nmcli connection up enp1s0
sudo nmcli connection up enp7s0

# 5. Verify the routing table
ip route show


Expected Output Should Look Like
--------------------------------
default via 192.168.122.1 dev enp7s0         # internet via NAT
192.168.0.0/16 via 192.168.100.1 dev enp1s0  # whole 192.168.x.x via lab
192.168.100.0/24 dev enp1s0 proto kernel      # directly connected (auto)
192.168.122.0/24 dev enp7s0 proto kernel      # directly connected (auto)

```


# For fixing internet issue on Ubuntu
```
saanvi@sqlred:~$ ip a
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    inet 192.168.100.55/24 brd 192.168.100.255 scope global noprefixroute enp1s0
3: enp7s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    inet 192.168.122.237/24 brd 192.168.122.255 scope global dynamic noprefixroute enp7s0

Target Config
----------------
Nic enp1s0 should only have a static route for 192.168.0.0/16 via 192.168.100.1
Nic enp7s0 should have the default route (already given by DHCP, just need to stop enp1s0 from overriding it)

# Step 01: Create/edit  /etc/netplan/01-netcfg.yaml :
-- *******************************************************
network:
  version: 2
  renderer: networkd
  ethernets:

    enp1s0:
      dhcp4: false
      addresses:
        - 192.168.100.55/24
      routes:
        - to: 192.168.0.0/16
          via: 192.168.100.1
      # No default route entry → enp1s0 never overrides the default gateway

    enp7s0:
      dhcp4: true
      # DHCP provides 192.168.122.1 as default gateway — nothing extra needed
-- *******************************************************

# Step 02: Apply and verify
-- *******************************************************
# 1. Validate the YAML first (dry-run, no changes applied)
sudo netplan try --timeout 30

# 2. Apply permanently
sudo netplan apply

# 3. Verify routing table
ip route show
-- *******************************************************

Expected Output Should Look Like
--------------------------------
default via 192.168.122.1 dev enp7s0         # internet via NAT
192.168.0.0/16 via 192.168.100.1 dev enp1s0  # whole 192.168.x.x via lab
192.168.100.0/24 dev enp1s0 proto kernel      # directly connected (auto)
192.168.122.0/24 dev enp7s0 proto kernel      # directly connected (auto)

```


# Setup Ubuntu Host with Ansible
```
sudo -i -u root

sudo apt update && sudo apt install -y qemu-guest-agent
sudo systemctl enable --now qemu-guest-agent


adduser ansible
addgroup sudo-nopw
echo '%sudo-nopw ALL=(ALL:ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/sudo-nopw > /dev/null
usermod -aG sudo-nopw ansible
```

# Setup RHEL Host with Ansible
```
sudo -i

sudo dnf install -y qemu-guest-agent
sudo systemctl enable --now qemu-guest-agent

useradd -m ansible
passwd ansible

groupadd sudo-nopw

echo '%sudo-nopw ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/sudo-nopw
chmod 440 /etc/sudoers.d/sudo-nopw

usermod -aG sudo-nopw ansible
```



