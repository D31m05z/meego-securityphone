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

#include "SecurityService.h"

const QString DBUS_MUSIC_SERVICE("com.nokia.music-suite");
const QString DBUS_MUSIC_PATH("/");
const QString DBUS_MUSIC_INTERFACE("com.nokia.maemo.meegotouch.MusicSuiteInterface");

const QString DBUS_PBSTATE("playbackState");

const QString DBUS_MAFW_SERVICE("com.nokia.mafw.plugin.libqmafw_gst_renderer_plugin");
const QString DBUS_MAFW_PATH("/com/nokia/mafw/renderer/mafw_gst_renderer");
const QString DBUS_MAFW_INTERFACE("com.nokia.mafw.extension");

const QString DBUS_MAFW_GETPROPERTY("get_extension_property");
const QString DBUS_MAFW_SETPROPERTY("set_extension_property");

SecurityService::SecurityService(QObject *parent)
    : QObject(parent)
{
    readIndex = 0;
    requires= 0;
    fail = false;
    pass = false;
    alarming = false;

    loadConfiguration();
    readCurrentPassword();

    orientation = new Orientation(parent);
    connect(orientation,SIGNAL(orientationChanged(int)),SLOT(onChangeOrientationChange(int)));

    playlist = new QMediaPlaylist();
    playlist->addMedia(QUrl::fromLocalFile("/opt/SecurityPhone/base/alarm.wav"));
    playlist->addMedia(QUrl::fromLocalFile("/opt/SecurityPhone/base/beep.wav"));
    playlist->addMedia(QUrl::fromLocalFile("/opt/SecurityPhone/base/login.wav"));

    playlist->setCurrentIndex(0);
    playlist->setPlaybackMode(QMediaPlaylist::CurrentItemOnce);

    player = new QMediaPlayer;
    player->setPlaylist(playlist);

    player->setVolume(100);

    if(cAnonym || !cSound)
        player->setMuted(true);

    connect(player,SIGNAL(stateChanged(QMediaPlayer::State)),SLOT(onStateChanged(QMediaPlayer::State)));

    volResourceSet = new ResourcePolicy::ResourceSet("player", this);
    volResourceSet->addResourceObject(new ResourcePolicy::ScaleButtonResource);
    volResourceSet->acquire();
    // volResourceSet->release();

    qDebug() << "power button overwrite" << endl;
    QProcess *proc = new QProcess();
    proc->start("sh /opt/SecurityPhone/base/activation.sh");

    PowerButtonListener* listener = new PowerButtonListener(this);
    //  PowerMenu powerMenu(window);

    QObject::connect(listener, SIGNAL(powerButtonDoubleClicked()), this, SLOT(powerBtnDoubleClick()));
    QObject::connect(listener, SIGNAL(powerButtonLongPressed()), this, SLOT(powerBtnDoubleClick()));

    if(cStandBy) {
        qDebug() << "set activ" << endl;
        system("gconftool-2 -t string -s /desktop/meego/screen_lock/low_power_mode/operator_logo /opt/SecurityPhone/base/standby-activated.png");
    }
}

SecurityService::~SecurityService()
{
    delete orientation;
    delete player;
    delete playlist;
}

void SecurityService::powerBtnDoubleClick()
{
    qDebug() << "powerBtn click" << endl;
    printf("fgdfgdfgdgdfg\n");

}

void SecurityService::deactivating()
{
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
    QProcess *proc = new QProcess();
    proc->start("sh /opt/SecurityPhone/base/deactivation.sh");

    exit(0);
}

void SecurityService::onStateChanged(QMediaPlayer::State state)
{
    qDebug() << "onStateChanged: " <<state;
    /*
    if(pass && state == QMediaPlayer::StoppedState){
        deactivating();
    }*/
}

