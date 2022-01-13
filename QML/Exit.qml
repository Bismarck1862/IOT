import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQml.Models 2.3


Item {
    id: exit
    signal triggert
    property int defaultSeconds: 10
    property int seconds: defaultSeconds
    height: 870
    width: 600


    Rectangle {
        id: exitWindow
        color: "#141926"
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: -8
        anchors.leftMargin: 0
        anchors.topMargin: -7
        width: 600

        Label {
            id: textExit
            width: 600
            height: 43
            color: "#ffffff"
            text: qsTr("Wyjście pomyślnie zarejestrowane!")
            anchors.topMargin: 30
            anchors.top: imageConfirm.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            font.capitalization: Font.AllUppercase
            font.pointSize: 12
            font.family: "Tahoma"
        }

        Label {
            id: textTime
            anchors.topMargin: 35
            anchors.top: textExit.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: "#ffffff"
            horizontalAlignment: Text.AlignHCenter
            styleColor: "#ffffff"
            font.pointSize: 15
            font.capitalization: Font.AllUppercase

        }

        Label {
            id: textPriceDescription
            anchors.topMargin: 30
            anchors.top: textTime.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: "#ffffff"
            text: qsTr("Opłata za przejazd wynosi")
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 15
            font.capitalization: Font.AllUppercase

        }

        Label {
            id: textPrice
            anchors.topMargin: 10
            anchors.top: textPriceDescription.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color:  "#1F9EDA"
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 24
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
                text: qsTr("dziękuje za wspólną podróż!")
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
            x: 0
            y: 230
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            source: "Images/confirm.svg"
            anchors.topMargin: 130
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            fillMode: Image.PreserveAspectFit
        }




    }


    Timer {
        id: exitTimer
        repeat: true
        interval: 1000
        onTriggered: {
            exit.seconds--;
            if (exit.seconds === -1) {
                stopTimer();
            }
        }
    }

    function startTimer() {
        exitTimer.start();
    }

    function stopTimer() {
        exitTimer.running = false;
        exit.seconds = exit.defaultSeconds;
        clientConnector.on_timer_finished();
        exit.triggert();
    }

    function getCurrentTime(){
        const date = new Date;
        const localeSpecificTime = date.toLocaleTimeString();
        return localeSpecificTime.replace(/:\d+ /, ' ');
    }

    Connections {
        target: clientConnector

        function onCountTimeExit(price, time){
            startTimer();
            textPrice.text = `${price}zł`
            textTime.text = `Przejazd trwał ${time} min`
        }

    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
