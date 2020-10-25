/**************************************************************************
* SDDM Theme RZ-Amper                                                     *
***************************************************************************
* Copyright © 2020 Waldemar Schroeer                                      *
*                  waldemar.schroeer(at)rz*amper.de                       *
**************************************************************************/

import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: container
    property int sessionIndex: chooserSessionComboBox.index
    TextConstants { id: textConstants }
    Connections {
        target: sddm
        onLoginSucceeded: {
            errorMsgText.color = "steelblue"
            errorMsgText.text = textConstants.loginSucceeded
        }
        onLoginFailed: {
            passwordBox.text = ""
            errorMsgText.color = "red"
            errorMsgText.text = "Please try again."
        }
    }

    Background {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            if (status == Image.Error && source != config.defaultBackground) {
                source = config.defaultBackground
            }
        }
    }

    Rectangle {
        id: canvas
        anchors.fill: parent
        color: "transparent"
        visible: primaryScreen

        Clock {
            id: clock
            anchors.margins: 50
            anchors.top: canvas.top; anchors.right: canvas.right
            color: "white"
            timeFont.family: "Oxygen"
        }

        Image {
            id: loginBackground
            width: Math.max(mainColumn.width) + 80
            height: Math.max(mainColumn.height) + 80
            anchors.horizontalCenter: canvas.horizontalCenter
            anchors.bottom: canvas.bottom
            anchors.bottomMargin: Math.max(parent.height * 0.1)
            source: "rectangle.png"

            Column {
                id: mainColumn
                width: 500
                height: 300
                anchors.centerIn: loginBackground
                spacing: 12

                Column {
                    id: welcomeTextCol
                    width: parent.width
                    spacing: 10
                    Text {
                        id: welcomeText
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "#505050"
                        font.bold: true
                        font.pixelSize: 24
                        text: "Rechenzentrum Amper"
                    }
                }
                Column {
                    id: userNameCol
                    width: parent.width
                    spacing: 4
                    Text {
                        id: userNameText
                        anchors.left: parent.left
                        font.bold: true
                        font.pixelSize: 12
                        text: "Put in your user name"
                    }
                    TextBox {
                        id: userNameTextBox
                        width: parent.width
                        height: 35
                        anchors.left: parent.left
                        font.pixelSize: 20
                        text: userModel.lastUser
                        KeyNavigation.backtab: loginRowButton; KeyNavigation.tab: passwordBox
                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(userNameTextBox.text, passwordBox.text, sessionIndex)
                                event.accepted = true }
                        }
                    }
                }
                Column {
                    id: passwordCol
                    spacing: 4
                    width: parent.width
                    Text {
                        id: passwordText
                        anchors.left: parent.left
                        font.bold: true
                        font.pixelSize: 12
                        text: "Put in your password"
                    }
                    PasswordBox {
                        id: passwordBox
                        width: parent.width
                        height: 35
                        anchors.left: parent.left
                        font.pixelSize: 20
                        KeyNavigation.backtab: userNameTextBox; KeyNavigation.tab: chooserSessionComboBox
                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(userNameTextBox.text, passwordBox.text, sessionIndex)
                                event.accepted = true }
                        }
                    }
                }
                Row {
                    id: chooserRow
                    z: 100
                    spacing: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: Math.max(parent.width * 0.8)
                    Column {
                        id: chooserSessionCol
                        z: 100
                        spacing: 4
                        width: Math.max(parent.width * 0.7)
                        anchors.bottom: parent.bottom
                        Text{
                            id: chooserSessionText
                            anchors.left: parent.left
                            font.bold: true
                            font.pixelSize: 12
                            text: "Choose your session"
                        }
                        ComboBox {
                            id: chooserSessionComboBox
                            width: parent.width; height: 30
                            font.pixelSize: 14
                            arrowIcon: "angle-down.png"
                            model: sessionModel
                            index: sessionModel.lastIndex
                            KeyNavigation.backtab: passwordBox; KeyNavigation.tab: chooserLayoutBox
                        }
                    }
                    Column {
                        id: chooserLayoutCol
                        z: 101
                        spacing: 4
                        width: Math.max(parent.width * 0.3)
                        anchors.bottom: parent.bottom
                        Text {
                            id: chooserLayoutText
                            anchors.left: parent.left
                            font.bold: true
                            font.pixelSize: 12
                            text: "Layout"
                        }
                        LayoutBox {
                            id: chooserLayoutBox
                            width: parent.width; height: 30
                            font.pixelSize: 14
                            arrowIcon: "angle-down.png"
                            KeyNavigation.backtab: chooserSessionComboBox; KeyNavigation.tab: loginRowButton
                        }
                    }
                }
                Column {
                    id: errorMsgCol
                    spacing: 4
                    width: parent.width
                    Text {
                        id: errorMsgText
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 10
                        text: textConstants.prompt
                    }
                }
                Row {
                    id: loginRow
                    spacing: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                        Button {
                            id: loginRowButton
                            color: "#0211a8"
                            text: "Login"
                            onClicked: sddm.login(userNameTextBox.text, passwordBox.text, sessionIndex)
                            KeyNavigation.backtab: chooserLayoutBox; KeyNavigation.tab: userNameTextBox
                        }
                }
            }
        }
    }



    Component.onCompleted: {
        if (userNameTextBox.text == "")
            userNameTextBox.focus = true
        else
            passwordBox.focus = true
    }
}
