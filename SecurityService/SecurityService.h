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

#ifndef SERVICEOFF_H
#define SERVICEOFF_H

#include <QObject>
#include <MComponentData>
#include <MNotification>

#include <QApplication>
#include <QFeedbackHapticsEffect>
#include <QMediaPlayer>
#include <QMediaPlaylist>
#include <QFile>
#include <QDebug>
#include <QDateTime>

#include <policy/resource-set.h>
#include <gconfitem.h>
#include <iostream>

#include <QtDBus/QDBusConnection>
#include <QtDBus/QDBusInterface>
#include <QtDBus/QDBusConnectionInterface>

//#include <unistd.h>
//#define DBUS_API_SUBJECT_TO_CHANGE
//#include <osso-ic.h>
/*
#include <hal/libhal.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <glib.h>
#include <glib-object.h>
#include <dbus/dbus.h>
#include <dbus/dbus-glib-lowlevel.h>

*/
#include "orientation.h"
#ifdef HAS_MAIL_SERVICE
#include "mailService/SmtpMime"
#endif
#include "powerbuttonlistener.h"

using namespace QtMobility;
using namespace std;

#define qDebug() cout

class SecurityService : public QObject
{
    Q_OBJECT
public:
    SecurityService(QObject* parent=0);
    ~SecurityService();

    void vibrate(int duration, qreal intensity);
    void effectStateChanged();
    void readCurrentPassword();

    void loadConfiguration();

#ifdef HAS_MAIL_SERVICE
    bool sendMail(QString mail);
#endif

    bool increaseVolume();
    bool playbackState();

    void deactivating();

    void ALARM();

public slots:

    void onChangeOrientationChange(int state);
    void onStateChanged(QMediaPlayer::State state);
    void volumeMaximized();
    void powerBtnDoubleClick();

private:
    Orientation* orientation;
    QMediaPlayer* player;
    QMediaPlaylist* playlist;
    int password[7];
    int readIndex;
    int requires;
    bool fail;
    bool pass;
    bool alarming;
    // bool login;

    // int failCount;

    bool cSound;
    bool cVibration;
    bool cStandBy;
    bool cAnonym;
    bool cMail;
    QString cMailAddress;
    bool cGPS;
    bool cCamera;

    //! A resource object for volume(zoom)-hardware keys
    ResourcePolicy::ResourceSet *volResourceSet;

    bool cPasswordType;
};

#endif // SERVICEOFF_H
