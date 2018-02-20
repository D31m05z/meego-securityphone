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
    id: advanceID
    opacity: 0

    orientationLock:  PageOrientation.LockPortrait

    clip: true

    property alias backgroundImage:  background.source
    property bool pressOK : false

    function changeShowInput() {
        showInput =!showInput;

        advanceID.opacity = 0;

        if(showInput)
            advanceID.state = "showInput"
        else
            advanceID.state = "hideInput"
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
                        if(settingsAdvance.status == PageStatus.Active){
                            console.log("settingsPage");
                            pageStack.pop(settingsPage);
                        }
                    }
                }

                if(mouseY<115 && mouseX<150){
                    if(settingsAdvance.status == PageStatus.Active){
                        console.log("settingsPage");
                        pageStack.pop(settingsPage);
                    }
                }
            }
        }
        //----------------swipe---------------------------------
    }

    Grid {
        x:5
        y:150
        columns: 2
        spacing: 5
        visible: !showInput

        Switch {
            id: switchSound
            checked: sound;
            onCheckedChanged: {
                if(switchSound.checked){
                    if(switchAnonym.checked){
                        mySecurity.showBanner("Warning! Anonym  alarm is deactivating...");
                        switchAnonym.checked = false;
                        mySecurity.switchAnonym(false);
                    }
                }
                mySecurity.switchSound(switchSound.checked)
            }
        }
        Text {
            text: switchSound.checked ? "Sound on" : "Sound off"
            font.pixelSize: 40
            font.family: iFont.name
            color: "black"
        }

        Switch {
            id: switchVibration
            checked: vibration;
            onCheckedChanged: {
                if(switchVibration.checked) {
                    if(switchAnonym.checked) {
                        mySecurity.showBanner("Warning! Anonym  alarm is deactivating...");
                        switchAnonym.checked = false;
                        mySecurity.switchAnonym(false);
                    }
                }
                mySecurity.switchVibration(switchVibration.checked);
            }
        }
        Text {
            verticalAlignment: Text.AlignVCenter
            text: switchVibration.checked ? "Vibration on" : "Vibration off"
            font.pixelSize: 40
            font.family: iFont.name
            color: "black"
        }

        Switch {
            id: switchStandby
            checked: standby;
            onCheckedChanged: mySecurity.switchStandBy(switchStandby.checked)
        }
        Text {
            text: switchStandby.checked ? "StandBy on" : "StandBy off"
            font.pixelSize: 40
            font.family: iFont.name
            color: "black"
        }

        Switch {
            id: switchAnonym
            checked: anonym;
            onCheckedChanged: {
                if(switchAnonym.checked) {
                    mySecurity.showBanner("Warning! Sound and Vibration disabled. Anonym alarm is activating...");
                    switchSound.checked = false;
                    switchVibration.checked = false;

                    mySecurity.switchSound(false);
                    mySecurity.switchVibration(false);
                }

                mySecurity.switchAnonym(switchAnonym.checked);
            }
        }

        Text {
            text: switchAnonym.checked ? "Anonym function on" : "Anonym function off"
            font.pixelSize: 40
            font.family: iFont.name
            color: "black"
        }

        Switch {
            id: switchMail
            checked: mail;
            onCheckedChanged: mySecurity.switchMail(switchMail.checked)
        }

        Text {
            text: switchMail.checked ? "Mail notification on" : "Mail notification off"
            font.pixelSize: 40
            font.family: iFont.name
            color: "black"
        }
    }

    SipAttributes {
        id:customSipAttributes
        actionKeyEnabled: true
        actionKeyHighlighted: true
        actionKeyLabel: "enter"
    }

    TextField {
        id:mailAddressEdit
        visible: mail
        x:showInput ? 80 : 10
        y:showInput ? 220 : 420
        width:300
        text:mailAddress

        platformSipAttributes:customSipAttributes
        placeholderText: "type your email address"

        Keys.onReturnPressed: {
            console.log("Return Key Pressed");
            pressOK = true;
            mailAddressEdit.closeSoftwareInputPanel();
            switchMail.forceActiveFocus();
        }
        onActiveFocusChanged: {

            console.log("onActiveFocusChanged");
            changeShowInput();

            if(pressOK)
                mySecurity.switchMailAddress(mailAddressEdit.text);
            else {
                mailAddressEdit.text = "";
                mailAddress = "";
            }
            pressOK = false;
        }
    }

    Text {
        id: enter
        visible: showInput
        x: 180
        y: 280
        font.pixelSize: 30
        font.family: iFont.name
        color: "black"
        text: qsTr("press enter")

    }

    ToolButton {
        id: informationFeedBackBt
        visible: !showInput
        flat: true
        iconSource: "../images/information-icon.png"
        x: 300
        y: 150

        onClicked: {
            console.log("informationFeedBack");
            pageStack.push(informationFeedback);
        }
    }

    ToolButton {
        id: informationAnonymusBtn
        visible: !showInput
        flat: true
        iconSource: "../images/information-icon.png"
        x: 300
        y: 320

        onClicked: {
            console.log("informationAnonym");
            pageStack.push(informationAnonym);
        }
    }

    Text { visible: !showInput; font.pointSize: 40; text: "Security Phone 2013"; anchors.bottom: parent.bottom; anchors.bottomMargin: 40; anchors.horizontalCenterOffset: 0; font.bold: true; verticalAlignment: Text.AlignTop; horizontalAlignment: Text.AlignHCenter; anchors.horizontalCenter: parent.horizontalCenter; font.family: iFont.name; color:"#bbb"}
    Text { visible: !showInput; font.pointSize: 20; text: "developer: Gergely Boross | aFagylaltos(c)"; anchors.bottom: parent.bottom; anchors.bottomMargin: 20; anchors.horizontalCenterOffset: 0; font.bold: false; verticalAlignment: Text.AlignTop; horizontalAlignment: Text.AlignHCenter; anchors.horizontalCenter: parent.horizontalCenter; font.family: iFont.name; color:"#bbb"}

    states: [
        State {
            name: "begin"
            when: advanceID.visible
            PropertyChanges {
                target: advanceID
                opacity: 1
            }
        },
        State {
            name: "showInput"
            PropertyChanges {
                target: advanceID
                opacity: 1
            }
        },
        State {
            name: "hideInput"
            PropertyChanges {
                target: advanceID
                opacity: 1
            }
        }
    ]
    transitions: [
        Transition {
            from: "*"
            to: "begin"
            PropertyAnimation { properties: "opacity"; duration: 800 }
        },
        Transition {
            //  NumberAnimation {properties:"topMargin" ; duration: 100 }
            PropertyAnimation { properties: "opacity"; duration: 500 }
        }
    ]
}
