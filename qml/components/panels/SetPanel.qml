// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

import QtQuick

import Prezenter

Item {
    id: root

    property alias model: listPanel.model

    signal selected(int setId)
    signal addSet(string name)
    signal updateSet(int row, string name)
    signal removeSet(int row)
    signal moveSet(int from, int to)

    ListPanel {
        id: listPanel

        anchors.fill: parent

        title: qsTr("Zestawy")

        addButtonText: qsTr("+ Dodaj zestaw")

        searchPlaceholder: qsTr("Szukaj zestawu...")

        onSelected: row => {
            root.selected(root.model.get(row).setId)
        }

        onAddRequested: {
            addDialog.open()
        }

        onEditRequested: row => {
            editDialog.row = row
            editDialog.initialName = root.model.get(row).setName
            editDialog.open()
        }

        onRemoveRequested: row => {
            deleteDialog.row = row
            deleteDialog.open()
        }

        onMoveRequested: (from, to) => {
            root.moveSet(from, to)
        }
    }

    EditItemDialog {
        id: addDialog

        title: qsTr("Nowy zestaw")
        placeholderText: qsTr("Nazwa zestawu")

        onAcceptedWithName: name => {
            root.addSet(name)
        }
    }

    EditItemDialog {
        id: editDialog

        title: qsTr("Zmiana nazwy zestawu")
        placeholderText: qsTr("Nazwa zestawu")

        onAcceptedWithName: name => {
            root.updateSet(row, name)
        }
    }

    ConfirmDialog {
        id: deleteDialog

        title: qsTr("Usunąć zestaw?")

        message: qsTr("Czy na pewno chcesz usunąć ten zestaw?")

        onAccepted: {
            root.removeSet(row)
        }
    }

}