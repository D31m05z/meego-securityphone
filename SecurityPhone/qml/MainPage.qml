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
import com.meego.extras 1.0

Page {
    id: irMAIN
    opacity: 0
    orientationLock:  PageOrientation.LockPortrait

    //----------------swipe---------------------------------
    MouseArea {
        id: mouseArea
        anchors.fill: main;

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
                if( oldX > mouseX) {
                    if(imainPage.status == PageStatus.Active){
                        console.log("loadSettings");
                        pageStack.push(settingsPage);
                    }
                } else {
                    if(imainPage.status == PageStatus.Active){
                        console.log("aboutPage");
                        pageStack.push(aboutPage);
                    }
                }
            }

            if( (mouseX>340 && mouseX<480) && (mouseY>740 && mouseY<854)){
                if(imainPage.status == PageStatus.Active){
                    console.log("settingsPage");
                    pageStack.push(settingsPage);
                }
            }else if( (mouseX>0 && mouseX<120) && (mouseY>740 && mouseY<854)){
                if(imainPage.status == PageStatus.Active){
                    console.log("aboutPage");
                    pageStack.push(aboutPage);
                }
            }
        }
    }
    //----------------swipe---------------------------------

    Image {
        id: main
        source:  "../images/background.png"
        anchors.fill: parent
    }

    Text {
        id: stateText
        text: activated ? ("Activating:" + countDown ) : "Deactivated"
        x: 10
        y: 60
        font.family: iFont.name
        font.pixelSize:50
    }

    Image {
        id: state
        source:  activated ? "../images/security_on.png" : "../images/security_off.png"
        x: 35
        y: 120
        MouseArea{
            id: state_change
            anchors.fill: parent
            onClicked: mySecurity.startService(true);
        }
    }

    Column {
        x:5
        y:250

        Text {
            font.pointSize: 30
            font.family: iFont.name
            textFormat: TextEdit.PlainText
            text: "==========\nInstructions\n=========="
            color:"black"
            font.bold: true
        }
        Text {
            font.pointSize: 18
            font.family: iFont.name
            textFormat: TextEdit.PlainText
            text: "1) Set up a password"
            color:"black"
            font.bold: true
        }
        Text {
            font.pointSize: 18
            font.family: iFont.name
            textFormat: TextEdit.PlainText
            text: "    in your Account"
            color:"black"
            font.bold: true
        }
        Text {
            font.pointSize: 18
            font.family: iFont.name
            text: "2) Configure sound/vibration"
            color:"black"
            font.bold: true
        }
        Text {
            font.pointSize: 18
            font.family: iFont.name
            text: "    and some notifications"
            color:"black"
            font.bold: true
        }
        Text {
            font.pointSize: 18
            font.family: iFont.name
            textFormat: TextEdit.RichText
            text: "3) Start the security service"
            color:"black"
            font.bold: true
        }
        Text {
            font.pointSize: 18
            font.family: iFont.name
            textFormat: TextEdit.RichText
            text: "   just by pushing the lock icon"
            color:"black"
            font.bold: true
        }
    }

    Column{
        x:5
        y:650

        Text {
            font.pointSize: 20
            font.family: iFont.name
            textFormat: TextEdit.RichText
            text: "    The program will automatically exit"
            color:"black"
            font.bold: true
        }
        Text {
            font.pointSize: 20
            font.family: iFont.name
            textFormat: TextEdit.RichText
            text: "    and activate the system."
            color:"black"
            font.bold: true
        }
    }

    states: [
        State {
            name: "begin"
            when: irMAIN.visible
            PropertyChanges {
                target: irMAIN
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
