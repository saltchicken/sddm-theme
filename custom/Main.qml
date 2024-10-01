/***************************************************************************
* Copyright (c) 2013 Abdurrahman AVCI <abdurrahmanavci@gmail.com>
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge,
* publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
* OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
* ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
* OR OTHER DEALINGS IN THE SOFTWARE.
*
***************************************************************************/

import QtQuick 2.0
import SddmComponents 2.0



Rectangle {
    id: container
    width: 640
    height: 480

    property color primaryShade : config.primaryShade ? config.primaryShade : "#303f11"
	  property color primaryLight : config.primaryLight ? config.primaryLight : "#303f11"
	  property color primaryDark  : config.primaryDark  ? config.primaryDark  : "#303f11"

	  property color primaryHue1  : config.primaryHue1  ? config.primaryHue1  : "#303f11"
	  property color primaryHue2  : config.primaryHue2  ? config.primaryHue2  : "#303f11"
	  property color primaryHue3  : config.primaryHue3  ? config.primaryHue3  : "#303f11"

	  property color accentShade  : config.accentShade  ? config.accentShade  : "#FF4081"
	  property color accentLight  : config.accentLight  ? config.accentLight  : "#FF80AB"

	  property color accentHue1   : config.accentHue1   ? config.accentHue1   : "#FF669A"
	  property color accentHue2   : config.accentHue2   ? config.accentHue2   : "#FF4081"
	  property color accentHue3   : config.accentHue3   ? config.accentHue3   : "#E73677"

	  property color normalText   : config.normalText   ? config.normalText   : "#1a1b26"

	  property color successText  : config.successText  ? config.successText  : "#43a047"
	  property color failureText  : config.failureText  ? config.failureText  : "#e53935"
	  property color warningText  : config.warningText  ? config.warningText  : "#ff8f00"

	  property color rebootColor  : config.rebootColor  ? config.rebootColor  : "#fb8c00"
	  property color powerColor   : config.powerColor   ? config.powerColor   : "#ff1744"

    property color darkText     : "#10260a"
    property color lightText     : "#334d66"

	  readonly property color defaultBg : primaryShade ? primaryShade : "#303f11"

    readonly property color textBoxBg : primaryHue2 ? primaryHue2 : "#FFFFFF"
    readonly property color textBoxText : darkText ? darkText : "#000000"

    readonly property color buttonBg : "#204218"
    readonly property color textBoxBorder : "#14290f"
    readonly property color textBoxFocus : "#146600"

    readonly property color arrowBoxColor: "#00250f"

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int sessionIndex: session.index

    TextConstants { id: textConstants }

    Connections {
        target: sddm

        onLoginSucceeded: {
            errorMessage.color = "steelblue"
            errorMessage.text = textConstants.loginSucceeded
        }

        onLoginFailed: {
            password.text = ""
            errorMessage.color = "red"
            errorMessage.text = textConstants.loginFailed
        }
        onInformationMessage: {
            errorMessage.color = "red"
            errorMessage.text = message
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
        anchors.fill: parent
        color: "transparent"
        //visible: primaryScreen

        Clock {
            id: clock
            anchors.margins: 5
            anchors.top: parent.top; anchors.right: parent.right

            color: "black"
            timeFont.family: "Oxygen"
        }

        Image {
            id: rectangle
            anchors.centerIn: parent
            //Width of the rectangle box
            width: Math.max(320, mainColumn.implicitWidth + 50)
            height: Math.max(320, mainColumn.implicitHeight + 50)

            source: "rectangle2.png"

            Column {
                id: mainColumn
                anchors.centerIn: parent
                spacing: 12
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "black"
                    verticalAlignment: Text.AlignVCenter
                    height: text.implicitHeight
                    width: parent.width
                    text: textConstants.welcomeText.arg(sddm.hostName)
                    wrapMode: Text.WordWrap
                    font.pixelSize: 24
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                }

                Column {
                    width: parent.width
                    spacing: 4
                    Text {
                        id: lblName
                        width: parent.width
                        text: textConstants.userName
                        font.bold: true
                        font.pixelSize: 12
                    }

                    TextBox {
                        id: name
                        width: parent.width; height: 30
                        text: userModel.lastUser
                        font.pixelSize: 14

                        color       : textBoxBg
                        borderColor : textBoxBorder
                        focusColor  : textBoxFocus
                        hoverColor  : textBoxFocus
                        
                        textColor   : textBoxText

                        KeyNavigation.backtab: rebootButton; KeyNavigation.tab: password

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionIndex)
                                event.accepted = true
                            }
                        }
                    }
                }

                Column {
                    width: parent.width
                    spacing : 4
                    Text {
                        id: lblPassword
                        width: parent.width
                        text: textConstants.password
                        font.bold: true
                        font.pixelSize: 12
                    }

                    PasswordBox {
                        id: password
                        width: parent.width; height: 30
                        font.pixelSize: 14

                        color       : textBoxBg
                        borderColor : textBoxBorder
                        focusColor  : textBoxFocus
                        hoverColor  : textBoxFocus
                        KeyNavigation.backtab: name; KeyNavigation.tab: session

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionIndex)
                                event.accepted = true
                            }
                        }
                    }
                }

                Row {
                    spacing: 4
                    width: parent.width / 2
                    z: 100

                    Column {
                        z: 100
                        width: parent.width * 1.3
                        spacing : 4
                        anchors.bottom: parent.bottom

                        Text {
                            id: lblSession
                            width: parent.width
                            text: textConstants.session
                            wrapMode: TextEdit.WordWrap
                            font.bold: true
                            font.pixelSize: 12
                        }

                        ComboBox {
                            id: session
                            width: parent.width; height: 30
                            font.pixelSize: 14

                            arrowColor: arrowBoxColor
                            arrowIcon: "angle-down.png"

                            //padding : 0

                            color : textBoxBg
                            borderColor : textBoxBorder
                            focusColor : textBoxFocus
                            hoverColor : textBoxFocus


                            menuColor : textBoxBg

                            model: sessionModel
                            index: sessionModel.lastIndex

                            KeyNavigation.backtab: password; KeyNavigation.tab: layoutBox
                        }
                    }

                    Column {
                        z: 101
                        width: parent.width * 0.7
                        spacing : 4
                        anchors.bottom: parent.bottom

                        Text {
                            id: lblLayout
                            width: parent.width
                            text: textConstants.layout
                            wrapMode: TextEdit.WordWrap
                            font.bold: true
                            font.pixelSize: 12
                        }

                        LayoutBox {
                            id: layoutBox
                            width: parent.width; height: 30
                            font.pixelSize: 14

                            arrowColor: arrowBoxColor
                            arrowIcon: "angle-down.png"

                            color : textBoxBg
                            borderColor : textBoxBorder
                            focusColor : textBoxFocus
                            hoverColor : textBoxFocus

                            KeyNavigation.backtab: session; KeyNavigation.tab: loginButton
                        }
                    }
                }

                Column {
                    width: parent.width
                    Text {
                        id: errorMessage
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: textConstants.prompt
                        font.pixelSize: 10
                    }
                }

                Row {
                    spacing: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    property int btnWidth: Math.max(loginButton.implicitWidth,
                                                    shutdownButton.implicitWidth,
                                                    rebootButton.implicitWidth, 80) + 8
                    Button {
                        id: loginButton
                        text: textConstants.login
                        width: parent.btnWidth

                        color : buttonBg
                        textColor : darkText
                        activeColor : textBoxBg
                        pressedColor : textBoxFocus
                        borderColor : textBoxFocus

                        onClicked: sddm.login(name.text, password.text, sessionIndex)

                    //Rectangle {
                    //    id: main
                    //    width: parent.width - 2; height: parent.height - 2
                    //    anchors.centerIn: parent
                    //
                    //    color: parent.color
                    //    border.color: "black"
                    //    border.width: 1
                    //  }                       
                      KeyNavigation.backtab: layoutBox; KeyNavigation.tab: shutdownButton
                    }

                    Button {
                        id: shutdownButton
                        text: textConstants.shutdown
                        width: parent.btnWidth

                        color : buttonBg
                        textColor : darkText
                        activeColor : textBoxBg
                        pressedColor : textBoxFocus
                        borderColor : textBoxFocus

                        onClicked: sddm.powerOff()

                        KeyNavigation.backtab: loginButton; KeyNavigation.tab: rebootButton
                    }

                    Button {
                        id: rebootButton
                        text: textConstants.reboot
                        width: parent.btnWidth

                        color : buttonBg
                        textColor : darkText
                        activeColor : textBoxBg
                        pressedColor : textBoxFocus
                        borderColor : textBoxFocus

                        onClicked: sddm.reboot()

                        KeyNavigation.backtab: shutdownButton; KeyNavigation.tab: name
                    }
                }
            }
        }
    }




    Component.onCompleted: {
        if (name.text == "")
            name.focus = true
        else
            password.focus = true
    }
}
