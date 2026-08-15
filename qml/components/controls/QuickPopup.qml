// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

import QtQuick
import QtQuick.Controls

import Prezenter

Popup {
    id: root

    parent: Overlay.overlay

    x: (parent.width - width) / 2
    y: parent.height - height - 40

    padding: 14

    background: Rectangle {
        radius: 10
        color: Theme.popup
    }

    function show(text) {
        infoText.text = text

        open()
        hideTimer.restart()
    }

    Label {
        id: infoText

        color: "white"
    }

    Timer {
        id: hideTimer

        interval: 2500

        onTriggered: root.close()
    }

}