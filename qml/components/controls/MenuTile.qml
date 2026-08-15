// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

import QtQuick
import QtQuick.Controls

Rectangle {
    id: root

    signal clicked

    property string icon
    property string title
    property string description
    property bool danger: false

    implicitWidth: 270
    implicitHeight: 150

    property real scaleFactor: Math.min(width / implicitWidth, height / implicitHeight)

    radius: width * 0.07

    color:
        mouse.containsMouse
        ? Theme.surfaceHover
        : danger
          ? Theme.dangerSurface
          : Theme.surface

    border.color:
        danger
        ? Theme.dangerBorder
        : Theme.surfaceBorder

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    Column {
        anchors.centerIn: parent

        spacing: 8

        scale: root.scaleFactor

        Text {
            anchors.horizontalCenter: parent.horizontalCenter

            text: root.icon

            font.family: "Material Design Icons"

            font.pixelSize: 46

            color:
                danger
                ? Theme.danger
                : Theme.text
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter

            text: root.title

            font.pixelSize: 20
            font.bold: true

            color: Theme.text
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter

            text: root.description

            color: Theme.textSecondary

            font.pixelSize: 13
        }
    }

    MouseArea {
        id: mouse

        anchors.fill: parent

        hoverEnabled: true

        onClicked:
            root.clicked()
    }
}