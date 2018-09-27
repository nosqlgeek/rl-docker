#!/bin/bash
umask 027
set -e
set -u

sed -i 's/^.*enable-dbus.*$/enable-dbus=no/g' /etc/avahi/avahi-daemon.conf
avahi-daemon --daemonize --no-drop-root &
/opt/container_hacks.sh
/opt/redislabs/sbin/supervisord_prestart_script.sh
source /etc/opt/redislabs/paths.sh
sudo -u redislabs socketdir=${socketdir} IS_CONTAINERIZED=1 /opt/redislabs/bin/supervisord -c /opt/redislabs/config/supervisord.conf --nodaemon &
SUPERVISOR_PID=$!

wait $SUPERVISOR_PID
