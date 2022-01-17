import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQml.Models 2.3


Item {
    id: error
    signal triggert
    property int defaultSeconds: 5
    property int seconds: defaultSeconds
    height: 870
    width: 600


    Rectangle {
        id: errorWindow
        color: "#141926"
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: -8
        anchors.leftMargin: 0
        anchors.topMargin: -7
        width: 600

        Label {
            id: textError
            width: 600
            height: 43
            color: "#ffffff"
            text: qsTr("Nie udało się zarejestrować wejścia!")
            anchors.topMargin: 30
            anchors.top: errorImage.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            font.capitalization: Font.AllUppercase
            font.pointSize: 12
            font.family: "Tahoma"
        }

            Image {///???????
                id: errorImage
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                width: 70
                height: 120
                source: "Images/error.svg"
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 130
                fillMode: Image.PreserveAspectFit

            }



        Label {
            id: textRegisterCard
            anchors.topMargin: 35
            anchors.top: textError.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: "#ffffff"
            text: qsTr("Aby korzystać z usługi zarerejstruj swoją kartę.")
            horizontalAlignment: Text.AlignHCenter
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            styleColor: "#ffffff"
            font.pointSize: 13
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
            spacing: 1

            Rectangle {
                id: logo
                color: "#141926"
                Layout.rightMargin: -24
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
                text: qsTr("życzy miłego dnia!")
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
    }


    Timer {
        id: errorTimer
        repeat: true
        interval: 1000
        onTriggered: {
            error.seconds--;
            if (error.seconds === -1) {
                stopTimer();
            }
        }
    }

    function startTimer() {
        errorTimer.start();
    }

    function stopTimer() {
        errorTimer.running = false;
        error.seconds = error.defaultSeconds;
        clientConnector.on_timer_finished();
        error.triggert();
    }

    function getCurrentTime(){
        const date = new Date;
        const localeSpecificTime = date.toLocaleTimeString();
            return localeSpecificTime.replace(/:\d+ /, ' ');
    }

    Connections {
        target: clientConnector

        function onCountTimeError(){
            startTimer();
        }

    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.33;height:480;width:640}
}
##^##*/
