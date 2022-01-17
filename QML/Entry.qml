import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQml.Models 2.3


Item {
    id: entry
    signal triggert
    property int defaultSeconds: 5
    property int seconds: defaultSeconds
    height: 870
    width: 600


    Rectangle {
        id: entryWindow
        color: "#141926"
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: -8
        anchors.leftMargin: 0
        anchors.topMargin: -7
        width: 600

        Label {
            id: textEntry
            width: 600
            height: 43
            color: "#ffffff"
            text: qsTr("Wejście pomyślnie zarejestrowane!")
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: imageConfirm.bottom
            horizontalAlignment: Text.AlignHCenter
            anchors.topMargin: 29
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            font.capitalization: Font.AllUppercase
            font.pointSize: 12
            font.family: "Tahoma"
        }

        Label {
            id: textTime
            anchors.topMargin: 35
            anchors.top: textEntry.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: "#ffffff"
            //text: qsTr("Zarejestrowano godzinę %1").arg(getCurrentTime())
            horizontalAlignment: Text.AlignHCenter
            styleColor: "#ffffff"
            font.pointSize: 15
            font.capitalization: Font.AllUppercase

        }

        RowLayout{
            id: row
            y: 177
            height: 40
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 270
            anchors.rightMargin: 70
            anchors.leftMargin: 70
            spacing: 6

            Rectangle {
                id: logo
                color: "#141926"
                Layout.fillWidth: true
                Layout.fillHeight: true
                width: 200
                Image {
                    id: mpklogo
                    anchors.fill: parent
                    source: "Images/mpklogo.png"
                    fillMode: Image.PreserveAspectFit
                }

            }

            Label {
                width: 50
                color: "#ffffff"
                id: textNiceRide
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: qsTr("życzy przyjemnej podróży!")
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignBottom
                font.pointSize: 9
                font.capitalization: Font.AllUppercase

            }
        }

        Button {
            id: buttonTimer
            text: seconds
            width: 60
            height: 60
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.leftMargin: 8
            contentItem: Text {
                text: buttonTimer.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#ffffff"
                font.bold: true
                font.pointSize: 11
            }
            onPressed: {
                stopTimer();
            }
            background: Rectangle {
                color: parent.hovered ? "#1F9EDA" : "#141926"
                border.width: 4
                border.color: "#1F9EDA"
                radius: 0.5*width

            }
        }

        Image {
            id: imageConfirm
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            source: "Images/confirm.svg"
            anchors.topMargin: 130
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            fillMode: Image.PreserveAspectFit
        }
    }


    Timer {
        id: entryTimer
        repeat: true
        interval: 1000
        onTriggered: {
            entry.seconds--;
            if (entry.seconds === -1) {
                stopTimer();
            }
        }
    }

    function startTimer() {
        entryTimer.start();
    }

    function stopTimer() {
        entryTimer.running = false;
        entry.seconds = entry.defaultSeconds;
        clientConnector.on_timer_finished();
        entry.triggert();
    }


    Connections {
        target: clientConnector

        function onCountTimeEntry(time){
            startTimer();
            textTime.text = `Zarejestrowano czas\n${time}`;
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.5;height:480;width:640}
}
##^##*/
