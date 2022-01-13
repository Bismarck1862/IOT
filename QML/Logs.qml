import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.15

Item {
    id: logsWindow
    width: 1070
    height: 665
    anchors.fill: parent

    Rectangle {
        id: main
        color: "#141926"
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        RowLayout {
            id: rowLayout
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.topMargin: 100
            anchors.rightMargin: 20
            anchors.bottomMargin: 40

            Rectangle {
                id: rectangleList
                Layout.preferredWidth: 1030
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "#0c111e"

                ListView {
                    id: list
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 20
                    anchors.topMargin: 20
                    anchors.bottomMargin: 30
                    ScrollBar.vertical: ScrollBar {
                        active: true

                    }
                    model: serverConnector.model
                    bottomMargin: 10
                    spacing: 10
                    delegate:

                        Rectangle{
                        width: 990
                        height: 30
                        color: "#141926"
                            //"#333948"


                        RowLayout{
                            anchors.fill: parent
                            anchors.rightMargin: 100
                            anchors.leftMargin: 5
                            Text {
                                color: "#1F9EDA"
                                //"#ffffff"
                                text: name
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                                font.family: "Verdana"
                                Layout.fillWidth: true
                                Layout.preferredWidth: 4

                            }
                            Text {
                                color: "#ffffff"
                                text: tentry
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                                font.family: "Verdana"
                                Layout.fillWidth: true
                                Layout.preferredWidth: 6
                            }
                            Text {
                                color: "#ffffff"
                                text:
                                    texit ? texit : "-"
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                                font.family: "Verdana"
                                Layout.fillWidth: true
                                Layout.preferredWidth: 6
                            }
                            Text {
                                color: "#ffffff"
                                text: price ? price : "-"
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                                font.pointSize: 12
                                font.family: "Verdana"
                                Layout.fillWidth: true
                                Layout.preferredWidth: 1
                            }
                        }

                        Rectangle{
                            width: parent.width
                            anchors.bottom: parent.bottom
                            height: 1
                            color: "#ffffff"
                        }
                    }
                }


            }
        }

        Button {
            id: buttonRefresh
            width: 50
            height: 50
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 36
            anchors.topMargin: 37
            onPressed: {
                serverConnector.reload_list()
            }

            background: Rectangle {
                color: parent.down ? "#777B86" :
                                     (parent.hovered ? "#404656" : "#141926")

                Image{
                    id: imgRefresh
                    source: "Images/refresh.svg"
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit

                }
                ColorOverlay{
                    anchors.fill: imgRefresh
                    source: imgRefresh
                    color: "#1F9EDA"

                }

            }
        }
        RowLayout {
            id: descriptionLayout
            height: 40
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 166
            anchors.topMargin: 50
            anchors.leftMargin: 25


            Label {
                id: textName
                color: "#ffffff"
                text: qsTr("nr karty")
                font.capitalization: Font.AllUppercase
                font.family: "Verdana"
                font.pointSize: 15
                Layout.preferredWidth: 4
                Layout.fillHeight: true
                Layout.fillWidth: true

            }

            Label {
                id: textGamesWon
                color: "#ffffff"
                text: qsTr("wejście")
                font.capitalization: Font.AllUppercase
                Layout.preferredWidth: 6
                Layout.fillWidth: true
                font.family: "Verdana"
                font.pointSize: 15
                Layout.fillHeight: true
            }

            Label {
                id: textGamesLost
                color: "#ffffff"
                text: qsTr("wyjście")
                font.capitalization: Font.AllUppercase
                Layout.preferredWidth: 6
                Layout.fillWidth: true
                font.family: "Verdana"
                font.pointSize: 15
                Layout.fillHeight: true
            }

            Label {
                id: textLegsWon
                color: "#ffffff"
                text: qsTr("cena")
                font.capitalization: Font.AllUppercase
                Layout.fillWidth: true
                font.family: "Verdana"
                Layout.preferredWidth: 1
                font.pointSize: 15
                Layout.fillHeight: true
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
