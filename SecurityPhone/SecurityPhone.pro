# Add more folders to ship with the application, here
folder_01.source = base
DEPLOYMENTFOLDERS = folder_01

QT += declarative
CONFIG += meegotouch mobility link_pkgconfig

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
CONFIG += qdeclarative-boostable

MOBILITY += multimedia feedback sensors

PKGCONFIG += gq-gconf
# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    securityphone.cpp \
    orientation.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

#contains(MEEGO_EDITION,harmattan) {
#    desktopService.files = SecurityService.desktop
#    desktopService.path = /usr/share/applications
#    INSTALLS += desktopService
#}

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    qml/SettingsPage.qml \
    qml/SettingsFunctions.qml \
    qml/SettingsAdvance.qml \
    qml/SettingsAccount.qml \
    qml/Powersave.qml \
    qml/Mainwindow.qml \
    qml/MainPage.qml \
    qml/main.qml \
    qml/InformationFeedback.qml \
    qml/InformationExitActivator.qml \
    qml/InformationAnonym.qml \
    qml/AboutPage.qml


HEADERS += securityphone.h \
    orientation.h

RESOURCES += \
    resources.qrc
