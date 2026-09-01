import QtQuick 2.15
import QtQuick.Controls 2.15
import SddmComponents 2.0

Rectangle {
    id: root

    width: 1920
    height: 1080

    color: "#050507"

    property color pink: "#F4D6D9"
    property color softPink: "#D8B7BB"
    property color fieldColor: "#171419"
    property color fieldBorder: "#59474D"

    // ========================================================
    // LOGIN
    // ========================================================

    function login() {
        sddm.login(
            userModel.lastUser,
            password.text,
            sessionModel.lastIndex
        )
    }

    // ========================================================
    // MAIN CONTENT
    // ========================================================

    Column {
        id: content

        anchors.centerIn: parent

        width: 520
        spacing: 0

        // ----------------------------------------------------
        // PORTRAIT
        // ----------------------------------------------------

        Item {
            width: parent.width
            height: 340

            Image {
                id: portrait

                width: 300
                height: 300

                anchors.horizontalCenter: parent.horizontalCenter

                source: "portrait.png"

                fillMode: Image.PreserveAspectFit

                smooth: true
                mipmap: true
            }
        }

        // ----------------------------------------------------
        // TITLE
        // ----------------------------------------------------

        Text {
            width: parent.width

            text: "✦ " + config.title + " ✦"

            horizontalAlignment: Text.AlignHCenter

            color: root.pink

            font.family: "Nunito"
            font.pixelSize: 42
            font.weight: Font.DemiBold
        }

        // ----------------------------------------------------
        // SUBTITLE
        // ----------------------------------------------------

        Text {
            width: parent.width

            topPadding: 8

            text: config.subtitle

            horizontalAlignment: Text.AlignHCenter

            color: root.softPink

            //font.family: "Noto Sans CJK JP"
            font.family: "Kosugi Maru"
            font.bold: true
            // font.weight: Font.Black
            font.pixelSize: 20
        }

        // spacing
        Item {
            width: 1
            height: 28
        }

        // ----------------------------------------------------
        // PASSWORD FIELD
        // ----------------------------------------------------

        Rectangle {
            width: 420
            height: 54

            anchors.horizontalCenter: parent.horizontalCenter

            radius: 27

            color: root.fieldColor

            border.width: password.activeFocus ? 2 : 1
            border.color:
                password.activeFocus
                ? root.pink
                : root.fieldBorder

            Behavior on border.color {
                ColorAnimation {
                    duration: 150
                }
            }

            TextInput {
                id: password

                anchors.fill: parent

                leftPadding: 24
                rightPadding: 24

                verticalAlignment: TextInput.AlignVCenter

                echoMode: TextInput.Password

                color: root.pink

                font.family: "Nunito"
                font.pixelSize: 18

                focus: true

                onAccepted: root.login()
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 24

                visible: password.text.length === 0

                text: "Password"

                color: "#806D73"

                font.family: "Nunito"
                font.pixelSize: 17
            }
        }

        Item {
            width: 1
            height: 14
        }

        // ----------------------------------------------------
        // LOGIN BUTTON
        // ----------------------------------------------------

        Rectangle {
            id: loginButton

            width: 420
            height: 48

            anchors.horizontalCenter: parent.horizontalCenter

            radius: 24

            color:
                loginMouse.containsMouse
                ? "#F8E1E3"
                : root.pink

            Behavior on color {
                ColorAnimation {
                    duration: 120
                }
            }

            Text {
                anchors.centerIn: parent

                text: "Login"

                color: "#241C20"

                font.family: "Nunito"
                font.pixelSize: 17
                font.weight: Font.DemiBold
            }

            MouseArea {
                id: loginMouse

                anchors.fill: parent

                hoverEnabled: true

                cursorShape: Qt.PointingHandCursor

                onClicked: root.login()
            }
        }

        // ----------------------------------------------------
        // LOGIN ERROR
        // ----------------------------------------------------

        Text {
            id: errorText

            width: parent.width

            topPadding: 14

            horizontalAlignment: Text.AlignHCenter

            color: "#E8A6AD"

            font.family: "Nunito"
            font.pixelSize: 14

            text: ""
        }
    }

    // ========================================================
    // SDDM MESSAGES
    // ========================================================

    Connections {
        target: sddm

        function onLoginFailed() {
            errorText.text = "Incorrect password"
            password.text = ""
            password.forceActiveFocus()
        }

        function onLoginSucceeded() {
            errorText.text = ""
        }
    }

    // ========================================================
    // CLOCK
    // ========================================================

    Text {
        anchors {
            top: parent.top
            right: parent.right
            topMargin: 30
            rightMargin: 38
        }

        color: "#806D73"

        font.family: "Nunito"
        font.pixelSize: 16

        text: Qt.formatTime(new Date(), "hh:mm AP")

        Timer {
            interval: 1000
            running: true
            repeat: true

            onTriggered:
                parent.text =
                    Qt.formatTime(
                        new Date(),
                        "hh:mm AP"
                    )
        }
    }
}