import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Item {
    id: register
    signal triggert
    property int lights: 4
    property int currentLight: 0

    Rectangle {
        id: registerWindow
        color: "#141926"
        anchors.fill: parent

        Label {
            id: textRegister
            x: 0
            y: 41
            width: 600
            height: 99
            color: "#ffffff"
            text: qsTr("Odbij swoją kartę poniżej i zarejestruj przejazd!")
            horizontalAlignment: Text.AlignHCenter
            font.capitalization: Font.AllUppercase
            font.pointSize: 13
            font.family: "Tahoma"
        }

        Button {
            id: buttonRegister
            x: 140
            y: 89
            width: 321
            height: 519
            contentItem: Text {
                text: qsTr("Odbij kartę tutaj!")
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.capitalization: Font.AllUppercase
                font.pointSize: 13
                minimumPixelSize: 15
                color:"#ffffff"

            }
            onPressed: {
                startTimer();
            }

            background: Rectangle {
                color: parent.down ? "#3FA2D0" :
                                     (parent.hovered ? "#4DC4FC" : "#1F9EDA")

            }

        }


        RowLayout {
            id: row
            y: 719
            height: 48
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 50
            anchors.rightMargin: 135
            anchors.leftMargin: 135

            Rectangle {
                id: light1
                Layout.fillWidth: true
                Layout.fillHeight: true
                border.width: 7
                radius: width*0.5
                border.color: "#0c111e"
                color: "#2b2b2a"

            }

            Rectangle {
                id: light2
                Layout.fillWidth: true
                Layout.fillHeight: true
                border.width: 7
                radius: width*0.5
                border.color: "#0c111e"
                color: "#2b2b2a"
            }

            Rectangle {
                id: light3
                Layout.fillWidth: true
                Layout.fillHeight: true
                border.width: 7
                radius: width*0.5
                border.color: "#0c111e"
                color: "#2b2b2a"
            }

            Rectangle {
                id: light4
                Layout.fillWidth: true
                Layout.fillHeight: true
                border.width: 7
                radius: width*0.5
                border.color: "#0c111e"
                color: "#2b2b2a"
            }

        }


    }

    Timer {
        id: registerTimer
        repeat: true
        interval: 400
        onTriggered: {
            register.currentLight++;
            enableLight(register.currentLight);
            if (register.currentLight === register.lights + 1) {
                stopTimer();
                resetLights();
            }
        }
    }

    function startTimer() {
        registerTimer.start();
    }

    function stopTimer() {
        registerTimer.running = false;
        register.currentLight = 0;
        clientConnector.on_register_finished();
        register.triggert();
    }

    function resetLights() {
        light1.color = "#2b2b2a";
        light2.color = "#2b2b2a";
        light3.color = "#2b2b2a";
        light4.color = "#2b2b2a";
    }

    function enableLight(light){
        switch(light){
        case 1:
            light1.color = "#3CCA09";
            break;
        case 2:
            light2.color = "#3CCA09";
            break;
        case 3:
            light3.color = "#3CCA09";
            break;
        case 4:
            light4.color = "#3CCA09";
            break;
        }
    }
}


/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
