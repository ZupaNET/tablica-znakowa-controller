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

Rectangle {
    id: root

    property alias title: titleText.text
    property bool showBack: true

    height: 50

    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
    }

    color: Theme.header

    Button {
        visible: root.showBack
        enabled: root.showBack

        text: Icon.arrowLeft

        Material.background: "transparent"
        Material.foreground: "white"
        font.family: "Material Design Icons"
        font.pixelSize: 20

        anchors {
            left: parent.left
            leftMargin: 10
            verticalCenter: parent.verticalCenter
        }

        flat: true

        onClicked: {
            Navigation.pop()
        }
    }

    Text {
        id: titleText

        anchors.centerIn: parent

        color: "white"

        font.pixelSize: 22
        font.bold: true
    }
}