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
        color: Theme.background
    }

    Rectangle {
        id: topBar

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: 50
        color: Theme.header

        visible: !Qt.inputMethod.visible

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
            top: Qt.inputMethod.visible ? parent.top : topBar.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
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

                contentWidth: width
                contentHeight: Math.max(height, editor.implicitHeight)

                ScrollBar.vertical: ScrollBar {}

                TablicaScreen {
                    id: editor

                    width: flick.width
                    height: Math.max(flick.height, implicitHeight)

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
            Layout.preferredHeight: toolBar.implicitHeight + 16

            color: Theme.panel

            visible: !Qt.inputMethod.visible

            RowLayout {
                id: toolBar
                anchors.fill: parent
                anchors.margins: 8

                Label {
                    text: qsTr("Rozmiar czcionki: ")

                    color: Theme.text
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
    }

    Popup {
        id: infoPopup

        parent: Overlay.overlay

        x: (parent.width - width) / 2
        y: parent.height - height - 40

        padding: 12
        modal: false
        focus: false
        closePolicy: Popup.NoAutoClose

        background: Rectangle {
            radius: 6
            color: Theme.popup
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
