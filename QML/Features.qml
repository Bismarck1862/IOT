import QtQuick 2.0
import QtQuick.Controls 2.12

Item {
    id: featuresWindow
    width: 1070
    height: 665
    anchors.fill: parent

    ExportDialog{
        id: exportDialog
    }

    DeleteDialog{
        id: deleteDialog
    }

    DatabaseClearedDialog{
        id: databaseClearedDialog
    }

    DeleteRegisterDialog{
        id: deleteRegisterDialog
    }

    Rectangle {
        id: main
        color: "#141926"
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        Button {
            id: buttonExport
            x: 45
            y: 105
            width: 254
            height: 69
            contentItem: Text {
                text: qsTr("Eksportuj do .csv")
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.capitalization: Font.AllUppercase
                font.pointSize: 13
                minimumPixelSize: 15
                color:"#ffffff"

            }
            onPressed: {
                serverConnector.on_export()
            }

            background: Rectangle {
                color: parent.down ? "#3FA2D0" :
                                     (parent.hovered ? "#4DC4FC" : "#1F9EDA")

            }

        }

        Label {
            id: buttonExportLabel
            x: 45
            y: 44
            color: "#ffffff"
            text: qsTr("Dane zawarte w logach mogą zostać wyeksportowane do zewnętrznych plików.")
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 16
        }

    Button {
        id: buttonClearDb
        x: 45
        y: 257
        width: 254
        height: 69
        contentItem: Text {
            text: qsTr("Wyczyść bazę danych")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.capitalization: Font.AllUppercase
            font.pointSize: 13
            minimumPixelSize: 15
            color:"#ffffff"

        }
        onPressed: {
            serverConnector.on_database_clear()
        }

        background: Rectangle {
            color: parent.down ? "#3FA2D0" :
                                 (parent.hovered ? "#4DC4FC" : "#1F9EDA")

        }

    }



    TextField {
        id: textInputId
        height: 79
        color: "#ffffff"
        text: qsTr("")
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: textEnterId.bottom
        horizontalAlignment: Text.AlignHLeft
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.NoWrap
        topPadding: 6
        anchors.topMargin: 11
        anchors.leftMargin: 40
        anchors.rightMargin: 502
        font.pointSize: 18
        selectionColor: "#a604cd"
        font.family: "Verdana"
        background:  Rectangle{
            color: "#0c111e"
        }
    }

    Label {
        id: textEnterId
        y: 360
        height: 50
        color: "#ffffff"
        text: qsTr("Podaj id karty do usunięcia:")
        anchors.left: parent.left
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 16
        anchors.leftMargin: 45
    }

    Button {
        id: buttonRegisterId
        x: 750
        y: 428
        width: 202
        height: 65
        text: qsTr("Usuń")
        anchors.left: textInputId.right
        anchors.right: parent.right
        anchors.leftMargin: 114
        anchors.rightMargin: 118
        font.capitalization: Font.AllUppercase
        font.pointSize: 14
        background: Rectangle {
            color: parent.down ? "#3FA2D0" :
                                 (parent.hovered ? "#4DC4FC" : "#1F9EDA")

        }

        palette.buttonText: "white"
        onClicked: {
            serverConnector.on_delete_register(textInputId.text)
            textInputId.text = ""
        }

    }

    Label {
        id: buttonExportLabel1
        x: 45
        y: 201
        color: "#ffffff"
        text: qsTr("Dane z bazy danych mogą zostać w razie potrzeby wyczyszczone.")
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 16
    }
    }

    Connections{
        target: serverConnector

        function onShowExportDialog(){
            exportDialog.visible = true
        }

        function onShowClearDialog(){
            databaseClearedDialog.visible = true
        }

        function onShowDeleteRegisterDialog(){
            deleteRegisterDialog.visible = true
        }
    }
}
