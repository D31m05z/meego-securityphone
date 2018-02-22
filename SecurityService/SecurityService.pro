#-------------------------------------------------
#
# Project created by QtCreator 2013-01-22T16:41:39
#
#-------------------------------------------------

TARGET = SecurityService
CONFIG += mobility meegotouch link_pkgconfig
PKGCONFIG += gq-gconf libresourceqt1 hal glib-2.0 dbus-glib-1
MOBILITY = multimedia feedback messaging sensors
QT     += gui network

TEMPLATE = app

SOURCES += main.cpp \
    SecurityService.cpp \
    orientation.cpp \
    powerbuttonlistener.cpp


HEADERS += SecurityService.h \
    orientation.h \
    powerbuttonlistener.h

contains(MEEGO_EDITION,harmattan) {
    target.path = /opt/SecurityService/bin
    INSTALLS += target
}
