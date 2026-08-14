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

MouseArea {
    id: root

    required property int index
    required property var model
    required property ListView listView
    required property DelegateModel dm

    property bool setMode: false
    property bool showPreview: true

    property bool held: false
    property int dragStartIndex: -1

    signal move(int from, int to)
    signal duplicate()
    signal remove()
    signal toggleShown(bool shown)

    signal dragStarted(Item item)
    signal dragFinished()

    implicitHeight: setMode ? (showPreview ? 290 : 54) : 290
    width: listView.width - listView.ScrollBar.vertical.width - 1

    acceptedButtons: Qt.LeftButton

    drag.target: held ? content : undefined
    drag.axis: Drag.YAxis

    onPressAndHold: {
        if (setMode)
            return

        dragStartIndex = DelegateModel.itemsIndex
        held = true

        dragStarted(content)
    }

    onReleased: {
        if (held) {
            dragFinished()

            const from = dragStartIndex
            const to = DelegateModel.itemsIndex

            if (from !== to) {
                move(from, to)
            }
        }

        held = false
        dragStartIndex = -1
    }

    Rectangle {
        id: content

        width: root.width
        height: root.height

        radius: 8

        color: {
            if (root.held) return Theme.listItemDrag
            return root.setMode ? (model.shown ? Theme.successBackground : Theme.inactiveItem) : Theme.listItem
        }

        border.color: root.setMode ? (model.shown ? Theme.successBorder : Theme.inactiveBorder) : Theme.listItemBorder

        Drag.active: root.held
        Drag.source: root

        Drag.hotSpot.x: width / 2
        Drag.hotSpot.y: height / 2

        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }


        ColumnLayout {
            anchors.fill: parent
            anchors.margins: root.setMode ? 0 : 8

            spacing: 6

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: root.setMode ? root.showPreview : true
                Layout.minimumHeight: 0

                visible: root.setMode ? root.showPreview : true

                TablicaScreen {
                    anchors.fill: parent
                    anchors.topMargin: root.setMode ? 8 : 0
                    anchors.leftMargin: root.setMode ? 8 : 0
                    anchors.rightMargin: root.setMode ? 8 : 0

                    content: model.text
                    hymnFont: model.font
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 34

                Layout.leftMargin: root.setMode ? 12 : 0
                Layout.rightMargin: root.setMode ? 8 : 0

                Layout.topMargin: root.setMode ? 10 : 0
                Layout.bottomMargin: root.setMode ? 10 : 0

                Rectangle {
                    visible: root.setMode

                    Layout.preferredHeight: 34
                    Layout.preferredWidth: 34

                    radius: 17

                    color: model.shown ? Theme.badgeActive : Theme.badgeInactive

                    Label {
                        anchors.centerIn: parent

                        text: root.index + 1

                        color: "white"
                        font.bold: true
                    }
                }

                Label {
                    Layout.fillWidth: true

                    text: root.setMode ? model.excerpt : qsTr("Slajd") + " " + (root.index + 1)

                    elide: Text.ElideRight

                    font.pixelSize: root.setMode ? 15 : 14
                    font.bold: !root.setMode

                    color: Theme.text
                }

                Switch {
                    visible: root.setMode

                    checked: model.shown ? model.shown : false

                    onToggled: {
                        root.toggleShown(checked)
                    }
                }

                ToolButton {
                    visible: !root.setMode

                    text: Icon.contentCopy

                    font.family: "Material Design Icons"
                    font.pixelSize: 20

                    onClicked: {
                        root.duplicate()
                    }
                }

                ToolButton {
                    visible: !root.setMode

                    text: Icon.iDelete

                    font.family: "Material Design Icons"
                    font.pixelSize: 20

                    Material.foreground: "firebrick"

                    onClicked: {
                        root.remove()
                    }
                }
            }
        }

        states: State {
            when: root.held

            ParentChange {
                target: content
                parent: root.listView
            }

            AnchorChanges {
                target: content

                anchors {
                    left: undefined
                    right: undefined
                }
            }
        }
    }

    DropArea {
        anchors.fill: parent
        anchors.margins: 10

        enabled: !root.setMode

        onEntered: drag => {
            const source = drag.source

            if (!source || source === root || !source.held)
                return

            const from = source.DelegateModel.itemsIndex
            const to = root.DelegateModel.itemsIndex

            if (from === to)
                return

            root.dm.items.move(from, to)
        }
    }
}