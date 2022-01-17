import QtQuick 2.15
import QtQuick.Window 2.2
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15


ApplicationWindow {
    id: rootWindow
    visible: true
    width: 600
    height: 1000
    flags: Qt.Window | Qt.FramelessWindowHint

    onClosing:{
        clientConnector.on_close()
    }

    Rectangle {
        id: topBar
        height: 30
        color: "#0c111e"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottomMargin: 0
        anchors.topMargin: 0
        anchors.leftMargin: 0



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
            onClicked: rootWindow.close()
        }

    }

    Rectangle {
        id: logo
        height: 100
        color: "#141926"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: topBar.bottom

        Image {
            id: mpklogo
            x: 8
            y: 9
            width: 338
            height: 82
            source: "Images/mpklogo.png"
            fillMode: Image.PreserveAspectFit
        }

    }

    Rectangle {
        id: main
        color: "#141926"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: logo.bottom
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0


        Register{
            id: registerWindow
            visible: true
            anchors.fill: parent
        }

        Entry{
            id: entryWindow
            visible: false
            anchors.fill: parent
        }

        Exit{
            id: exitWindow
            visible: false
            anchors.fill: parent
        }

        Error{
            id: errorWindow
            visible: false
            anchors.fill: parent
        }

    }

    MouseArea {
        id: mouseAreaTop
        width: 0
        height: 30
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        cursorShape: Qt.ArrowCursor
        anchors.rightMargin: 62
        anchors.topMargin: 0
        anchors.leftMargin: 0


        DragHandler {
            id: resizeHandlerTop
            target: null
            onActiveChanged: if (active) {
                                 rootWindow.startSystemMove();
                             }
        }

    }


    Connections {
        target: clientConnector

        function onEnableRegister(){
            registerWindow.visible = true;
            entryWindow.visible = false;
            exitWindow.visible = false;
            errorWindow.visible = false
        }

        function onEnableEntry(){
            registerWindow.visible = false;
            entryWindow.visible = true;
        }


        function onEnableExit(){
            registerWindow.visible = false;
            exitWindow.visible = true;
        }

        function onEnableError(){
            registerWindow.visible = false;
            errorWindow.visible = true;
        }
    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}
}
##^##*/
