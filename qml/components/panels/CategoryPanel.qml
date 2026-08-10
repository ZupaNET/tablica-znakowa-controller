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

    signal selected(int categoryId)
    signal addCategory(string name)
    signal updateCategory(int row, string name)
    signal removeCategory(int row)
    signal moveCategory(int from, int to)

    ListPanel {
        id: listPanel

        anchors.fill: parent

        title: qsTr("Kategorie")

        addButtonText: qsTr("+ Dodaj kategorię")

        searchPlaceholder: qsTr("Szukaj kategorii...")

        minIndexReorder: 1

        onSelected: row => {
            root.selected(root.model.get(row).categoryId)
        }

        onAddRequested: {
            addDialog.open()
        }

        onEditRequested: row => {
            editDialog.row = row
            editDialog.initialName = root.model.get(row).categoryName
            editDialog.open()
        }

        onRemoveRequested: row => {
            deleteDialog.row = row
            deleteDialog.open()
        }

        onMoveRequested: (from, to) => {
            root.moveCategory(from, to)
        }
    }

    EditItemDialog {
        id: addDialog

        title: qsTr("Nowa kategoria")
        placeholderText: qsTr("Nazwa kategorii")

        onAcceptedWithName: name => {
            root.addCategory(name)
        }
    }

    EditItemDialog {
        id: editDialog

        title: qsTr("Zmiana nazwy kategorii")
        placeholderText: qsTr("Nazwa kategorii")

        onAcceptedWithName: name => {
            root.updateCategory(row, name)
        }
    }

    ConfirmDialog {
        id: deleteDialog

        title: qsTr("Usunąć kategorię?")

        message: qsTr("Czy na pewno chcesz usunąć tę kategorię?")

        onAccepted: {
            root.removeCategory(row)
        }
    }

}