void SecurityService::vibrate(int duration, qreal intensity)
{
    QFeedbackHapticsEffect* rumble = new QFeedbackHapticsEffect();
    rumble->setAttackIntensity(0.0);
    rumble->setAttackTime(100);
    rumble->setIntensity(intensity);
    rumble->setDuration(duration);
    rumble->setFadeTime(100);
    rumble->setFadeIntensity(0.+0);

    rumble->start();
}

void SecurityService::onChangeOrientationChange(int state)
{
    if(pass) return;

    qDebug() << "orientation changed| checkID:" << readIndex << endl;

    if(cPasswordType) {
        ALARM();
    } else {
        if(fail) {
            if( state == password[readIndex++]) {
                qDebug() << "CORRECT" << endl;

                /*
                if(cSound){
                    playlist->setCurrentIndex(1);
                    playlist->setPlaybackMode(QMediaPlaylist::CurrentItemOnce);

                    player->play();
                }*/

                if(cVibration)
                    vibrate(300,0.6f);

                if(requires == readIndex)
                {
                    qDebug() << "PASSED" << endl;
                    pass = true;
                    deactivating();
                }
            } else {
                qDebug() << "PLEASE TAKE THE PHONE ON FACE UP!!!" << endl;
                qDebug() << "AND START ENTER YOUR PASSWORD AGAIN!!!" << endl;
                readIndex = 0;
                vibrate(3000,1.0f);
                /*  sleep(1);
               vibrate(200,0.6f);
               sleep(1);
               vibrate(200,0.8f);
               sleep(1);*/
            }
        } else {
            if(state == password[readIndex++]) {
                qDebug() << "CORRECT" << endl;

                if(cSound) {
                    playlist->setCurrentIndex(1);
                    playlist->setPlaybackMode(QMediaPlaylist::CurrentItemOnce);
                    player->play();
                }

                if(cVibration)
                    vibrate(300,0.6f);

                if(requires == readIndex) {
                    qDebug() << "PASSED" << endl;
                    pass = true;
                    fail = false;

                    if(cSound) {
                        playlist->setCurrentIndex(0);
                        playlist->setPlaybackMode(QMediaPlaylist::CurrentItemInLoop);
                        player->stop();
                    }

                    deactivating();
                }
            } else {
                ALARM();
            }
        }
    }
}

void SecurityService::ALARM()
{
    if(alarming) return;

    if (player->state() != QMediaPlayer::PlayingState) {
        qDebug() << "WRONG PASSWORD!! ALARM IS STARTING..." << endl;

        if(cMail) {
            #ifdef HAS_MAIL_SERVICE
            if(cMailAddress !="") {
                qDebug() << "sending mail" << endl;
                if(!sendMail(cMailAddress))
                    qDebug() << "mail sending failed!!" << endl;
            }
            #else
                qDebug() << "mail service is not supported" << endl;
            #endif
        }

        if(cSound) {
            qDebug() << "ALARM SOUND STARTING" << endl;
            playlist->setCurrentIndex(0);
            playlist->setPlaybackMode(QMediaPlaylist::CurrentItemInLoop);

            player->play();
        }

        qDebug() << "ALARM VOLUME TIGGER TIMER STARTING" << endl;
        //------------------------timer-----------
        QTimer *timer = new QTimer(this);
        timer->setInterval(1000);
        connect(timer, SIGNAL(timeout()), this, SLOT(volumeMaximized()));
        timer->start();
        //----------------------------------------

        if(cStandBy) {
            qDebug() << "show on standby" << endl;
            system("gconftool-2 -t string -s /desktop/meego/screen_lock/low_power_mode/operator_logo /opt/SecurityPhone/base/standby-warning.png");
        }

        readIndex =0;
        fail = true;

        qDebug() << "SO YOU ARE LOOSE $$$$" << endl;
        alarming = true;
    }
}

