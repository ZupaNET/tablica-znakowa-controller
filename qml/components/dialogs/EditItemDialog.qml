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

    property string initialName: ""
    property int initialCategory: -2
    property int row: -1

    property string placeholderText: qsTr("Nazwa")

    readonly property string name: field.text.trim()

    signal acceptedWithName(string name)
    signal acceptedWithNameAndCategory(string name, int categoryId)

    modal: true
    dim: true

    parent: Overlay.overlay

    anchors.centerIn: Overlay.overlay

    width: 320

    padding: 20

    standardButtons: Dialog.Ok | Dialog.Cancel

    Overlay.modal: Rectangle {
        color: Theme.dimBackground
    }

    CategoryModel {
        id: categoryModel

        Component.onCompleted: {
            reload()
        }
    }

    contentItem: ColumnLayout {
        spacing: 12

        TextField {
            id: field

            Layout.fillWidth: true

            placeholderText: root.placeholderText

            text: root.initialName

            onAccepted: {
                root.accept()
            }
        }

        ComboBox {
            id: categoryBox

            visible: root.initialCategory > -2

            Layout.fillWidth: true

            model: categoryModel
            textRole: "name"

            function updateSelection() {
                currentIndex = -1

                for(let i = 0; i < categoryModel.rowCount(); i++) {
                    if(categoryModel.get(i).categoryId === root.initialCategory)
                    {
                        currentIndex = i
                        return
                    }
                }
            }
        }
    }

    onOpened: {
        field.text = root.initialName
        if(root.initialCategory > -2)
            categoryBox.updateSelection()
        field.forceActiveFocus()
    }

    onAccepted: {
        const value = field.text.trim()

        if(value.length === 0)
            return

        if(root.initialCategory > -2 && categoryBox.currentIndex < 0)
            return

        if(root.initialCategory > -2)
        {
            const categoryId = categoryModel.get(categoryBox.currentIndex).categoryId
            root.acceptedWithNameAndCategory(value, categoryId)
        }
        else
            root.acceptedWithName(value)
    }
}