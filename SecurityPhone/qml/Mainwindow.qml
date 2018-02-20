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
    id: mainwindow

    orientationLock:  PageOrientation.LockPortrait

    ///////////////////////////////////////////////////

    Dialog {
        id: itemEditorQ
        title: Item {
            id: titleField
            height: itemEditorQ.platformStyle.titleBarHeight
            width: parent.width
            Image {
                id: supplement
                source: "../images/security_off.png"
                height: parent.height - 10
                width: 75
                fillMode: Image.PreserveAspectFit
                anchors.leftMargin: 5
                anchors.rightMargin: 5
            }

            Label {
                id: titleLabel
                anchors.left: supplement.right
                anchors.verticalCenter: titleField.verticalCenter
                font.capitalization: Font.MixedCase
                color: "white"
                text: "Security system\nnot activated!"
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
            Text {
                id: text
                font.pixelSize: 22
                color: "white"
                text: "Are you sure exit?"
            }
        }

        buttons: ButtonRow {
            platformStyle: ButtonStyle { }
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                id: b1; text: "Activate and exit"; onClicked:{
                    itemEditorQ.reject();
                }
            }
            Button {id: b2; text: "just exit"; onClicked: {itemEditorQ.reject()}}
        }
    }

    PageStack {
        id: pageStack

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Image {
            id: black
            anchors.fill: parent
            source: "../images/black.png"
        }

        MainPage{
            id: imainPage
        }

        SettingsPage {
            id: settingsPage
            backgroundImage: "../images/settings-background.png"
        }

        AboutPage {
            id: aboutPage
            backgroundImage: "../images/information-background.png"
        }

        SettingsAccount {
            id: settingAccount
            backgroundImage: "../images/settings-background-solid_plusz.png"
        }

        SettingsFunctions {
            id: settingFunctions
            backgroundImage: "../images/settings-background-solid.png"
        }

        SettingsAdvance {
            id: settingsAdvance
            backgroundImage: showInput? "../images/settings-background-showInput.png" : "../images/settings-background-solid.png"
        }

        InformationAnonym {
            id: informationAnonym
            backgroundImage: "../images/information-background.png"
        }

        InformationFeedback {
            id: informationFeedback
            backgroundImage: "../images/information-background.png"
        }

        InformationExitActivator {
            id: informationExitActivator
            backgroundImage: "../images/information-background.png"
        }

        Powersave {
            id: suspend
        }
    }

    Component.onCompleted: {
        pageStack.push(imainPage);
        //   itemEditorQ.open();
    }

    Component.onDestruction: {
        console.log("--DESTRUCTOR");

        if(mySecurity.isPassRecording())
            mySecurity.stopPasswordRecord();

        if(exitActivator)
            mySecurity.startService(false);
    }

    function powerSaveON(){
        if(pageStack.currentPage!=suspend){
            pageStack.push(suspend);
            console.log("=====SUSPEND-SWITCH-==ON=======");

            if(mySecurity.isPassRecording())
                mySecurity.stopPasswordRecord();
        }
    }

    function powerSaveOFF(){
        if(pageStack.currentPage!=imainPage){
            mySecurity.orientationEnable(false);
            pageStack.push(imainPage);
            console.log("=====SUSPEND-SWITCH-==OFF======");
        }
    }

    states: [
        State {
            name: "fullsize-visible"
            when: platformWindow.viewMode == WindowState.Fullsize && platformWindow.visible
            StateChangeScript {
                script: {
                    powerSaveOFF();
                }
            }
        },
        State {
            name: "thumbnail-or-invisible"
            when: platformWindow.viewMode == WindowState.Thumbnail
            StateChangeScript {
                script: {
                    powerSaveON();
                }
            }
        }
    ]
}
