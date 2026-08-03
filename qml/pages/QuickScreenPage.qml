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
            infoPopup.show(qsTr("Nie można połączyć się z tablicą"))
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
            text: qsTr("Powrót")

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

            text: qsTr("Wyświetlanie tekstu")

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
            Layout.fillWidth: true
            Layout.fillHeight: true

            color: "transparent"
            clip: true

            Flickable {
                id: flick

                anchors.fill: parent

                clip: true

                contentWidth: Math.max(width, editor.implicitWidth)
                contentHeight: Math.max(height, editor.implicitHeight)

                ScrollBar.horizontal: ScrollBar {}

                TablicaScreen {
                    id: editor

                    width: Math.max(flick.width, implicitWidth)
                    height: Math.max(flick.height, implicitHeight)

                    implicitWidth: 1200
                    implicitHeight: 600

                    editable: true

                    hymnFont: fontSelector.currentIndex

                    Component.onCompleted: {
                        content = AppSettings.screenCustomText
                    }

                    onContentTextChanged: (c) => {
                        if (content !== AppSettings.screenCustomText)
                            AppSettings.screenCustomText = content
                    }
                }
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
                text: qsTr("Rozmiar czcionki: ")
            }

            ComboBox {
                id: fontSelector

                Layout.preferredWidth: 140

                model: [
                    qsTr("Mała"),
                    qsTr("Średnia"),
                    qsTr("Duża")
                ]

                currentIndex: AppSettings.screenCustomFont

                onActivated: {
                    AppSettings.screenCustomFont = currentIndex
                }
            }

            Item {
                Layout.preferredWidth: 10
            }

            Button {
                text: qsTr("Widok")

                onClicked: {
                    AppSettings.screenView === "screenView" ? AppSettings.screenView = "textView" : AppSettings.screenView === "textView" ? AppSettings.screenView = "textViewRev" : AppSettings.screenView = "screenView";
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: qsTr("Wyświetl")

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
