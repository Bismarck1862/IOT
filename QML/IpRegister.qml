import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11

Item {
    id: ipRegisterWindow
    width: 1070
    height: 665
    anchors.fill: parent

    RegisterDialog{
        id: registerDialog
    }


    Rectangle {
        id: main
        color: "#141926"
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0



        TextField {
            id: textInputId
            height: 79
            color: "#ffffff"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: textEnterId.bottom
            horizontalAlignment: Text.AlignHLeft
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.NoWrap
            topPadding: 6
            anchors.topMargin: 6
            anchors.leftMargin: 120
            anchors.rightMargin: 422
            font.pointSize: 18
            selectionColor: "#a604cd"
            font.family: "Verdana"
            background:  Rectangle{
                color: "#0c111e"
            }
        }

        Label {
            id: textEnterId
            height: 50
            color: "#ffffff"
            text: qsTr("Podaj id karty do zarejestrowania:")
            anchors.left: parent.left
            anchors.top: parent.top
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.topMargin: 40
            font.pointSize: 16
            font.family: "Verdana"
            anchors.leftMargin: 120
        }

        Button {
            id: buttonRegisterId
            y: 103
            height: 65
            text: qsTr("Akceptuj")
            anchors.left: textInputId.right
            anchors.right: parent.right
            anchors.leftMargin: 85
            anchors.rightMargin: 160
            font.capitalization: Font.AllUppercase
            font.pointSize: 14
            Layout.preferredHeight: 60
            Layout.rightMargin: 450
            Layout.leftMargin: 450
            Layout.topMargin: 0
            Layout.fillHeight: true
            Layout.fillWidth: true
            background: Rectangle {
                color: parent.down ? "#3FA2D0" :
                                     (parent.hovered ? "#4DC4FC" : "#1F9EDA")

            }

            palette.buttonText: "white"
            onClicked: {
                serverConnector.on_register_ip(textInputId.text)
            }

        }

    }
    Connections{
        target: serverConnector

        function onShowRegisterDialog(){
            textInputId.text = ""
            registerDialog.visible = true
        }

    }

}




