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

#ifndef SECURITYPHONE_H
#define SECURITYPHONE_H

#include <QObject>
#include <QDebug>
#include <QFile>
#include <QTextStream>
#include <QMediaPlayer>
#include <QMediaPlaylist>
#include <QProcess>
#include <QTimer>

#include <MComponentData>
#include <MNotification>

#include <gconfitem.h>
#include <iostream>

using namespace std;

#define qDebug() cout
#include "orientation.h"

class SecurityPhone: public QObject
{
    Q_OBJECT
public:
    SecurityPhone();
    ~SecurityPhone();

    Q_INVOKABLE void orientationEnable(bool enable);
    Q_INVOKABLE bool isPassRecording();
    Q_INVOKABLE void startPasswordRecord();
    Q_INVOKABLE void stopPasswordRecord();
    Q_INVOKABLE void switchSound(bool enable);
    Q_INVOKABLE void switchVibration(bool enable);
    Q_INVOKABLE void switchStandBy(bool enable);
    Q_INVOKABLE void switchAnonym(bool enable);
    Q_INVOKABLE void switchMail(bool enable);
    Q_INVOKABLE void switchMailAddress(QString mail);
    Q_INVOKABLE void startService(bool timer);
    Q_INVOKABLE void switchGPS(bool enable);
    Q_INVOKABLE void switchCamera(bool enable);
    Q_INVOKABLE void switchExitActivator(bool enable);
    Q_INVOKABLE void showBanner(QString txt);
    Q_INVOKABLE void switchPassword(QString pass);
    Q_INVOKABLE void setPasswordType(bool type);

    void inicialize(QObject *parent);
    void readCurrentPassword();
    void processPasswordLine(int code);
    void loadConfiguration();

    void vibrate();

public slots:
    void onChangeOrientationChange(int state);
    void onExitAutomatically();

private:
    QObject* root;
    Orientation* orientation;
    bool passRecord;
    QFile* passFile;
    QString password;
    QString numberPassword;

    int codeNumber;
    QMediaPlayer* player;
    QMediaPlaylist* playlist;

    bool cSound;
    bool cVibration;
    bool cStandBy;
    bool cAnonym;
    bool cMail;
    QString cMailAddress;
    bool cGPS;
    bool cCamera;
    bool cExitActivator;
    bool cPasswordType;
    bool activating;
};

#endif // SECURITYPHONE_H
