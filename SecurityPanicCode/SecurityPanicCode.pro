QT += declarative

CONFIG += meegotouch mobility link_pkgconfig

PKGCONFIG += gq-gconf
# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
CONFIG += qdeclarative-boostable

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    panic.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

HEADERS += \
    panic.h

RESOURCES += \
    resourcesPanic.qrc

OTHER_FILES += \
    qml/MainPage.qml \
    qml/main.qml
