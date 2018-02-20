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

import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: aboutID
    opacity: 0

    orientationLock:  PageOrientation.LockPortrait

    clip: true

    property alias backgroundImage:  background.source


    QueryDialog {
        opacity: 0.5
        id: youTube
        icon: "../images/youtube.png"
        titleText: "SecurityPhone for Nokia N9 loading"
        message: "Please wait...\n"
        acceptButtonText: "Ok"
        onAccepted: {
            youTube.close();
        }
    }

    Image {
        id: background
        anchors.fill: parent
        z: -1

        //----------------swipe---------------------------------
        MouseArea {
            anchors.fill: background
            property int oldX: 0
            property int oldY: 0

            onPressed: {
                oldX = mouseX;
                oldY = mouseY;
            }

            onReleased: {
                var xDiff = oldX - mouseX;
                var yDiff = oldY - mouseY;
                if( Math.abs(xDiff) > Math.abs(yDiff) ) {
                    if( oldX < mouseX) {
                        if(aboutPage.status == PageStatus.Active){
                            console.log("imainPage");
                            pageStack.pop(imainPage);
                        }
                    }
                }

                if(mouseY<115 && mouseX<150){
                    if(aboutPage.status == PageStatus.Active){
                        console.log("imainPage");
                        pageStack.pop(imainPage);
                    }
                }
            }
        }
        //----------------swipe---------------------------------
    }

    Column {
        x:20
        y:270

        Text {
            font.pointSize: 25
            font.family: iFont.name
            text: "This app is capable of protecting\n  the device itself and other\n    objects placed below it.\n"
            color: "red"
            font.bold: true
        }
    }

    Text {
        x:30
        y:545
        font.pointSize: 35
        font.family: iFont.name
        text: "Here is a video of the usage:"
        color: "red"
        enabled: false
    }

    Image {
        id: showYouTbe
        source: "../images/youtube.png"
        x:180
        y:600
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                Qt.openUrlExternally("http://youtu.be/wu-T9a7-YeM");
                youTube.open();
            }
        }
    }

    Text {  font.pointSize: 40; text: "Security Phone 2013"; anchors.bottom: parent.bottom; anchors.bottomMargin: 40; anchors.horizontalCenterOffset: 0; font.bold: true; verticalAlignment: Text.AlignTop; horizontalAlignment: Text.AlignHCenter; anchors.horizontalCenter: parent.horizontalCenter; font.family: iFont.name; color:"#bbb"}
    Text {  font.pointSize: 20; text: "developer: Gergely Boross | aFagylaltos(c)"; anchors.bottom: parent.bottom; anchors.bottomMargin: 20; anchors.horizontalCenterOffset: 0; font.bold: false; verticalAlignment: Text.AlignTop; horizontalAlignment: Text.AlignHCenter; anchors.horizontalCenter: parent.horizontalCenter; font.family: iFont.name; color:"#bbb"}

    states: [
        State {
            name: "begin"
            when: aboutID.visible
            PropertyChanges {
                target: aboutID
                opacity: 1
            }
        }
    ]
    transitions: [
        Transition {
            from: "*"
            to: "begin"
            PropertyAnimation { properties: "opacity"; duration: 800 }
        }
    ]
}
