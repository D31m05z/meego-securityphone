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

#include "securityphone.h"

SecurityPhone::SecurityPhone()
{
    qDebug() << "CTOR SecurityPhone" << endl;

    passRecord = false;
    activating = false;
    codeNumber = 0;

    playlist = new QMediaPlaylist();
    playlist->addMedia(QUrl::fromLocalFile("/opt/SecurityPhone/base/login.wav"));
    playlist->addMedia(QUrl::fromLocalFile("/opt/SecurityPhone/base/beep.wav"));

    playlist->setCurrentIndex(0);
    playlist->setPlaybackMode(QMediaPlaylist::CurrentItemOnce);

    player = new QMediaPlayer;
    player->setPlaylist(playlist);
    player->setVolume(50);

    rumble = new QFeedbackHapticsEffect();
    rumble->setAttackIntensity(0.0);
    rumble->setAttackTime(100);
    rumble->setIntensity(0.6);
    rumble->setDuration(300);
    rumble->setFadeTime(100);
    rumble->setFadeIntensity(0.+0);
}

SecurityPhone::~SecurityPhone()
{
    qDebug() << "DTOR SecurityPhone" << endl;
    delete orientation;
    delete passFile;
    delete player;
    delete playlist;
    delete rumble;
    qDebug() << "DTOR SecurityPhone finished" << endl;
}

void SecurityPhone::inicialize(QObject* parent)
{
    qDebug() << "inicialize SecurityPhone" << endl;
    root = parent;
    orientation = new Orientation(parent);

    connect(orientation, SIGNAL(orientationChanged(int)), SLOT(onChangeOrientationChange(int)));

    password = "start: FACE UP\n";
    root->setProperty("password",password);

    readCurrentPassword();

    loadConfiguration();

    if(cSound) {
        playlist->setCurrentIndex(0);
        player->play();
    }
}

void SecurityPhone::loadConfiguration()
{
    GConfItem config_sound("/apps/ControlPanel/SecurityPhone/Sound");
    cSound = config_sound.value().toInt();

    GConfItem config_vibration("/apps/ControlPanel/SecurityPhone/Vibration");
    cVibration = config_vibration.value().toInt();

    GConfItem config_standby("/apps/ControlPanel/SecurityPhone/StandBy");
    cStandBy = config_standby.value().toInt();

    GConfItem config_anonym("/apps/ControlPanel/SecurityPhone/Anonym");
    cAnonym = config_anonym.value().toInt();

    GConfItem config_mail("/apps/ControlPanel/SecurityPhone/EMailNotification");
    cMail = config_mail.value().toInt();

    GConfItem config_mail_address("/apps/ControlPanel/SecurityPhone/EMail");
    cMailAddress = config_mail_address.value().toString();

    GConfItem config_gps("/apps/ControlPanel/SecurityPhone/GPS");
    cGPS = config_gps.value().toInt();

    GConfItem config_camera("/apps/ControlPanel/SecurityPhone/Camera");
    cCamera = config_camera.value().toInt();

    GConfItem config_exit_activator("/apps/ControlPanel/SecurityPhone/ExitActivator");
    cExitActivator = config_exit_activator.value().toInt();

    GConfItem config_number_pwd("/apps/ControlPanel/SecurityPhone/NumberPassword");
    numberPassword = config_number_pwd.value().toString();

    GConfItem config_pwd_type("/apps/ControlPanel/SecurityPhone/PasswordType");
    cPasswordType = config_pwd_type.value().toInt();

    root->setProperty("sound",cSound);
    root->setProperty("vibration",cVibration);
    root->setProperty("standby",cStandBy);
    root->setProperty("anonym",cAnonym);
    root->setProperty("mail",cMail);
    root->setProperty("mailAddress",cMailAddress);
    root->setProperty("gps",cGPS);
    root->setProperty("camera",cCamera);
    root->setProperty("exitActivator",cExitActivator);
    root->setProperty("numberPassword",numberPassword);
    qDebug() << "PASSWORD:" << numberPassword.toStdString()<<endl;
    root->setProperty("useTypeUnlock",cPasswordType);
}

void SecurityPhone::vibrate()
{
    rumble->start();
}

///////////INVOKE

