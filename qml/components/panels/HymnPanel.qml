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

    property alias model: listPanel.model

    property bool setMode: false

    signal selected(int id)
    signal addHymn(string name)
    signal addHymnToSet(int hymnId)
    signal updateHymn(int row, string name, int categoryId)
    signal removeHymn(int row)
    signal moveHymn(int from, int to)

    function resetSelection() {
        listPanel.resetSelection()
    }

    ListPanel {
        id: listPanel

        anchors.fill: parent

        title: root.setMode ? qsTr("Składniki zestawu") : qsTr("Pieśni")

        searchEnabled: !root.setMode

        addButtonText: qsTr("+ Dodaj pieśń")
        addButtonEnable: root.model && root.model.parentId >= 0

        searchPlaceholder: qsTr("Szukaj pieśni...")

        editEnabled: !root.setMode
        reorderable: root.setMode

        onSelected: row => {
            root.selected(model.get(row).hymnId)
        }

        onMoveRequested: (from, to) => {
            root.moveHymn(from, to)
        }

        onAddRequested: {
            if(root.setMode)
                hymnPicker.open()
            else
                addDialog.open()
        }

        onEditRequested: row => {
            const item = model.get(row)

            editDialog.initialName = item.hymnName
            editDialog.initialCategory = item.categoryId
            editDialog.row = row

            editDialog.open()
        }

        onRemoveRequested: row => {
            deleteDialog.row = row
            deleteDialog.open()
        }
    }

    EditItemDialog {
        id: addDialog

        title: qsTr("Nowa pieśń")
        placeholderText: qsTr("Nazwa pieśni")

        onAcceptedWithName: name => {
            root.addHymn(name)
        }
    }

    EditItemDialog {
        id: editDialog

        title: qsTr("Edytuj pieśń")
        placeholderText: qsTr("Nazwa pieśni")

        onAcceptedWithNameAndCategory: (name, category) => {
            root.updateHymn(row, name, category)
        }
    }

    HymnPickerDialog {
        id: hymnPicker

        existingModel: root.model

        onSelected: hymnId => {
            root.addHymnToSet(hymnId)
        }
    }

    ConfirmDialog {
        id: deleteDialog

        title: qsTr("Usunąć pieśń?")

        message: qsTr("Czy na pewno chcesz usunąć tę pieśń?")

        onAccepted: {
            root.removeHymn(row)
        }
    }
}