#!/bin/sh

sed -i 's/PowerKeyLongAction=disabled/PowerKeyLongAction=poweroff/g' /etc/mce/mce.ini

echo "Restarting mce..."
/sbin/stop mce
/sbin/start mce

exit 0
