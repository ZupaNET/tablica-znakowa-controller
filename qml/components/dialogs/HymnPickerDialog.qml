// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Prezenter

Dialog {
    id: root

    property alias currentSetId: hymnBySetModel.parentId

    property bool selectionInProgress: false

    signal selected(int hymnId)

    title: qsTr("Wybierz pieśń")

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

    width: Math.min(
        parent.width * 0.90,
        900
    )

    height: Math.min(
        parent.height * 0.83,
        750
    )

    leftPadding: 20
    rightPadding: 20

    CategoryModel {
        id: categoryModel

        Component.onCompleted:
            reload()
    }

    CategoryHymnModel {
        id: hymnByCategoryModel
        parentId: -2
    }

    HymnModel {
        id: hymnModel

        Component.onCompleted:
            reload()
    }

    SetHymnModel {
        id: hymnBySetModel
    }

    SetFilterProxyModel {
        id: hymnProxy

        sourceModel: hymnModel
        membershipModel: hymnBySetModel
    }

    function reloadDialog() {
        hymnBySetModel.reload()
    }

    onClosed: {
        hymnPanel.resetSelection()

        categoryPanel.searchClearAndUnfocus()
        hymnPanel.searchClearAndUnfocus()

        Qt.inputMethod.hide()

        root.selectionInProgress = false
    }


    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            spacing: 16

            ListPanel {
                id: categoryPanel

                Layout.preferredWidth: root.width * 0.30
                Layout.fillHeight: true

                searchPlaceholder: qsTr("Szukaj kategorii...")

                model: categoryModel

                reorderable: false
                searchEnabled: true
                menuEnabled: false
                editEnabled: false
                toolbarEnabled: false

                onSelected: row => {
                    if(hymnByCategoryModel.parentId === -2)
                        hymnProxy.sourceModel = hymnByCategoryModel

                    hymnByCategoryModel.parentId = categoryModel.get(row).categoryId
                }
            }

            ListPanel {
                id: hymnPanel

                Layout.fillWidth: true
                Layout.fillHeight: true

                searchPlaceholder: qsTr("Szukaj pieśni...")

                model: hymnProxy

                reorderable: false
                searchEnabled: true
                menuEnabled: false
                editEnabled: false
                toolbarEnabled: false
                selectInserted: false

                onSelected: row => {
                    if (root.selectionInProgress)
                        return

                    root.selectionInProgress = true

                    let hymnId

                    if(hymnByCategoryModel.parentId === -2)
                        hymnId = hymnModel.get(hymnProxy.sourceRow(row)).hymnId
                    else
                        hymnId = hymnByCategoryModel.get(hymnProxy.sourceRow(row)).hymnId

                    root.selected(hymnId)
                    root.close()
                }
            }
        }
    }
}