void SecurityPhone::orientationEnable(bool enable)
{
    qDebug() << "orientationEnable:" << enable << endl;
    orientation->setActive(enable);
}

bool SecurityPhone::isPassRecording()
{
    qDebug() << "isPassRecording" << endl;
    return passRecord;
}

void SecurityPhone::startPasswordRecord()
{
    qDebug() << "CREATE PASSWORD FILE" << endl;
    passFile = new QFile("/home/user/securityPhone.txt");

    if (!passFile->open(QIODevice::WriteOnly | QIODevice::Text)) {
        //std::cout << "Error: cannot create log file" << passFile->fileName().toStdString() << std::endl;
        qDebug() << "FILE CREATE FAIL" << endl;
    }

    passRecord  = true;
    root->setProperty("isPassRecording",true);
    password = "start: FACE UP\n";
    root->setProperty("password",password);
    codeNumber = 0;
}

void SecurityPhone::stopPasswordRecord()
{
    qDebug() << "stopPasswordRecord" << endl;
    passRecord  = false;
    root->setProperty("isPassRecording",false);

    passFile->close();
}

void SecurityPhone::onChangeOrientationChange(int state)
{
    qDebug() << "onChangeOrientationChange:"<<passRecord << " STATE: " <<state<< endl;
    if(!passRecord)
        return;

    if(cSound) {
        playlist->setCurrentIndex(1);
        player->play();
    }

    if(cVibration)
        vibrate();

    QTextStream out(passFile);
    out << state << endl;
    codeNumber++;

    switch(state)
    {
    case QOrientationReading::TopUp:
        password.append("Top Up\n");
        break;
    case QOrientationReading::TopDown:
        password.append("Top Down\n");
        break;
    case QOrientationReading::LeftUp:
        password.append("Left Up\n");
        break;
    case QOrientationReading::RightUp:
        password.append("Right Up\n");
        break;
    case QOrientationReading::FaceDown:
        password.append("Face Down\n");
        break;
    case QOrientationReading::FaceUp:
        password.append("Face Up\n");
        break;
    default:
        break;
    }
    root->setProperty("password",password);

    if(codeNumber == 7)
        stopPasswordRecord();
}

void SecurityPhone::processPasswordLine(int code)
{
    switch(code)
    {
    case QOrientationReading::TopUp:
        password.append("Top Up\n");
        break;
    case QOrientationReading::TopDown:
        password.append("Top Down\n");
        break;
    case QOrientationReading::LeftUp:
        password.append("Left Up\n");
        break;
    case QOrientationReading::RightUp:
        password.append("Right Up\n");
        break;
    case QOrientationReading::FaceDown:
        password.append("Face Down\n");
        break;
    case QOrientationReading::FaceUp:
        password.append("Face Up\n");
        break;
    default:
        break;
    }
    root->setProperty("password",password);
}

void SecurityPhone::readCurrentPassword()
{

    qDebug()<< "readCurrPass" << endl;

    QFile file("/home/user/securityPhone.txt");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "NOT EXISTS" << endl;
        return;
    }

    while (!file.atEnd()) {
        QString line = file.readLine();
        processPasswordLine(line.toInt());
        codeNumber++;
    }
}

void SecurityPhone::switchSound(bool enable)
{
    qDebug() << "switchSound:" << enable << endl;
    root->setProperty("sound",enable);

    GConfItem*  config = new GConfItem("/apps/ControlPanel/SecurityPhone/Sound");
    config->set(enable);

    cSound = enable;
}

void SecurityPhone::switchVibration(bool enable)
{
    qDebug() << "switchVibration:" << enable << endl;
    root->setProperty("vibration",enable);

    GConfItem*  config = new GConfItem("/apps/ControlPanel/SecurityPhone/Vibration");
    config->set(enable);

    cVibration = enable;
}

void SecurityPhone::switchStandBy(bool enable)
{
    qDebug() << "switchStandBy:" << enable << endl;
    root->setProperty("standby",enable);

    GConfItem*  config = new GConfItem("/apps/ControlPanel/SecurityPhone/StandBy");
    config->set(enable);

    cStandBy = enable;

    if(cAnonym && enable) {
        if(cVibration)
            vibrate();

        MNotification notification(MNotification::DeviceEvent, "", QObject::tr("Warning! Anonym alarm is activated. It is not really anonym."));
        notification.setImage("icon-m-user-guide");
        notification.publish();
    }
}

