import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import Prezenter

Item {
    Rectangle{
        anchors.fill: parent
        color: "#FFFFFF"

        Text{
            anchors{
                top: parent.top
                left: parent.left
                margins: 10
            }
            font.pixelSize: 36
            font.bold: true
            text: AppInfo.name
        }

        ColumnLayout{
            anchors.centerIn: parent
            spacing: 6
            Button{
                Layout.alignment: "AlignCenter"
                text: "Lista pieśni"
                onClicked: {
                    Navigation.push(Qt.resolvedUrl("HymnListPage.qml"))
                }
            }
            Button{
                Layout.alignment: "AlignCenter"
                text: "Zestawy"
                onClicked: {
                    Navigation.push(Qt.resolvedUrl("SetListPage.qml"))
                }
            }
            Button{
                Layout.alignment: "AlignCenter"
                text: "Wyświetl dowolny tekst"
                onClicked: {
                    Navigation.push(Qt.resolvedUrl("QuickScreenPage.qml"))
                }
            }
            Button{
                Layout.alignment: "AlignCenter"
                text: "Ustawienia"
                onClicked: {
                    Navigation.push(Qt.resolvedUrl("SettingsPage.qml"))
                }
            }
            Button{
                Layout.alignment: "AlignCenter"
                text: "Wyłącz tablicę"
                onClicked: {
                    if(TablicaConnector.shutdown())
                        infoPopup.show("Pomyślnie wyłączono tablicę")
                    else
                        infoPopup.show("Nie można połączyć się z tablicą")

                }
            }
        }

        Text{
            anchors{
                bottom: parent.bottom
                left: parent.left
                margins: 10
            }
            text: "Copyright © " + AppInfo.company
        }
    }

    Popup {
        id: infoPopup

        x: (parent.width - width) / 2
        y: parent.height - height - 20

        padding: 12
        modal: false
        focus: false
        closePolicy: Popup.NoAutoClose

        background: Rectangle {
            radius: 6
            color: "#323232"
        }

        Label {
            id: infoText
            color: "white"
        }

        Timer {
            id: hideTimer
            interval: 2500
            onTriggered: infoPopup.close()
        }

        function show(message) {
            infoText.text = message
            open()
            hideTimer.restart()
        }
    }
}
