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
        if (root.selectedId < 0) {
            list.currentIndex = -1
            return
        }

        for (let i = 0; i < list.count; ++i) {
            if (list.model.data(list.model.index(i, 0), Qt.UserRole + 1) === root.selectedId) {
                list.currentIndex = i
                return
            }
        }

        list.currentIndex = -1
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
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                id: list

                anchors.fill: parent

                clip: true

                model: root.searchText !== "" ? proxy : proxy.sourceModel

                ScrollBar.vertical: ScrollBar {
                    width: 8
                    policy: ScrollBar.AlwaysOn
                }

                delegate: ListPanelDelegate {
                    listView: list
                    itemIndex: index

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

                    onMoveRequested: (from, to) => {
                        root.moveRequested(proxy.sourceRow(from), proxy.sourceRow(to))
                        if(listView.currentIndex === from) {
                            listView.currentIndex = to
                        }
                    }

                    onEditRequested: {
                        root.editRequested(proxy.sourceRow(index))
                    }

                    onRemoveRequested: {
                        root.removeRequested(proxy.sourceRow(index))
                    }
                }

                onModelChanged: {
                    Qt.callLater(root.restoreSelection)
                }

                Component.onCompleted: {
                    currentIndex = -1
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
                list.currentIndex = last

                root.selected(last)

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

                list.currentIndex = newIndex

                root.selected(newIndex)
            }
            else if(list.currentIndex > last) {
                list.currentIndex -= last - first + 1
            }
        }
    }
}