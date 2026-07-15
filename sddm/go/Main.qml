import QtQuick 2.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1536
    height: 1024
    color: "#2e3440"

    property color paper: "#eceff4"
    property color mutedPaper: "#d8dee9"
    property color graphite: "#3b4252"
    property color graphiteLight: "#4c566a"
    property color error: "#bf616a"
    property int sessionIndex: sessionModel.lastIndex

    Image {
        anchors.fill: parent
        source: "background.png"
        fillMode: Image.PreserveAspectCrop
        smooth: true
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            message.text = "Incorrect password"
            message.color = root.error
            password.text = ""
            password.forceActiveFocus()
        }
        function onInformationMessage(text) {
            message.text = text
            message.color = root.mutedPaper
        }
    }

    ListView {
        id: users
        anchors.centerIn: parent
        width: 360
        height: 220
        clip: true
        interactive: false
        focus: true
        model: userModel
        currentIndex: userModel.lastIndex

        function focusCurrentPassword() {
            if (currentItem)
                currentItem.focusPassword()
        }

        Component.onCompleted: focusCurrentPassword()
        onCurrentIndexChanged: focusCurrentPassword()

        delegate: Item {
            width: users.width
            height: users.height
            property string username: model.name
            visible: ListView.isCurrentItem

            function focusPassword() {
                password.forceActiveFocus()
            }

            Timer {
                interval: 0
                running: ListView.isCurrentItem
                repeat: false
                onTriggered: password.forceActiveFocus()
            }

            Column {
                anchors.fill: parent
                spacing: 12

                Text {
                    color: root.paper
                    text: model.realName === "" ? model.name : model.realName
                    font.family: "Inconsolata"
                    font.pixelSize: 24
                    font.bold: true
                }

                Text {
                    color: root.mutedPaper
                    text: "Sign in"
                    font.family: "Inconsolata"
                    font.pixelSize: 14
                }

                Rectangle {
                    width: parent.width
                    height: 42
                    color: root.graphite
                    border.color: password.activeFocus ? root.paper : root.graphiteLight
                    border.width: 1
                    radius: 4

                    TextInput {
                        id: password
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 14
                        color: root.paper
                        selectionColor: root.graphiteLight
                        selectedTextColor: root.paper
                        font.family: "Inconsolata"
                        font.pixelSize: 17
                        echoMode: TextInput.Password
                        focus: ListView.isCurrentItem
                        verticalAlignment: TextInput.AlignVCenter
                        clip: true

                        Keys.onReturnPressed: sddm.login(username, text, root.sessionIndex)
                    }
                }

                Text {
                    id: message
                    width: parent.width
                    height: 20
                    color: root.mutedPaper
                    text: ""
                    font.family: "Inconsolata"
                    font.pixelSize: 13
                }
            }
        }
    }
}