// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Prezenter

Item {
    id: root

    property string icon: ""
    property string title: ""
    property string description: ""

    property bool destructive: false

    signal clicked()

    implicitHeight: 64
    Layout.fillWidth: true

    opacity: enabled ? 1.0 : 0.5

    Rectangle {
        anchors.fill: parent

        radius: 10

        color: mouseArea.containsPress ? Theme.listItem : "transparent"

        Behavior on color {
            ColorAnimation {
                duration: 120
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 12

            spacing: 14

            Rectangle {
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40

                radius: 20

                color: "transparent"

                Label {
                    anchors.centerIn: parent

                    text: root.icon

                    font.family: "Material Design Icons"
                    font.pixelSize: 21

                    color: root.destructive ? Theme.danger : Theme.text
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Label {
                    Layout.fillWidth: true

                    text: root.title

                    font.bold: true
                    font.pixelSize: 15

                    color: root.destructive ? Theme.danger : Theme.text
                }

                Label {
                    Layout.fillWidth: true

                    text: root.description

                    font.pixelSize: 13

                    color: Theme.textSecondary

                    elide: Text.ElideRight
                }
            }

            Label {
                text: Icon.chevronRight

                font.family: "Material Design Icons"
                font.pixelSize: 22

                color: Theme.textSecondary
            }
        }

        MouseArea {
            id: mouseArea

            anchors.fill: parent

            enabled: root.enabled

            hoverEnabled: true

            onClicked: root.clicked()
        }
    }
}
