
  - name: Install multiple apps
    ansible.builtin.apt:
    ignore_errors: true
      pkg:
        - guake
        - timeshift
        - openssh-client
        - openssh-server
        - gnome-software
        - tldr
        - numlockx
        - git
        - vscode
        - vscode-insiders
        - azuredatastudio
        - python
        - python-is-python3
        - jupyterlab
        - slack
        - flameshot
        - samba
        - smbclient
        - caja-share
        - nginx
        - simplescreenrecorder
        - qbittorrent
        - guvcview
        - vlc
        - Stacer
        - cpu-x
        - cockpit
        - podman
        - cockpit-podman
        - cockpit-machines
        - netstat
        - zoom
        - kdiskmark
        - remmina
        - htop
        - mssql-cli
        - ffmpeg
        - xrdp
        - 7zip
        - ubuntu-restricted-extras
      state: latest
      update_cache: true
      register: apt_result
      #failed_when: apt_result.rc != 0 and "some_specific_error" not in apt_result.stderr

  - name: Install games
    ansible.builtin.apt:
    ignore_errors: true
      pkg:
        - supertux
        - tuxmath
        - supertuxkart
        - gimp
        - notepadqq
        - scratch
        - gparted
        - scratchjr
        - gcompris
        - kolibri
        - klettres
        - kolourpaint
      state: latest
      update_cache: true

  - name: Configure services
    ignore_errors: true
    ansible.builtin.service:
      name:
        - ssh
        - smbd
        - nginx
        - cockpit
        - podman
      enabled: true
      state: started

  - name: Add firewall exceptions by profile
    ignore_errors: true
    community.general.ufw:
      name:
        - openssh-server
        - Samba
        - nginx
        - cockpit
      rule: allow
      state: enabled

  - name: Install ubuntu-mate-desktop
    ignore_errors: true
    ansible.builtin.apt:
      pkg:
        - ubuntu-mate-desktop
    when: ansible_fqdn != "msi"

  - name: Fix missing dependencies
    ignore_errors: true
    ansible.builtin.shell:
      cmd: apt install -f
