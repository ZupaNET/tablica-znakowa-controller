// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Prezenter

Item {
    id: root

    Rectangle {
        anchors.fill: parent
        color: Theme.background
    }

    PageHeader {
        id: topBar

        visible: !Qt.inputMethod.visible

        title: qsTr("Wyświetlanie tekstu")
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

                    anchors.fill: parent
                    anchors.margins: 20

                    width: flick.width
                    height: Math.max(flick.height, implicitHeight)

                    implicitHeight: 600

                    editable: true

                    hymnFont: fontSelector.currentIndex

                    Component.onCompleted: {
                        content = AppSettings.screenCustomText
                    }

                    onContentTextChanged: (c) => {
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
                anchors.margins: 10

                ComboBox {
                    id: fontSelector

                    Layout.preferredWidth: 240

                    displayText: qsTr("Rozmiar czcionki:") + " " + currentText

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

                Button {
                    Layout.leftMargin: 10

                    text: qsTr("Widok")

                    onClicked: {
                        switch (AppSettings.screenView) {
                        case "screenView":
                            AppSettings.screenView = "textView"
                            break

                        case "textView":
                            AppSettings.screenView = "textViewRev"
                            break

                        default:
                            AppSettings.screenView = "screenView"
                            break
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Button {
                    Layout.rightMargin: 20

                    text: qsTr("Wyczyść")

                    onClicked: {
                        editor.content = ""
                        BoardController.clearScreen()
                    }
                }

                Button {
                    text: qsTr("Wyświetl")

                    onClicked: {
                        let screen = BoardController.buffer

                        screen.text = editor.content
                        screen.font = fontSelector.currentIndex

                        BoardController.enabled = true

                        if(screen === BoardController.buffer)
                        {
                            BoardController.sendBuffer()
                            return
                        }

                        BoardController.buffer = screen
                    }
                }
            }
        }
    }

    Connections {
        target: BoardController

        function onTransmissionFailed(error) {
            infoPopup.show(qsTr("Nie można połączyć się z tablicą:") + " " + error)
        }
    }

    QuickPopup {
        id: infoPopup
    }
}
