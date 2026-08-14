// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml.Models

import Prezenter

Item {
    id: root

    property alias model: delegateModel.model

    property bool setMode: false
    property bool showPreview: AppSettings.showPreview

    signal selected(int id, int row)
    signal addScreen()
    signal removeScreen(int row)
    signal duplicateScreen(int row)
    signal moveScreen(int from, int to)

    signal changeAllScreens(bool visible)
    signal toggleScreen(int row, bool visible)

    function resetSelection()
    {
        list.currentIndex = -1
    }

    DelegateModel {
        id: delegateModel

        delegate: ScreenPanelDelegate {
            listView: list
            dm: delegateModel

            setMode: root.setMode
            showPreview: root.showPreview

            onClicked: {
                list.currentIndex = index
                root.selected(model.id, index)
            }

            onMove: (from, to) => {
                root.moveScreen(from, to)
            }

            onDuplicate: {
                root.duplicateScreen(index)
            }

            onRemove: {
                deleteDialog.row = index
                deleteDialog.open()
            }

            onToggleShown: shown => {
                root.toggleScreen(index, shown)
            }

            onDragStarted: it => list.draggedItem = it
            onDragFinished: list.draggedItem = null
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        Label {
            Layout.fillWidth: true

            text: qsTr("Slajdy")

            font.pixelSize: 20
            font.bold: true

            color: Theme.text
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            ListView {
                id: list

                property Item draggedItem: null

                anchors.fill: parent

                spacing: 8

                clip: true

                model: delegateModel

                currentIndex: -1

                ScrollBar.vertical: ScrollBar {
                    width: 8
                    policy: ScrollBar.AlwaysOn
                }

                Timer {
                    id: autoScrollTimer

                    interval: 16
                    repeat: true
                    running: list.draggedItem !== null

                    onTriggered: {
                        const item = list.draggedItem

                        if (!item || !item.Drag.active)
                            return

                        const y = item.y + item.height / 2

                        const edge = 60
                        const maxSpeed = 12

                        let newContentY = list.contentY

                        if (y < edge) {
                            const factor = 1 - Math.max(0, y) / edge

                            newContentY = Math.max(
                                0,
                                list.contentY - (2 + factor * maxSpeed)
                            )
                        }
                        else if (y > list.height - edge) {
                            const distance = y - (list.height - edge)
                            const factor = Math.min(1, distance / edge)

                            const maxContentY = Math.max(
                                0,
                                list.contentHeight - list.height
                            )

                            newContentY = Math.min(
                                maxContentY,
                                list.contentY + (2 + factor * maxSpeed)
                            )
                        }

                        if (newContentY !== list.contentY) {
                            list.contentY = newContentY

                            const hotSpot = item.Drag.hotSpot

                            item.Drag.hotSpot = Qt.point(
                                hotSpot.x,
                                hotSpot.y + 0.01
                            )

                            item.Drag.hotSpot = hotSpot
                        }
                    }
                }
            }

            ListPanelFade {
                listView: list
                isTop: true
            }

            ListPanelFade {
                listView: list
                isTop: false
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: toolbar.implicitHeight + 5

            color: "transparent"

            RowLayout {
                id: toolbar

                anchors.fill: parent

                Button {
                    visible: !root.setMode

                    text: qsTr("+ Dodaj slajd")

                    enabled: root.model && root.model.hymnId >= 0

                    onClicked: {
                        root.addScreen()
                    }
                }

                ToolButton {
                    visible: root.setMode

                    text: Icon.eyeOutline

                    enabled: root.model && root.model.hymnId >= 0

                    font.family: "Material Design Icons"
                    font.pixelSize: 22

                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Pokaż wszystkie")

                    onClicked: {
                        root.changeAllScreens(true)
                    }
                }

                ToolButton {
                    visible: root.setMode

                    text: Icon.eyeOffOutline

                    enabled: root.model && root.model.hymnId >= 0

                    font.family: "Material Design Icons"
                    font.pixelSize: 22

                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Ukryj wszystkie")

                    onClicked: {
                        root.changeAllScreens(false)
                    }
                }

                Item {
                    visible: root.setMode
                    Layout.fillWidth: true
                }

                Switch {
                    visible: root.setMode

                    checked: root.showPreview

                    text: qsTr("Pokaż podgląd")

                    onToggled: {
                        root.showPreview = checked
                        AppSettings.showPreview = checked
                    }
                }
            }
        }
    }

    ConfirmDialog {
        id: deleteDialog

        title: qsTr("Usunąć slajd?")

        message: qsTr("Czy na pewno chcesz usunąć ten slajd?")

        onAccepted: {
            root.removeScreen(row)
        }
    }

    Connections {
        target: root.model

        function onRowsInserted(parent, first, last) {
            if(last < 0)
                return

            Qt.callLater(function () {
                list.positionViewAtIndex(last, ListView.End)
            })
        }
    }
}