void SecurityPhone::switchAnonym(bool enable)
{
    qDebug() << "switchAnonym:" << enable << endl;
    root->setProperty("anonym",enable);

    GConfItem*  config = new GConfItem("/apps/ControlPanel/SecurityPhone/Anonym");
    config->set(enable);

    cAnonym = enable;
}

void SecurityPhone::switchMail(bool enable)
{
    qDebug() << "switchMail:" << enable << endl;
    root->setProperty("mail",enable);

    GConfItem*  config = new GConfItem("/apps/ControlPanel/SecurityPhone/EMailNotification");
    config->set(enable);

    cMail = enable;
}

void SecurityPhone::switchMailAddress(QString mail)
{
    qDebug() << "switchMailAddress:" << mail.toStdString() << endl;
    root->setProperty("mailAddress",mail);

    GConfItem*  config = new GConfItem("/apps/ControlPanel/SecurityPhone/EMail");
    config->set(mail);
    cMailAddress = mail;
}

void SecurityPhone::startService(bool timer)
{
    root->setProperty("activated",true);

    if(activating) {
        MNotification notification(MNotification::DeviceEvent, "", QObject::tr("activating in progress..."));
        notification.setImage("icon-m-user-guide");
        notification.publish();

    } else {
        root->setProperty("countDown", 3);
        MNotification notification(MNotification::DeviceEvent, "", QObject::tr("Security system activating..."));
        notification.setImage("icon-m-user-guide");
        notification.publish();

        if(timer) {
            QTimer *timer = new QTimer(this);
            timer->setInterval(2000);
            connect(timer, SIGNAL(timeout()), this, SLOT(onExitAutomatically()));
            timer->start();
        } else {
            qDebug() << "start service" << endl;
            system("/bin/sh /opt/SecurityPhone/base/service.sh");
            qDebug() << "started service" << endl;
        }
    }

    activating = true;
}

void SecurityPhone::onExitAutomatically()
{
    static int count = 1;
    if(count > 2) {
        qDebug() << "start service" << endl;
        system("/bin/sh /opt/SecurityPhone/base/service.sh");
        qDebug() << "started service" << endl;
    }

    root->setProperty("countDown",3-count);
    count++;
}

void SecurityPhone::switchGPS(bool enable)
{
    qDebug() << "GPS:" << enable << endl;
    root->setProperty("gps",enable);

    GConfItem*  config = new GConfItem("/apps/ControlPanel/SecurityPhone/GPS");
    config->set(enable);

    cGPS = enable;
}

void SecurityPhone::switchCamera(bool enable)
{
    qDebug() << "Camera:" << enable << endl;

    root->setProperty("camera",enable);

    GConfItem*  config = new GConfItem("/apps/ControlPanel/SecurityPhone/Camera");
    config->set(enable);

    cCamera = enable;
}

void SecurityPhone::switchExitActivator(bool enable)
{
    qDebug() << "ExitActivator:" << enable << endl;

    root->setProperty("exitActivator",enable);

    GConfItem*  config = new GConfItem("/apps/ControlPanel/SecurityPhone/ExitActivator");
    config->set(enable);

    cExitActivator = enable;
}

void SecurityPhone::showBanner(QString txt)
{
    if(cVibration)
        vibrate();

    MNotification notification(MNotification::DeviceEvent, "", txt);
    notification.setImage("icon-m-user-guide");
    notification.publish();
}

void SecurityPhone::switchPassword(QString pass)
{
    qDebug() << "switchPassword:" << pass.toStdString() << endl;

    numberPassword = pass;
    root->setProperty("numberPassword",numberPassword);

    GConfItem*  config = new GConfItem("/apps/ControlPanel/SecurityPhone/NumberPassword");
    config->set(numberPassword);
}

void SecurityPhone::setPasswordType(bool type)
{
    qDebug() << "setPasswordType:" << type << endl;

    cPasswordType = type;
    root->setProperty("useTypeUnlock",cPasswordType);

    GConfItem*  config = new GConfItem("/apps/ControlPanel/SecurityPhone/PasswordType");
    config->set(cPasswordType);
}
