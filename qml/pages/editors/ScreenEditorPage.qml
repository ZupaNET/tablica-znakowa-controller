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

    property alias content: editor.content
    property alias fontIndex: fontSelector.currentIndex
    property int row: -1

    signal accepted(string content, int fontIndex)

    Rectangle {
        anchors.fill: parent
        color: Theme.background
    }

    PageHeader {
        id: topBar

        visible: !Qt.inputMethod.visible

        title: root.row < 0 ? qsTr("Nowy slajd") : qsTr("Edycja slajdu")
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

                    currentIndex: 2
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

                    text: qsTr("Anuluj")

                    onClicked: {
                        Navigation.pop()
                    }
                }

                Button {
                    text: qsTr("Zapisz")

                    onClicked: {
                        root.accepted(root.content, root.fontIndex)
                        Navigation.pop()
                    }
                }
            }
        }
    }
}
