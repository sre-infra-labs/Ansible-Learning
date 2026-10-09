# Install and Configure softwares on Ubuntu

## Add static IP for host in router
> [!IMPORTANT] If possible, Assign static ip address from router

## Openssh-Server
```
  sudo apt install openssh-client openssh-server
  sudo systemctl enable ssh
  sudo systemctl status ssh
  sudo ufw allow ssh
```

## Create ansible user & allow sudo without password
```
sudo adduser ansible
sudo addgroup sudo-nopw
sudo usermod -aG sudo-nopw ansible
echo '%sudo-nopw ALL=(ALL:ALL) NOPASSWD:ALL' | tee /etc/sudoers.d/sudo-nopw > /dev/null'
```

## Initial Setup of Ansible
```
# Configure password less ssh
ssh-keygen
ssh-copy-id server_desktop
ssh-copy-id ansible@server_desktop

# enable password sudo for ansible user
ansible server_desktop -m copy -a"src=/etc/sudoers.d/ansible dest=/etc/sudoers.d/ansible" -K

```

## Update `ubuntu-setup-config/files/etc_hosts` file
> [!NOTE]
> Update file `ubuntu-setup-config/files/etc_hosts` before running the playbook.

## Run Playbook
> [!IMPORTANT]
> Before running playbook, ensure to provide inputs.

### Inputs
1. [SSH on host should be configured](#openssh-server)
2. [Configure control node and managed host](#initial-setup-of-ansible)
3. [Configure sample playbook etc_hosts file](#update-ubuntu-setup-configfilesetc_hosts-file)
4. [Update file `vars/desktop_vars.yml`](vars/desktop_vars.yml)



`ansible-playbook configure-ubuntu-desktop.yml`

### Configure MATE Tweak
```
# NOTE: Start a GUI software on remote SSH session
  ssh -X server_desktop

  mate-tweak

# Note: Start a remote GUI Software locally
  ssh msi "DISPLAY=:0 nohup firefox"


# Choose "Mate" from Login Screen as Desktop Manager.

# Open Mate Tweak
  > Panel > Redmond Layout for Win7 like taskbar
  > Desktop > Enable desktop icons
# Configure "Control Panel" > Appearance > Themes
  > Create Home Directory Shortcuts
  > /stale-storage/shortcuts.png
```

## Configure guake
```
# Launch guake preferences utility
ssh -X server_desktop

guake -p

Set following properties

> General > General > "Start Guake at login" checkbox
> Main Window
    > Main Window Options
        > "Stay on top" checkbox
        > "Set window title to current tab name" checkbox
        > "Title in abbreviated form"
    > Placement
        > "Place tabs on top"
> Appearance > Effects > "Transparency"

```

## TimeShift
```
# timeshift > Backup & Recovery Tool
  > Take 1st backup
```

## Sample: Dump & Load config

```
# Edit mate-panel layout with command line
https://ubuntu-mate.community/t/edit-mate-panel-layout-with-command-line/25381/2

# Dump MATE config to file
dconf dump /org/mate/ > ubuntu-mate-desktop/files/dconf-org_mate.ini

# Apply MATE config from file
dconf load /org/mate/ < ubuntu-mate-desktop/files/dconf-org_mate.ini
```

## Install Scratch Jr by Building the debian package
```
# Go to Github directory, and clone the ScratchJr-Desktop repository
    # https://github.com/jfo8000/ScratchJr-Desktop/issues/44#issuecomment-852197567

cd Github
git clone https://github.com/leonskb4/ScratchJr-Desktop

# Install Node.js and npm
sudo apt-get install -y nodejs npm
sudo dnf install -y nodejs npm

# Install ScratchJr-Desktop dependencies
cd ScratchJr-Desktop
npm install && npm run publish

# Output
This should generate *.deb/*.rpm file in out/make.
```

### Markdown
[Basic Markdown syntax](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)