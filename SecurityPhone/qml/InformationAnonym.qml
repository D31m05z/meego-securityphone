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
    id: anonymID
    opacity: 0

    orientationLock:  PageOrientation.LockPortrait

    clip: true

    property alias backgroundImage:  background.source

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
                        if(informationAnonym.status == PageStatus.Active){
                            console.log("settingsAdvance");
                            pageStack.pop(settingsAdvance);
                        }
                    }
                }

                if(mouseY<115 && mouseX<150){
                    if(informationAnonym.status == PageStatus.Active){
                        console.log("settingsAdvance");
                        pageStack.pop(settingsAdvance);
                    }
                }
            }
        }
        //----------------swipe---------------------------------
    }

    Column {
        x:10
        y:180

        Text {
            font.pointSize: 30
            font.family: iFont.name
            text: "  Switching this function on \n       disables the alarms\n so the unauthorized person\n        won't get notified\n                about it.\n    The notification will be\n    sent in the background."
            color: "red"
            font.bold: true
        }
    }

    Text {  font.pointSize: 40; text: "Anonym Function"; anchors.bottom: parent.bottom; anchors.bottomMargin: 40; anchors.horizontalCenterOffset: 0; font.bold: true; verticalAlignment: Text.AlignTop; horizontalAlignment: Text.AlignHCenter; anchors.horizontalCenter: parent.horizontalCenter; font.family: iFont.name; color:"#bbb"}
    Text {  font.pointSize: 20; text: "developer: Gergely Boross | aFagylaltos(c)"; anchors.bottom: parent.bottom; anchors.bottomMargin: 20; anchors.horizontalCenterOffset: 0; font.bold: false; verticalAlignment: Text.AlignTop; horizontalAlignment: Text.AlignHCenter; anchors.horizontalCenter: parent.horizontalCenter; font.family: iFont.name; color:"#bbb"}

    states: [
        State {
            name: "begin"
            when: anonymID.visible
            PropertyChanges {
                target: anonymID
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
