# realm: Couldn't authenticate as administrator@LAB.COM: Cannot find KDC for realm LAB.COM
## Error
```
TASK [join_linux_to_ad : Join machines to AD] ************************************************************************************************************************
fatal: [pg-consul-rhel]: FAILED! => {"changed": true, "cmd": "echo 'Pa$$w0rd' | sudo realm join --user=administrator lab.com", "delta": "0:00:00.655234", "end": "2025-05-14 08:00:08.139006", "msg": "non-zero return code", "rc": 1, "start": "2025-05-14 08:00:07.483772", "stderr": "See: journalctl REALMD_OPERATION=r571.92653\nrealm: Couldn't authenticate as administrator@LAB.COM: Cannot find KDC for realm \"LAB.COM\"\nPlease check\n    https://red.ht/support_rhel_ad \nto get help for common issues.", "stderr_lines": ["See: journalctl REALMD_OPERATION=r571.92653", "realm: Couldn't authenticate as administrator@LAB.COM: Cannot find KDC for realm \"LAB.COM\"", "Please check", "    https://red.ht/support_rhel_ad ", "to get help for common issues."], "stdout": "", "stdout_lines": []}
```
## Fix
```
# sudo vim /etc/resolv.conf
    search lab.com
    nameserver 192.168.100.10
    nameserver 192.168.100.1
    nameserver 8.8.8.8
# mark /etc/resolv.conf not for change after reboot
# sudo chattr +i /etc/resolv.conf
```
