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
    id: accountID

    orientationLock:  PageOrientation.LockPortrait

    clip: true

    property alias backgroundImage:  background.source
    x: -changeX/2

    property real oldX: 0
    property real oldY: 0
    property real changeX: 0
    property bool mousePressed: false
    property bool pressOK: false
    property bool havePassword

    property string pass1;
    property string pass2;
    property string message;
    property string dialogColor

    Dialog {
        id: dialog
        title: Rectangle {
            id: warningTitle
            height: 2
            width: parent.width
            color: dialogColor
        }

        content:Item {
            id: messageItem
            height: 50
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: 50
            Text {
                id: messageText
                font.pixelSize: 22
                anchors.centerIn: parent
                color: "white"
                width: parent.width
                wrapMode: Text.WordWrap
                text: message
            }
        }

        buttons: ButtonRow {
            style: ButtonStyle { }
            anchors.top: parent.top
            anchors.topMargin: 110


            Button {
                text: "OK"; onClicked:{
                    dialog.accept()
                }
            }
        }
    }

    Dialog {
        id: itemEditorQ
        title: Item {
            id: titleField
            height: itemEditorQ.platformStyle.titleBarHeight
            width: parent.width
            Image {
                id: supplement
                source: "../images/standby-warning.png"
                fillMode: Image.PreserveAspectFit
                anchors.leftMargin: 5
                anchors.rightMargin: 5
            }

            Label {
                id: titleLabel
                anchors.left: supplement.right
                anchors.verticalCenter: titleField.verticalCenter
                font.capitalization: Font.MixedCase
                color: "red"
                text: "WARNING!"
            }

            Image {
                id: closeButton
                anchors.verticalCenter: titleField.verticalCenter
                anchors.right: titleField.right

                source: "image://theme/icon-m-common-dialog-close"

                MouseArea {
                    id: closeButtonArea
                    anchors.fill: parent
                    onClicked:  { itemEditorQ.reject(); }
                }
            }
        }

        content:Item {
            id: name
            height: childrenRect.height
            anchors.top: parent.top
            anchors.topMargin: 60
            anchors.left: parent.left
            anchors.leftMargin: -20
            Text {
                id: text
                font.pixelSize: 25
                color: "white"
                text: "Are you sure that you remember\nthe password correctly?\nIf you forget it, you can't turn off\nthe security service!"
            }
        }

        buttons: ButtonColumn {
            platformStyle: ButtonStyle { }
            // anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 80
            Button {
                id: b2;
                text: "Oops, I forgot already :)";
                onClicked: {
                    itemEditorQ.reject()
                }
            }

            Button {
                id: b1;
                text: "Yes, I will remember it!";
                onClicked:{
                    itemEditorQ.reject();

                    dialogColor = "red";
                    message =  "If you could not enter the password correctly for the first time, the device will allow you to retry after a few seconds of vibrating continuously.";
                    dialog.open();

                    console.log("settingsPage");
                    if(isPassRecording)
                        mySecurity.stopPasswordRecord();

                    mySecurity.setPasswordType(useTypeUnlock);

                    mySecurity.orientationEnable(false);
                    pageStack.pop(settingsPage);
                }
            }
        }
    }

    Image {
        id: background
        anchors.fill: parent
        z: -1
        opacity:  15/Math.abs(changeX)

        //----------------swipe---------------------------------
        MouseArea {
            anchors.fill: background


            onPressed: {
                oldX = mouseX;
                oldY = mouseY;

                if(mouseY>115){
                    mousePressed = true;
                }
            }

            onReleased: {
                var xDiff = oldX - mouseX;
                var yDiff = oldY - mouseY;
                if(mouseY<115){
                    if( Math.abs(xDiff) > Math.abs(yDiff) ) {
                        if( oldX < mouseX) {
                            if(settingAccount.status == PageStatus.Active){
                                itemEditorQ.open();
                            }
                        } else {
                            if(isPassRecording)
                                mySecurity.stopPasswordRecord();

                            useTypeUnlock = !useTypeUnlock;

                            mousePressed = false;
                            changeX = 0;
                        }
                    }

                    if(mouseX<150){
                        if(settingAccount.status == PageStatus.Active){
                            itemEditorQ.open();
                        }
                    } else if(mouseX>340){
                        if(isPassRecording)
                            mySecurity.stopPasswordRecord();

                        useTypeUnlock = !useTypeUnlock;

                        mousePressed = false;
                        changeX = 0;
                    }
                }

                changeX = 0;
            }

            onMouseXChanged: {
                if(mousePressed){
                    changeX =  oldX-mouseX;

                    if(changeX>=250) {
                        console.log("share");
                        if(isPassRecording)
                            mySecurity.stopPasswordRecord();

                        useTypeUnlock = !useTypeUnlock;

                        mousePressed = false;
                        changeX = 0;
                    }
                    else if(changeX<=-250){
                        console.log("edit");
                        if(isPassRecording)
                            mySecurity.stopPasswordRecord();

                        useTypeUnlock = !useTypeUnlock;

                        mousePressed = false;
                        changeX = 0;
                    }
                }
            }
        }
    }

    Item{
        id:useOrientation
        visible: !useTypeUnlock
        opacity:  15/Math.abs(changeX)

        Image{
            id: settings_items
            x:50
            y:200
            source: actualStateImg
        }

        Button {
            id: recordPassword;
            x:70
            y:500
            text: isPassRecording ? "finish" : "record your password";
            font.family: iFont.name

            onClicked: {
                if(isPassRecording)
                    mySecurity.stopPasswordRecord();
                else
                    mySecurity.startPasswordRecord();
            }
        }

        Text {
            x:5
            y:100

            font.family: iFont.name
            font.pixelSize: 40
            text: password;
        }

        Text {
            x:15
            y:542

            font.family: iFont.name
            font.pixelSize: 50
            color: "red"
            text: "please turn the phone\nFACE UP,and push the button\nto record your password";
        }
    }

    Item{
        id:useType
        visible: useTypeUnlock
        opacity:  15/Math.abs(changeX)

        Text {
            x:25
            y:150

            font.family: iFont.name
            font.pixelSize: 60
            text: "Set up your password";
        }

        SipAttributes {
            id:customSipAttributes
            actionKeyEnabled: true
            actionKeyHighlighted: true
            actionKeyLabel: "enter"
        }

        TextField{
            id:numberPasswordText1
            visible: true
            x: 40
            y:250
            width:340
            text: ""

            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText

            platformSipAttributes:customSipAttributes
            placeholderText: havePassword? "type your OLD password" : "type your password"

            Keys.onReturnPressed: {
                console.log("Return Key Pressed");
                pressOK = true;
                useType.forceActiveFocus();
            }

            onActiveFocusChanged: {
                console.log("onActiveFocusChanged");

                // if(numberPasswordText1.text != ""){
                //      pass1 = numberPasswordText1.text;
                //  }

                if(numberPassword == "") {
                    havePassword = false;

                    if(pressOK) {
                        pass1 = numberPasswordText1.text;
                    } else {
                        pass1 = numberPasswordText1.text;
                        numberPassword = "";
                    }
                } else {
                    havePassword = true;
                    console.log("old password need");

                    if(pressOK) {
                        if(numberPassword == numberPasswordText1.text) {
                            console.log("old password entered");

                            numberPasswordText1.text = "";
                            numberPassword = "";
                            havePassword = false;

                            dialogColor = "green";
                            message = "Old password entered. Now you can change the password!";
                            dialog.open();
                        } else {
                            dialogColor = "red";
                            message = "Wrong password!"
                            dialog.open();
                        }
                    }
                }
                pressOK = false;
            }
        }

        TextField {
            id:numberPasswordText2
            visible: true
            x: 40
            y:310
            width:340
            text: ""

            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText

            platformSipAttributes:customSipAttributes
            placeholderText: havePassword? "type your OLD password" : "type your password again"

            Keys.onReturnPressed: {
                console.log("Return Key Pressed");
                pressOK = true;
                useType.forceActiveFocus();
            }

            onActiveFocusChanged: {
                console.log("onActiveFocusChanged");
                if(numberPassword == ""){
                    havePassword = false;

                    if(pressOK) {
                        pass2 = numberPasswordText2.text;
                        if(pass1 == pass2) {
                            numberPassword = pass1;

                            mySecurity.switchPassword(numberPasswordText2.text);
                            //Titok óriási titok!!! :D
                            numberPasswordText1.text = "titokoriasititok";
                            numberPasswordText2.text = "titokoriasititok";

                            dialogColor = "green";
                            message = "Password changed!";
                            dialog.open();
                        } else {
                            dialogColor = "red";
                            message = "Wrong password!"
                            dialog.open();
                        }
                    } else {
                        pass2 = numberPasswordText2.text;
                        numberPassword = "";
                    }
                } else {
                    havePassword = true;
                    console.log("old password need");

                    if(pressOK) {
                        if(numberPassword == numberPasswordText1.text) {
                            console.log("old password entered");

                            numberPasswordText2.text = "";
                            numberPassword = "";
                            havePassword = false;

                            dialogColor = "green";
                            message = "Old password entered. Now you can change the password!";
                            dialog.open();
                        } else {
                            dialogColor = "red";
                            message = "Wrong password!"
                            dialog.open();
                        }
                    }

                }
                pressOK = false;
            }
        }
    }

    Text {
        id:switchModeText
        opacity: Math.abs(changeX)/5
        font.family: iFont.name
        font.pixelSize: 60

        x:changeX/2 + 5
        y:300
        color:"white"
        text : "<< Switch unlock mode >>"
    }

    Behavior on x {
        SpringAnimation {
            spring: 2
            damping: 0.2
        }
    }

    // Text {  font.pointSize: 40; text: "Security Phone 2013"; anchors.bottom: parent.bottom; anchors.bottomMargin: 40; anchors.horizontalCenterOffset: 0; font.bold: true; verticalAlignment: Text.AlignTop; horizontalAlignment: Text.AlignHCenter; anchors.horizontalCenter: parent.horizontalCenter; font.family: iFont.name; color:"#bbb"}
    // Text {  font.pointSize: 20; text: "developer: Gergely Boross | aFagylaltos(c)"; anchors.bottom: parent.bottom; anchors.bottomMargin: 20; anchors.horizontalCenterOffset: 0; font.bold: false; verticalAlignment: Text.AlignTop; horizontalAlignment: Text.AlignHCenter; anchors.horizontalCenter: parent.horizontalCenter; font.family: iFont.name; color:"#bbb"}
}
