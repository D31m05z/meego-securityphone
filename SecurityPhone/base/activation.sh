#!/bin/sh

sed -i 's/PowerKeyLongAction=poweroff/PowerKeyLongAction=disabled/g' /etc/mce/mce.ini

echo "Restarting mce..."
/sbin/stop mce
/sbin/start mce

exit 0