void SecurityService::readCurrentPassword()
{

    qDebug()<< "readCurrPass" << endl;

    QFile file("/home/user/securityPhone.txt");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "NOT EXISTS" << endl;
        return;
    }

    for(int i=0;i<7;i++)
        password[i]=0;

    int j=0;
    while (!file.atEnd()) {
        QString line = file.readLine();
        qDebug() << "LINE: " << line.toStdString();
        password[j++] = line.toInt();
    }

    bool passwordIsEmpty = true;

    for(int k=0;k<7;k++) {
        if(password[k] != 0) {
            requires++;
            passwordIsEmpty = false;
        }
    }

    if(passwordIsEmpty) {
        MNotification notification(MNotification::DeviceEvent, "", QObject::tr("First set up your password! Start the SecurityPhone!"));
        notification.setImage("icon-m-user-guide");
        notification.publish();

        if(cStandBy) {
            qDebug() << "remove from standby" << endl;
            system("gconftool-2 -t string -s /desktop/meego/screen_lock/low_power_mode/operator_logo /opt/SecurityPhone/base/standby-nothing.png");
        }

        qDebug() << "ICON UPDATE" << endl;
        system("cat /opt/SecurityPhone/base/settings.desktop >/usr/share/applications/SecurityPhone_harmattan.desktop");

        qDebug() << "power button overwrite - restore default settings" << endl;
        QProcess *proc = new QProcess();
        proc->start("sh /opt/SecurityPhone/base/deactivation.sh");

        exit(0);
    }
}

void SecurityService::loadConfiguration()
{
    GConfItem*  config = new GConfItem("/apps/ControlPanel/SecurityPhone/Sound");
    cSound = config->value().toInt();

    config = new GConfItem("/apps/ControlPanel/SecurityPhone/Vibration");
    cVibration = config->value().toInt();

    config = new GConfItem("/apps/ControlPanel/SecurityPhone/StandBy");
    cStandBy = config->value().toInt();

    config = new GConfItem("/apps/ControlPanel/SecurityPhone/Anonym");
    cAnonym = config->value().toInt();

    config = new GConfItem("/apps/ControlPanel/SecurityPhone/EMailNotification");
    cMail = config->value().toInt();

    config = new GConfItem("/apps/ControlPanel/SecurityPhone/EMail");
    cMailAddress = config->value().toString();

    config = new GConfItem("/apps/ControlPanel/SecurityPhone/GPS");
    cGPS = config->value().toInt();

    config = new GConfItem("/apps/ControlPanel/SecurityPhone/Camera");
    cCamera = config->value().toInt();

    config = new GConfItem("/apps/ControlPanel/SecurityPhone/PasswordType");
    cPasswordType = config->value().toInt();
}

void SecurityService::volumeMaximized()
{
    qDebug() << "volume maximized optimalization" << endl;
    if(!increaseVolume())
        qDebug() << "error volume setup" << endl;
}

bool SecurityService::playbackState()
{
    qDebug() << "playbackState" << endl;
    QDBusInterface dbus_iface(DBUS_MUSIC_SERVICE, DBUS_MUSIC_PATH, DBUS_MUSIC_INTERFACE);
    QDBusReply<int> reply = dbus_iface.call(DBUS_PBSTATE);
    if (reply.isValid())
        if (reply.value()==1)
            return true;
    // when reply.value()==0 || reply.value()==2
    return false;
}

bool SecurityService::increaseVolume()
{
    if(!playbackState())
        qDebug() << "failed open" << endl;

    QDBusInterface dbus_iface(DBUS_MAFW_SERVICE, DBUS_MAFW_PATH, DBUS_MAFW_INTERFACE);
    //  get current volume
    /* QDBusMessage reply = dbus_iface.call(DBUS_MAFW_GETPROPERTY, "volume");
    if(reply.type() == QDBusMessage::ErrorMessage)
        return false;

    QDBusVariant v = reply.arguments().at(1).value<QDBusVariant>();
    uint volume = v.variant().toUInt();
    uint newvolume = volume + 4;
    if(newvolume > 100)
        newvolume = 100;
*/
    QDBusReply<bool> r = dbus_iface.call(DBUS_MAFW_SETPROPERTY, "volume", QVariant::fromValue(QDBusVariant(100)));
    return r.value();
}

