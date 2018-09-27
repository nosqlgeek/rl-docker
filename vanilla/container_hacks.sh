#!/bin/bash
sed -i '2inodaemon=true' /opt/redislabs/config/supervisord.conf
# Can't modify OOM score inside an unprivileged container (unless we demend the resource cap and setcap our binaries)
echo "Unpriv container setup"
sed -i 's/oom_score_adj.*//g' /opt/redislabs/config/supervisord.conf

# This was necassary due to a storage driver quirk -- might be possible to skip it now...
setcap cap_sys_resource+ep /opt/redislabs/bin/dmcproxy
for file in /opt/redislabs/bin/redis-server-*; do
    setcap cap_sys_resource+ep $file
done
setcap cap_net_bind_service+ep /opt/redislabs/sbin/pdns_server
setcap cap_sys_ptrace+ep /opt/redislabs/sbin/smaps

# Fix log permissions
chown -R redislabs:redislabs /var/opt/redislabs/log/*

# Remove syslog handlers
conf_file=$(cat /opt/redislabs/config/logging.conf)
echo ${conf_file} | /opt/redislabs/bin/python -c 'import sys; import json; l=json.load(sys.stdin); l["handlers"].pop("syslog", None); l["loggers"]["event_log"]["handlers"] = []; print json.dumps(l, indent=4)' > \
    /opt/redislabs/config/logging.conf

# We want avahi to run so we have mDNS resolution between containers.
sed -i 's/^.*enable-dbus.*$/enable-dbus=no/g' /etc/avahi/avahi-daemon.conf

echo "export TERM=xterm" >> ~/.bashrc
echo ". /etc/profile.d/redislabs_env.sh" >> /root/.bashrc

# Dirs must be created on image build since creating and changing file permissions on runtime,
# while running docker on an OS using AUFS doesn't work (Known issue in docker)
rm -rf /var/run/saslauthd
GENERATE_CERTS=false /opt/redislabs/sbin/supervisord_prestart_script.sh
