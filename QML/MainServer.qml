import QtQuick 2.13
import QtQuick.Window 2.2
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15


ApplicationWindow {
    id: rootWindow
    visible: true
    width: 1200
    height: 800
    flags: Qt.Window | Qt.FramelessWindowHint

    onClosing:{
        serverConnector.on_close()
    }

    Rectangle {
        id: manuBar
        width: 130
        color: "#0c111e"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.topMargin: 0
        anchors.leftMargin: 0

        Button {
            id: buttonServer
            height: 130
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 35

            background: Rectangle {
                color: parent.down ? "#777B86" :
                                     (parent.hovered ? "#404656" : "#141926")

                Image{
                    id: imgServer
                    source: "Images/register.svg"
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: imgServerText.top
                    anchors.leftMargin: 5
                    anchors.bottomMargin: 5
                    fillMode: Image.PreserveAspectFit

                }
                ColorOverlay{
                    anchors.fill: imgServer
                    source: imgServer
                    color: "#1F9EDA"

                }

                Text {
                    id: imgServerText
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    text: qsTr("REJESTRACJA")
                    color: "#1F9EDA"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    font.pointSize: 9
                }


            }


            Rectangle{
                id: buttonServerActiveIndicator
                width: 8
                color: "#1F9EDA"
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                anchors.rightMargin: 0

            }

            states: [
                State {
                    name: "nonActive"

                    PropertyChanges {
                        target: buttonServerActiveIndicator
                        color: "#141926"
                    }
                },

                State {
                    name: "active"
                    PropertyChanges {
                        target: buttonServerActiveIndicator
                        color: "#1F9EDA"

                    }
                }
            ]

            onClicked: {
                state = "active"
                buttonLogs.state = "nonActive"
                buttonExport.state = "nonActive"
                registerIpWindow.visible = true
                logsWindow.visible = false
                exportWindow.visible = false

            }

        }

        Button {
            id: buttonLogs
            height: 130
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: buttonServer.bottom
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            background: Rectangle {
                color: parent.down ? "#777B86" :
                                     (parent.hovered ? "#404656" : "#141926")
                Image{
                    id: imgLogs
                    source: "Images/logs.svg"
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: imgLogsText.top
                    anchors.bottomMargin: 5
                    anchors.leftMargin: 20
                    anchors.topMargin: 10
                    fillMode: Image.PreserveAspectFit

                }
                ColorOverlay{
                    anchors.fill: imgLogs
                    source: imgLogs
                    color: "#1F9EDA"

                }

                Text {
                    id: imgLogsText
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    text: qsTr("LOGI")
                    color: "#1F9EDA"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    font.pointSize: 11
                }



            }
            anchors.topMargin: 30


            Rectangle{
                id: buttonLogsActiveIndicator
                x: 125
                width: 8
                color: "#141926"
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                anchors.rightMargin: 0

            }

            states: [
                State {
                    name: "nonActive"

                    PropertyChanges {
                        target: buttonLogsActiveIndicator
                        color: "#141926"
                    }
                },

                State {
                    name: "active"
                    PropertyChanges {
                        target: buttonLogsActiveIndicator
                        color: "#1F9EDA"

                    }
                }
            ]

            onClicked: {
                state = "active"
                buttonServer.state = "nonActive"
                buttonExport.state = "nonActive"
                registerIpWindow.visible = false
                logsWindow.visible = true
                exportWindow.visible = false
                serverConnector.reload_list()

            }


        }


        Button {
            id: buttonExport
            height: 130
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: buttonLogs.bottom
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            background: Rectangle {
                color: parent.down ? "#777B86" :
                                     (parent.hovered ? "#404656" : "#141926")
                Image{
                    id: imgExport
                    source: "Images/settings.svg"
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: imgExportText.top
                    anchors.leftMargin: 15
                    anchors.topMargin: 5
                    anchors.bottomMargin: 5
                    fillMode: Image.PreserveAspectFit

                }
                ColorOverlay{
                    anchors.fill: imgExport
                    source: imgExport
                    color: "#1F9EDA"

                }

                Text {
                    id: imgExportText
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    text: qsTr("DODATKI")
                    color: "#1F9EDA"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    font.pointSize: 11
                }

            }
            anchors.topMargin: 30


            Rectangle{
                id: buttonExportActiveIndicator
                x: 125
                width: 8
                color: "#141926"
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                anchors.rightMargin: 0

            }

            states: [
                State {
                    name: "nonActive"

                    PropertyChanges {
                        target: buttonExportActiveIndicator
                        color: "#141926"
                    }
                },

                State {
                    name: "active"
                    PropertyChanges {
                        target: buttonExportActiveIndicator
                        color: "#1F9EDA"

                    }
                }
            ]

            onClicked: {
                state = "active"
                buttonServer.state = "nonActive"
                buttonLogs.state = "nonActive"
                registerIpWindow.visible = false
                logsWindow.visible = false
                exportWindow.visible = true

            }


        }

    }

    Rectangle {
        id: main
        color: "#141926"
        anchors.left: manuBar.right
        anchors.right: parent.right
        anchors.top: toolBar.bottom
        anchors.bottom: logoBar.top
        anchors.bottomMargin: 0
        anchors.topMargin: 0
        anchors.leftMargin: 0

        IpRegister{
            id: registerIpWindow
            visible: true
            anchors.fill: parent
        }

        Logs {
            id: logsWindow
            visible: false
            anchors.fill: parent
        }

        Features{
            id: exportWindow
            visible: false
            anchors.fill: parent
        }

    }

    Rectangle {
        id: toolBar
        height: 35
        color: "#0c111e"
        anchors.left: manuBar.right
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
            onClicked: rootWindow.close()



        }

        Button {
            id: buttonMinimalize
            x: 1349
            width: 60
            anchors.right: buttonClose.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 0
            anchors.bottomMargin: 0
            anchors.rightMargin: 0

            background: Rectangle {
                color: parent.down ? "#777B86" :
                                     (parent.hovered ? "#404656" : "#0c111e")

                Image{
                    id: imgMinimze
                    source: "Images/minimizeButton.svg"
                    anchors.fill: parent
                    anchors.margins: 5
                    fillMode: Image.PreserveAspectFit
                }
                ColorOverlay{
                    anchors.fill: imgMinimze
                    source: imgMinimze
                    color: "#ffffff"

                }

            }
            onClicked: rootWindow.showMinimized()
        }


    }

    Rectangle {
        id: logoBar
        width: 1600
        height: 100
        color: "#141926"
        anchors.left: manuBar.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Image {
            id: mpklogo
            width: 378
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            source: "Images/mpklogo.png"
            anchors.topMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            fillMode: Image.PreserveAspectFit
        }
    }

    MouseArea {
        id: mouseAreaTop
        width: 0
        height: 35
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        cursorShape: Qt.ArrowCursor
        anchors.rightMargin: 120
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
    Connections{
        target: serverConnector
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
