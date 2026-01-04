#!/bin/sh

# Update and upgrade
apk -U upgrade

# Hyper-V guest services
# Install
apk add hvtools

# Enable
rc-service hv_fcopy_daemon start
rc-service hv_kvp_daemon start
rc-service hv_vss_daemon start

# Start on boot
rc-update add hv_fcopy_daemon
rc-update add hv_kvp_daemon
rc-update add hv_vss_daemon

# Enable the community repository
setup-apkrepos -c -1

# Install ufw
apk add iptables ufw
ufw enable
ufw allow proto tcp from 192.168.255.0/24 to any port 1688
ufw allow proto tcp from 192.168.255.0/24 to any port 22
rc-update add ufw

# Create vlmcsd group and user
addgroup -S vlmcsd
adduser -S -D -H -s /sbin/nologin -G vlmcsd -g vlmcsd vlmcsd

# Manually copy vlmcsd-x64-musl-static to /usr/bin and chmod +x it.
# Below is to have it run as a service.
cat <<EOF > /etc/init.d/vlmcsd
#!/sbin/openrc-run

supervisor=supervise-daemon
name=vlmcsd
command="/usr/bin/vlmcsd-x64-musl-static"
command_user=vlmcsd
command_args="-D"
pidfile="/run/vlmcsd.pid"

depend() {
        use logger dns
        need net
        after firewall
}
EOF

chmod +x /etc/init.d/vlmcsd
rc-update add vlmcsd
rc-service vlmcsd start
