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

#include <QOrientationSensor>
#include <QDebug>

#include "orientation.h"

Orientation::Orientation(QObject *parent)
    : QObject(parent)
{
    qDebug() << "Sarting sensores" << endl;

    m_rumble = new QFeedbackHapticsEffect();
    m_rumble->setAttackIntensity(0.0);
    m_rumble->setAttackTime(100);
    m_rumble->setIntensity(0.6);
    m_rumble->setDuration(300);
    m_rumble->setFadeTime(100);
    m_rumble->setFadeIntensity(0.+0);

    m_sensor = new QOrientationSensor(this);
    m_sensor->setActive(true);
    m_sensor->setProperty("alwaysOn",true);
    connect(m_sensor, SIGNAL(readingChanged()), SLOT(onReadingChanged()));

    m_sensor->start();
}

Orientation::~Orientation()
{
    delete m_sensor;
    delete m_rumble;
}

void Orientation::vibrate()
{
    m_rumble->start();
}

void Orientation::onReadingChanged()
{
    QOrientationReading* reading = m_sensor->reading();
    switch(reading->orientation())
    {
    case QOrientationReading::TopUp:
        qDebug() << "TopUp" << endl;
        vibrate();
        emit orientationChanged(QOrientationReading::TopUp);
        break;
    case QOrientationReading::TopDown:
        qDebug() << "TopDown" << endl;
        vibrate();
        emit orientationChanged(QOrientationReading::TopDown);
        break;
    case QOrientationReading::LeftUp:
        qDebug() << "LeftUp" << endl;
        vibrate();
        emit orientationChanged(QOrientationReading::LeftUp);
        break;
    case QOrientationReading::RightUp:
        qDebug() << "RightUp" << endl;
        vibrate();
        emit orientationChanged(QOrientationReading::RightUp);
        break;
    case QOrientationReading::FaceDown:
        qDebug() << "FaceDown" << endl;
        vibrate();
        emit orientationChanged(QOrientationReading::FaceDown);
        break;
    case QOrientationReading::FaceUp:
        qDebug() << "FaceUp" << endl;
        vibrate();
        emit orientationChanged(QOrientationReading::FaceUp);
        break;
    default:
        break;
    }
}
