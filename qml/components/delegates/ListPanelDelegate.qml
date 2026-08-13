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

Item {
    id: root

    property ListView listView: null
    property bool isSearching: false
    property int minIndexReorder: 0

    property bool reorderable: true
    property bool menuEnabled: true
    property bool editEnabled: true

    property bool current: false

    signal clicked()
    signal moveRequested(int from, int to)
    signal editRequested()
    signal removeRequested()

    width: listView ? listView.width - listView.rightMargin - listView.ScrollBar.vertical.width - 1 : 0

    height: 49

    Behavior on height {
        NumberAnimation {
            duration: 150
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right

        height: 45

        radius: 6

        color: root.listView && root.current ? Theme.listItemSelected : Theme.listItem
        border.color: Theme.listItemBorder

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
                visible: root.reorderable && index >= root.minIndexReorder

                text: Icon.arrowUp

                enabled: index > root.minIndexReorder && !root.isSearching

                font.family: "Material Design Icons"
                font.pixelSize: 20

                onClicked: {
                    root.moveRequested(index, index - 1)
                }
            }

            ToolButton {
                visible: root.reorderable && index >= root.minIndexReorder

                text: Icon.arrowDown

                enabled: index < root.listView.count - 1 && !root.isSearching

                font.family: "Material Design Icons"
                font.pixelSize: 20

                onClicked: {
                    root.moveRequested(index, index+1)
                }
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

                    Material.foreground: "firebrick"

                    onTriggered: {
                        root.removeRequested()
                    }
                }
            }
        }

        TapHandler {
            id: tap
            gesturePolicy: TapHandler.ReleaseWithinBounds
            onTapped: root.clicked()
        }
    }
}
