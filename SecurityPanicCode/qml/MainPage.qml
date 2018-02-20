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
    id: page
    tools: commonTools
    orientationLock:  PageOrientation.LockPortrait

    property string title : "Security System activated!"

    Dialog {
        id: wrongPassword
        title: Rectangle {
            id: warningTilte2
            height: 2
            width: parent.width
            color: "red"

        }

        content:Item {
            id: name3
            height: 50
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: 50
            Text {
                id: text3
                font.pixelSize: 22
                anchors.centerIn: parent
                color: "white"
                width: parent.width
                wrapMode: Text.WordWrap
                text: "Wrong password!"
            }
        }

        buttons: ButtonRow {
            style: ButtonStyle { }
            anchors.top: parent.top
            anchors.topMargin: 110

            Button {
                text: "OK"; onClicked: {
                    wrongPassword.accept()
                }
            }
        }
    }

    Dialog {
        id: changedPassword
        title: Rectangle {
            id: warningTilte3
            height: 2
            width: parent.width
            color: "green"

        }

        content:Item {
            id: name4
            height: 50
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: 50
            Text {
                id: text5
                font.pixelSize: 22
                anchors.centerIn: parent
                color: "white"
                width: parent.width
                wrapMode: Text.WordWrap
                text: "Password ok!"
            }
        }

        buttons: ButtonRow {
            style: ButtonStyle { }
            anchors.top: parent.top
            anchors.topMargin: 110

            Button {
                text: "OK"; onClicked: {
                    changedPassword.accept()
                }
            }
        }
    }

    Dialog {
        id: oldPassword
        title: Rectangle {
            id: warningTilte4
            height: 2
            width: parent.width
            color: "red"
        }

        content:Item {
            id: name5
            height: 50
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: 50
            Text {
                id: text6
                font.pixelSize: 22
                anchors.centerIn: parent
                color: "white"
                width: parent.width
                wrapMode: Text.WordWrap
                text: "You need to unlock the device with orientation password."
            }
        }

        buttons: ButtonRow {
            style: ButtonStyle { }
            anchors.top: parent.top
            anchors.topMargin: 110

            Button {
                text: "OK"; onClicked: {
                    oldPassword.accept()
                }
            }
        }
    }

    Dialog {
        id: rename_dialog
        title: Item {
            id: titleField2
            height: rename_dialog.platformStyle.titleBarHeight
            width: parent.width

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: parent.top
                anchors.topMargin:20
                anchors.verticalCenter: titleField2.verticalCenter
                font.capitalization: Font.MixedCase
                color: "white"
                text: "Enter your password."
            }

            Image {
                anchors.verticalCenter: titleField2.verticalCenter
                anchors.right: titleField2.right

                source: "image://theme/icon-m-common-dialog-close"

                MouseArea {
                    anchors.fill: parent
                    onClicked:  { rename_dialog.reject(); }
                }
            }
        }

        content:Item {
            TextField {
                id: custom
                x:-40
                y: 15
                width:400

                placeholderText: "Enter your password"
                platformStyle: TextFieldStyle { paddingRight: clearButton.width }

                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText

                platformSipAttributes: SipAttributes {
                    actionKeyLabel: "enter"
                    actionKeyHighlighted: true
                }

                Image {
                    id: clearButton
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    source: "image://theme/icon-m-input-clear"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            //InputContext.reset();
                            custom.text = "";
                        }
                    }
                }

                Keys.onReturnPressed: {
                    if(custom.text==password) {
                        custom.closeSoftwareInputPanel();
                        rename_dialog.reject();
                        changedPassword.open();
                        myPanic.killService();
                    } else {
                        rename_dialog.reject();
                        custom.closeSoftwareInputPanel();
                        custom.text = "";
                        wrongPassword.open();
                    }
                }
            }
        }
    }

    Image {
        id: pageHeader
        anchors {
            top: page.top
            left: page.left
            right: page.right
        }

        height: parent.width < parent.height ? 72 : 46
        width: parent.width
        source: "image://theme/meegotouch-view-header-fixed" + (theme.inverted ? "-inverted" : "")
        z: 1

        Label {
            id: header
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: 16
            }
            platformStyle: LabelStyle {
                fontFamily: "Nokia Pure Text Light"
                fontPixelSize: 32
            }
            text: page.title
        }
    }

    Flickable {
        id: pageFlickableContent
        anchors {
            top: pageHeader.bottom
            bottom: page.bottom
            left: page.left
            right: page.right
            margins: 16
        }
        contentHeight: pageContent.height
        contentWidth: pageContent.width
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: pageContent

            width: page.width - pageFlickableContent.anchors.margins * 2
            spacing: 16

            Button {
                x:50
                text: qsTr("Unlock")
                onClicked: {
                    if(type)
                        rename_dialog.open();
                    else
                        oldPassword.open();
                }
            }
            Text {
                id: instruction
                font.pixelSize: 50
                width: 400
                wrapMode: Text.WordWrap
                text: qsTr("Need to enter your password for deactivating the security phone service.")
            }
        }
    }

    ScrollDecorator {
        flickableItem: pageFlickableContent
    }
}
