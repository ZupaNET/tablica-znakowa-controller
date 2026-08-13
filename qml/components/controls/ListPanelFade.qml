// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

import QtQuick

Rectangle {
    id: root

    property ListView listView
    property bool isTop: true

    property color fadeColor: Theme.background

    anchors.top: root.isTop ? parent.top : undefined
    anchors.bottom: root.isTop ? undefined : parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right

    height: 8
    z: 10

    gradient: Gradient {
        GradientStop {
            position: root.isTop ? 1 : 0
            color: "transparent"
        }
        GradientStop {
            position: root.isTop ? 0 : 1
            color: root.fadeColor
        }
    }

    opacity: root.isTop ? root.listView.contentY > 0 : root.listView.contentY + root.listView.height < root.listView.contentHeight
    visible: opacity > 0

    Behavior on opacity {
        NumberAnimation {
            duration: 180
            easing.type: Easing.OutCubic
        }
    }
}
