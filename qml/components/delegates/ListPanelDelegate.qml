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

    property ListView listView: null
    property int itemIndex: -1
    property int dragStartIndex: -1
    property int dropIndex: -1

    property bool isSearching: false
    property int minIndexReorder: 0

    property bool reorderable: true
    property bool menuEnabled: true
    property bool editEnabled: true

    property bool current: false
    property bool held: false
    property bool dropTarget: false
    property bool dropAfter: false

    signal moveRequested(int from, int to)
    signal editRequested()
    signal removeRequested()

    width: listView ? listView.width - listView.rightMargin - listView.ScrollBar.vertical.width - 1 : 0

    height: 49

    acceptedButtons: Qt.LeftButton

    drag.target: held ? content : undefined
    drag.axis: Drag.YAxis

    onPressAndHold: {
        if (!reorderable || isSearching)
            return

        if (index < minIndexReorder)
            return

        dragStartIndex = index
        dropIndex = index
        held = true
    }

    onReleased: {
        if (held) {
            const from = dragStartIndex
            const to = dropIndex

            if (from >= minIndexReorder && to >= minIndexReorder && from !== to) {
                moveRequested(from, to)
            }
        }

        held = false
        dragStartIndex = -1
        dropIndex = -1
        dropTarget = false
        dropAfter = false
    }

    Behavior on height {
        NumberAnimation {
            duration: 150
        }
    }

    Rectangle {
        id: dropIndicator

        visible: root.dropTarget

        anchors.left: parent.left
        anchors.right: parent.right

        y: root.dropAfter
           ? root.height - height
           : 0

        height: 3
        radius: 1.5

        color: Theme.listItemDropIndicator

        z: 100
    }

    Rectangle {
        id: content

        anchors.left: parent.left
        anchors.right: parent.right

        height: 45

        radius: 6

        color: {
            const selected = root.listView && root.current
            const reorderDisabled = index < root.minIndexReorder

            if (root.held)
                return selected
                    ? Theme.listItemSelectedDrag
                    : Theme.listItemDrag

            if (!root.isSearching && reorderDisabled)
                return selected
                    ? Theme.listItemSelectedReorderDisabled
                    : Theme.listItemReorderDisabled

            if (selected)
                return Theme.listItemSelected

            return Theme.listItem
        }

        border.color: Theme.listItemBorder

        opacity: root.held ? 0.60 : 1

        Drag.active: root.held
        Drag.source: root

        Drag.hotSpot.x: width / 2
        Drag.hotSpot.y: height / 2

        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 100
            }
        }

        RowLayout {
            anchors.fill: parent

            anchors.leftMargin: 12
            anchors.rightMargin: 8

            Label {
                Layout.fillWidth: true

                text: model.name === "" ? qsTr("Bez nazwy") : model.name

                font.bold: root.listView && root.current

                elide: Text.ElideRight

                color: Theme.text
            }

            ToolButton {
                id: moreButton

                visible: root.menuEnabled && index >= root.minIndexReorder

                enabled: !root.isSearching

                text: Icon.dotsVertical

                font.family: "Material Design Icons"
                font.pixelSize: 20

                onClicked: menu.open()
            }

            Menu {
                id: menu

                x: moreButton.x + moreButton.width - width
                y: moreButton.height

                Loader {
                    active: root.editEnabled

                    sourceComponent: MenuItem {
                        text: qsTr("Edytuj")

                        onTriggered: {
                            root.editRequested()
                        }
                    }
                }

                Loader {
                    active: root.editEnabled

                    sourceComponent: MenuSeparator {}
                }

                MenuItem {
                    text: qsTr("Usuń")

                    Material.foreground: Theme.danger

                    onTriggered: {
                        root.removeRequested()
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

        enabled: root.reorderable && !root.isSearching && root.itemIndex >= root.minIndexReorder

        onEntered: drag => {
            const source = drag.source

            if (!source || source === root)
                return

            if (!source.held)
                return

            const from = source.dragStartIndex
            const to = root.itemIndex

            if (from < 0 || to < 0)
                return

            if (from < root.minIndexReorder)
                return

            if (to < root.minIndexReorder)
                return

            if (from === to)
                return

            root.dropTarget = true
            root.dropAfter = from < to

            source.dropIndex = to
        }

        onExited: {
            root.dropTarget = false
            root.dropAfter = false
        }
    }
}
