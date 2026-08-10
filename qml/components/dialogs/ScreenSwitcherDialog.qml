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

Dialog {
    id: root

    property int setId: -1
    property int hymnId: -1

    title: qsTr("Widoczność slajdów")

    modal: true
    dim: true
    clip: true

    parent: Overlay.overlay
    anchors.centerIn: Overlay.overlay

    standardButtons: Dialog.Close

	Overlay.modal: Rectangle {
		color: Theme.dimBackground
	}

    background: Rectangle {
        color: Theme.background
        radius: 12
    }

    header: DialogHeader {
        text: root.title
    }

    footer: DialogButtonBox {
        implicitHeight: 60

        background: Rectangle {
            color: Theme.background
            radius: 12
        }
    }

    width: 650
    height: 600

    padding: 20

    SetScreenModel {
        id: screenModel

        setId: root.setId
        hymnId: root.hymnId
    }

    onOpened: {
        screenModel.reload()
    }

    ScreenPanel {
        anchors.fill: parent

        setMode: true

        model: screenModel

        onToggleScreen: function(row, shown) {
            screenModel.changeScreenVisibility(row, shown)
        }

        onChangeAllScreens: function(shown) {
            screenModel.changeAllScreenVisibility(shown)
        }
    }
}