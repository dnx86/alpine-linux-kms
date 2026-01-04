# Hyper-V Alpine Linux KMS VM
** YEAH I KNOW THIS CAN BE DONE USING A DOCKER CONTAINER. **

## SHA256 hashes:
```
alpine-virt-3.23.2-x86_64.iso
C328A553BA9861E4CCB3560D69E426256955FA954BC6F084772E6E6CD5B0A4D0

vlmcsd-x64-musl-static
B69B8EDD285572B510ED0A5840A23619428554EAC83E24C7433879DEC25DF683
```

## Requirements
+ Windows 11 with Hyper-V installed.
+ Virtual switches:
    + Default Switch
    + An internal network switch (192.168.255.0/24 or use your own IP addressing scheme).
+ KMS VM
    + Generation 2 with Secure Boot **disabled**.
    + 1 CPU
    + 512 MB RAM
    + 1 GB VHD
    + First network adapter connected to the **internal network switch**.
    + Second network adapter connected to the **default switch**.
    + DVD drive with Alpine Linux ISO. Set to boot first.

## Steps
1. Install Alpine Linux in sys disk mode.
    + `setup-alpine`
3. Poweroff the VM instead of rebooting it when installation is done.
    + Remove the DVD drive and make sure the **hard drive is first in the boot order**.
    + Start the VM.
4. Copy vlmcsd-x64-musl-static (not provided) and setup-kms.sh into the VM.
5. `su -l root`
    + chmod +x both files.
    + Copy vlmcsd-x64-musl-static to /usr/bin/
    + Run setup-kms.sh (edit relevant parts if your IP addressing scheme is different).
6. Disconnect the default switch from the second network adapter.
7. Reboot
8. Verify:
```
# Check if vlmcsd is running
rc-service vlmcsd status

# Check ufw rules
ufw status
```

## Todo
- [ ] Add reference section with links.
- [ ] Automate the process.
