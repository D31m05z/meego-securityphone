/** * * * Gergely Boross - 2012_02_27 * * * * * * * * * * * * *\
*    _ _____   _____        __ _                              *
*   (_)  __ \ / ____|      / _| |                             *
*   |_| |__)| (___    ___ | |_| |___      ____ _ _ __ ___     *
*   | |  _  / \___ \ / _ \|  _| __\ \ /\ / / _` | '__/ _ \    *
*   | | | \ \ ____) | (_) | | | |_ \ V  V / (_| | | |  __/    *
*   |_|_|  \_\_____/ \___/|_|  \__| \_/\_/ \__,_|_|  \___|    *
*                                                             *
*                http://irsoftware.net                        *
*                                                             *
*              contact_adress: sk8Geri@gmail.com               *
*                                                               *
*       This file is a part of the work done by aFagylaltos.     *
*         You are free to use the code in any way you like,      *
*         modified, unmodified or copied into your own work.     *
*        However, I would like you to consider the following:    *
*                                                               *
*  -If you use this file and its contents unmodified,         *
*              or use a major part of this file,               *
*     please credit the author and leave this note untouched.   *
*  -If you want to use anything in this file commercially,      *
*                please request my approval.                    *
*                                                              *
\* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#include "panic.h"

Panic::Panic()
{

}

Panic::~Panic()
{

}

void Panic::init(QObject *parent)
{
    root = parent;

    GConfItem config_password("/apps/ControlPanel/SecurityPhone/NumberPassword");
    password = config_password.value().toString();
    root->setProperty("password", password);
    qDebug() << password << endl;

    GConfItem config_standby("/apps/ControlPanel/SecurityPhone/StandBy");
    cStandBy = config_standby.value().toInt();

    GConfItem config_password_type("/apps/ControlPanel/SecurityPhone/PasswordType");
    cPasswordType = config_password_type.value().toInt();
    root->setProperty("type", cPasswordType);
}

//invoke

void Panic::killService()
{
    qDebug() << "KILL SERVICE, password entered" << endl;

    MNotification notification(MNotification::DeviceEvent, "", QObject::tr("Security system deactivating..."));
    notification.setImage("icon-m-user-guide");
    notification.publish();

    qDebug() << "ICON UPDATE" << endl;
    system("cat /opt/SecurityPhone/base/settings.desktop >/usr/share/applications/SecurityPhone_harmattan.desktop");

    qDebug() << "PASSWORD ENTERED: QUIT..." << endl;

    if(cStandBy) {
        qDebug() << "remove from standby" << endl;
        system("gconftool-2 -t string -s /desktop/meego/screen_lock/low_power_mode/operator_logo /opt/SecurityPhone/base/standby-nothing.png");
    }

    qDebug() << "power button overwrite - restore default settings" << endl;
    QProcess process;
    process.start("sh /opt/SecurityPhone/base/panic.sh");

    exit(0);
}
