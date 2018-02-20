#!/bin/sh

if pkill SecurityService; then
    echo "killed"
	cat /opt/SecurityPhone/base/settings.desktop >/usr/share/applications/SecurityPhone_harmattan.desktop
else
    echo "starting"
	cat /opt/SecurityPhone/base/on.desktop >/usr/share/applications/SecurityPhone_harmattan.desktop
	pkill SecurityPhone
    /opt/SecurityPhone/base/SecurityService
fi