/*
void SecurityService::volumeMaximized(){
    qDebug() << "volume maximized optimalization started, because the trigger send the signal" << endl;

    if(playbackState()){
        QDBusInterface dbus_iface(DBUS_MAFW_SERVICE, DBUS_MAFW_PATH, DBUS_MAFW_INTERFACE);
       //  get current volume
        QDBusMessage reply = dbus_iface.call(DBUS_MAFW_GETPROPERTY, "volume");
        if(reply.type() != QDBusMessage::ErrorMessage){
            QDBusVariant v = reply.arguments().at(1).value<QDBusVariant>();
            uint volume = v.variant().toUInt();

            qDebug() << "ACTUAL VOLUME:" << volume << endl;
            if(volume != 100){
                qDebug() << "NEED MORE MORE VOLUME!!! MUHAHAHAHA!!!" << endl;

                if(!increaseVolume())
                    qDebug() << "error volume setup" << endl;
            }
        } else {
            qDebug() << "QDBusMessage::ErrorMessage"<<endl;
        }
    } else {
        qDebug() << "failed open" << endl;
    }
}

bool SecurityService::playbackState() {
     qDebug() << "playbackState" << endl;
    QDBusInterface dbus_iface(DBUS_MUSIC_SERVICE, DBUS_MUSIC_PATH, DBUS_MUSIC_INTERFACE);
    QDBusReply<int> reply = dbus_iface.call(DBUS_PBSTATE);
    if (reply.isValid())
        if (reply.value()==1)
            return true;
    // when reply.value()==0 || reply.value()==2
    return false;
}

bool SecurityService::increaseVolume() {
    QDBusInterface dbus_iface(DBUS_MAFW_SERVICE, DBUS_MAFW_PATH, DBUS_MAFW_INTERFACE);
    QDBusReply<bool> r = dbus_iface.call(DBUS_MAFW_SETPROPERTY, "volume", QVariant::fromValue(QDBusVariant(100)));
    return r.value();
}
*/

/*
#define BUTTON_POWER_UDI  "/org/freedesktop/Hal/devices/computer_logicaldev_input"

static void condition_cb(LibHalContext *ctx, const char *udi, const char *name, const char *detail);

int powerButton()
{
    LibHalContext *ctx = NULL;
    DBusConnection *conn = NULL;
    GMainLoop *main_loop = NULL;
    DBusError err;

    dbus_error_init(&err);
    conn = dbus_bus_get(DBUS_BUS_SYSTEM, &err);
    if (conn == NULL) {
        g_print("dbus get failed %s\n", err.message);
    }
    dbus_connection_setup_with_g_main(conn, NULL);

    if ((ctx = libhal_ctx_new()) == NULL) {
        g_print("libhal_ctx_new failed\n");
        return -1;
    }

    if(!libhal_ctx_set_dbus_connection(ctx, conn))
    {
        g_print("set dbus connection failed\n");
        return -1;
    }

    if (!libhal_ctx_set_device_condition(ctx, condition_cb)) {
        g_print("set device condition failed\n");
        return -1;
    }

    dbus_error_init(&err);
    if (!libhal_ctx_init(ctx, &err)) {
       g_print("Hal init error %s \n", err.message);
       return -1;
    }

    dbus_error_init(&err);
    if (!libhal_device_add_property_watch(ctx, BUTTON_POWER_UDI, &err)) {
        g_print("Failed to add property watch to power button %s\n", err.message);
        return -1;
    }

    main_loop = g_main_loop_new(NULL, TRUE);
    g_main_loop_run(main_loop);
}

static void condition_cb(LibHalContext *ctx, const char *udi, const char *name, const char *detail)
{
    g_print("udi is %s, name is %s, detail is %s\n", udi, name, detail);
    if (!strcmp(name, "ButtonPressed") && !strcmp(detail, "power"))
        g_print("power button pressed\n");
}*/
