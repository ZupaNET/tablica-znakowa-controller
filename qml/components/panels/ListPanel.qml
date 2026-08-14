// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQml.Models

import Prezenter

Item {
    id: root

    property alias model: proxy.sourceModel
    property string title: ""
    property string addButtonText: ""
    property bool addButtonEnable: true
    property string searchPlaceholder: qsTr("Szukaj...")
    property bool reorderable: true
    property bool searchEnabled: true
    property bool menuEnabled: true
    property bool editEnabled: true
    property int minIndexReorder: 0
    property string searchText: ""
    property bool toolbarEnabled: true
    property bool selectInserted: true

    property int selectedId: -1

    signal selected(int row)
    signal addRequested()
    signal editRequested(int row)
    signal removeRequested(int row)
    signal moveRequested(int from, int to)

    function resetSelection() {
        list.currentIndex = -1
    }

    function searchClearAndUnfocus()
    {
        searchBox.clear()
        searchBox.focus = false
    }

    FilterProxyModel {
        id: proxy

        filterText: root.searchText
        filterRole: "name"
    }

    function restoreSelection() {
        list.currentIndex = -1

        if (root.selectedId < 0)
            return

        const sourceModel = proxy.sourceModel

        for (let row = 0; row < sourceModel.rowCount(); ++row) {
            const sourceIndex = sourceModel.index(row, 0)

            if (sourceModel.data(sourceIndex, Qt.UserRole + 1) !== root.selectedId)
                continue

            const proxyRow = root.searchText === ""
                ? row
                : proxy.mapFromSource(sourceIndex).row

            if (proxyRow >= 0) {
                list.currentIndex = proxyRow
                return
            }
        }
    }

    DelegateModel {
        id: delegateModel

        model: root.searchText !== "" ? proxy : proxy.sourceModel

        delegate: ListPanelDelegate {
            listView: list
            dm: delegateModel
            isSearching: root.searchText !== ""

            minIndexReorder: root.minIndexReorder

            reorderable: root.reorderable
            menuEnabled: root.menuEnabled
            editEnabled: root.editEnabled

            current: ListView.isCurrentItem

            onClicked: {
                listView.currentIndex = index
                root.selectedId = model.id
                root.selected(proxy.sourceRow(index))
            }

            onDoubleClicked: {
                // Do nothing
            }

            onMoveRequested: (from, to) => {
                root.moveRequested(
                    proxy.sourceRow(from),
                    proxy.sourceRow(to)
                )
            }

            onEditRequested: {
                root.editRequested(proxy.sourceRow(index))
            }

            onRemoveRequested: {
                root.removeRequested(proxy.sourceRow(index))
            }

            onDragStarted: it => list.draggedItem = it
            onDragFinished: list.draggedItem = null
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        Label {
            visible: root.title !== ""

            text: root.title
            font.pixelSize: 20
            font.bold: true

            color: Theme.text
        }

        TextField {
            id: searchBox

            visible: root.searchEnabled

            Layout.fillWidth: true
            Layout.rightMargin: list.ScrollBar.vertical.width - 1
            Layout.preferredHeight: 45

            placeholderText: root.searchPlaceholder

            onTextChanged: {
                root.searchText = text

                Qt.callLater(root.restoreSelection)
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                id: list

                property Item draggedItem: null

                anchors.fill: parent

                clip: true

                model: delegateModel

                ScrollBar.vertical: ScrollBar {
                    width: 8
                    policy: ScrollBar.AlwaysOn
                }

                Component.onCompleted: {
                    currentIndex = -1
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
            visible: root.toolbarEnabled
            Layout.fillWidth: true
            Layout.preferredHeight: addButton.implicitHeight + 5

            color: "transparent"

            Button {
                id: addButton

                enabled: root.addButtonEnable && root.searchText === ""

                text: root.addButtonText

                onClicked: root.addRequested()
            }
        }
    }

    Connections {
        target: root.model

        function onRowsInserted(parent, first, last) {
            if(last < 0)
                return

            Qt.callLater(function() {
                if (root.selectInserted)
                {
                    list.currentIndex = last
                    root.selected(last)
                }

                list.positionViewAtIndex(last, ListView.End)
            })
        }

        function onRowsRemoved(parent, first, last) {
            if(first < 0)
                return

            if(list.currentIndex >= first && list.currentIndex <= last) {
                let newIndex = first - 1

                if(newIndex < 0 && list.count > 0)
                    newIndex = 0

                if(list.count === 0) {
                    list.currentIndex = -1
                    return
                }

                if (root.selectInserted)
                {
                    list.currentIndex = newIndex
                    root.selected(newIndex)
                }
            }
            else if(list.currentIndex > last) {
                list.currentIndex -= last - first + 1
            }
        }
    }
}