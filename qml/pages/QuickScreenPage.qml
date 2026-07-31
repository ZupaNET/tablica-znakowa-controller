import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Prezenter

Item {
    id: root

    ScreenModel {
        id: screenModel
    }

    property var currentScreen: screenModel.emptyScreen()

    Connections {
        target: TablicaConnector

        function onConnectionFailure() {
            infoPopup.show("Nie można połączyć się z tablicą")
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#FFFFFF"
    }

    Rectangle {
        id: topBar

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: 50
        color: "#474747"

        Button {
            text: "Powrót"

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }

            flat: true

            Material.foreground: "white"

            onClicked: {
                Navigation.pop()
            }
        }

        Label {
            anchors.centerIn: parent

            text: "Wyświetlanie tekstu"

            color: "white"

            font.pixelSize: 20
            font.bold: true
        }
    }

    ColumnLayout {
        anchors {
            top: topBar.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right

            margins: 20
        }

        spacing: 15

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true

            color: "transparent"

            TablicaScreen {
                id: editor

                anchors.fill: parent

                editable: true

                hymnFont: fontSelector.currentIndex
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1

            color: "#cccccc"
        }

        RowLayout {
            Layout.fillWidth: true

            Label {
                text: "Rozmiar czcionki: "
            }

            ComboBox {
                id: fontSelector

                Layout.preferredWidth: 140

                model: [
                    "Mała",
                    "Średnia",
                    "Duża"
                ]
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: "Wyświetl"

                onClicked: {
                    currentScreen.text = editor.content
                    currentScreen.font = fontSelector.currentIndex
                    TablicaConnector.enabled = true
                    TablicaConnector.buffer = currentScreen
                }
            }
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
