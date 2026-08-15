// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

import QtQuick
import QtQuick.Controls

import Prezenter

Item {
    id: root

    property alias text: title.text

    implicitHeight: 58

    Rectangle {
        anchors.fill: parent
        color: Theme.background

        radius: 12
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        height: 12
        color: Theme.background
    }

    Label {
        id: title

        anchors {
            fill: parent
            leftMargin: 20
            rightMargin: 20
        }

        verticalAlignment: Text.AlignVCenter

        color: Theme.text

        font.pixelSize: 25
        font.bold: true
    }
}