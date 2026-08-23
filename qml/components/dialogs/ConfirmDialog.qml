// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

import QtQuick
import QtQuick.Controls

import Prezenter

Dialog {
    id: root

    property string message: ""
    property int row: -1

    modal: true
    dim: true

    parent: Overlay.overlay

    anchors.centerIn: Overlay.overlay

    standardButtons: Dialog.Yes | Dialog.No

    Overlay.modal: Rectangle {
        color: Theme.dimBackground
    }

    Label {
        text: root.message
        color: Theme.text
    }

    onAccepted: viewport.forceActiveFocus()
}
