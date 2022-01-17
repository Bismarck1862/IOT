import QtQuick 2.13
import QtQuick.Window 2.2
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

ApplicationWindow {
    id: dialogWindow
    flags: Qt.Window | Qt.FramelessWindowHint
    width: 500
    height: 230
    visible: false

    MouseArea {
        id: mouseAreaTop
        width: 0
        height: 50
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        cursorShape: Qt.ArrowCursor
        anchors.rightMargin: 0
        anchors.topMargin: 0
        anchors.leftMargin: 0


        DragHandler {
            id: resizeHandlerTop
            target: null
            onActiveChanged: if (active) {
                                 dialogWindow.startSystemMove();
                             }
        }

    }


    Rectangle {
        id: main
        height: 230
        color: "#141926"
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.bottomMargin: 0

        Label {
            id: textInfo
            y: 55
            height: 75
            color: "#ffffff"
            text: qsTr("Logi pomyślnie wyeksportowane!")
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.pointSize: 18
            font.family: "Verdana"
            anchors.rightMargin: 40
            anchors.leftMargin: 40
        }
    }

    Rectangle {
        id: windowBar
        height: 40
        color: "#0c111e"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        Button {
            id: buttonClose
            x: 1406
            width: 60
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            palette.buttonText: "#ffffff"
            anchors.bottomMargin: 0
            anchors.topMargin: 0
            anchors.rightMargin: 0
            background: Rectangle {
                color: parent.down ? "#DF3939" :
                                     (parent.hovered ? "#CD0000" : "#0c111e")


                Image{
                    id: imgClose
                    source: "Images/closeButton.svg"
                    anchors.fill: parent
                    anchors.margins: 5
                    fillMode: Image.PreserveAspectFit




                }
                ColorOverlay{
                    anchors.fill: imgClose
                    source: imgClose
                    color: "#ffffff"

                }
            }
            onClicked: dialogWindow.close()



        }
    }

    Button {

        text: qsTr("ok")
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 190
        anchors.rightMargin: 190
        anchors.bottomMargin: 26
        font.capitalization: Font.AllUppercase
        font.pointSize: 11
        id: buttonOk
        y: 154
        height: 50
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.preferredHeight: 90
        Layout.preferredWidth: 65
        background: Rectangle {
            color: parent.down ? "#3FA2D0" :
                                 (parent.hovered ? "#4DC4FC" : "#1F9EDA")

        }

        palette.buttonText: "white"
        onClicked: {
            dialogWindow.close()
        }
    }

}
