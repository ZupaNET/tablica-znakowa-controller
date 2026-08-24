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

Item {
    id: root

    CategoryModel {
        id: categoryModel

        Component.onCompleted:
            reload()
    }

    CategoryHymnModel {
        id: hymnModel

        parentId: -2

        Component.onCompleted:
            reload()
    }

    HymnModel {
        id: fullHymnModel

        Component.onCompleted:
            reload()
    }

    ScreenModel {
        id: screenModel
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.background
    }

    PageHeader {
        id: topBar

        title: qsTr("Lista pieśni")

        Button {
            anchors {
                right: parent.right
                rightMargin: 10
                verticalCenter: parent.verticalCenter
            }

            text: qsTr("Prezentuj") + " " + Icon.chevronRight

            Material.background: "transparent"
            Material.foreground: "white"
            font.family: "Material Design Icons"
            font.pixelSize: 20

            enabled: screenModel.hymnId >= 0

            flat: true

            onClicked: {
                Navigation.push(Qt.resolvedUrl("../presentation/PresentationPage.qml"),{"presentId": screenModel.hymnId, "hymnMode": true})
            }
        }
    }

    RowLayout {
        anchors {
            top: topBar.bottom
            bottom: parent.bottom

            left: parent.left
            right: parent.right

            margins: 10
        }

        spacing: 10

        CategoryPanel {
            id: categoryPanel
            Layout.fillHeight: true
            Layout.preferredWidth:  parent.width * 0.30

            model: categoryModel

            onSelected: id => {
                if(hymnModel.parentId === -2)
                    hymnPanel.model = hymnModel

                hymnModel.parentId = id
                screenModel.hymnId = -1
                hymnPanel.resetSelection()
            }

            onAddCategory: name => {
                categoryModel.add(name)
            }

            onUpdateCategory: (row, name) => {
                categoryModel.update(row, name)
            }

            onRemoveCategory: row => {
                if(categoryModel.get(row).categoryId === hymnModel.parentId)
                    hymnModel.parentId = -1

                categoryModel.removeRow(row)
                hymnModel.reload()
            }

            onMoveCategory: (from, to) => {
                categoryModel.move(from, to)
            }

        }

        HymnPanel {
            id: hymnPanel
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.30

            model: fullHymnModel

            onSelected: id => {
                screenModel.hymnId = id
            }

            onAddHymn: name => {
                hymnModel.add(name)
            }

            onUpdateHymn: (row, name, categoryId) => {
                if(name !== hymnModel.get(row).hymnName)
                    hymnModel.update(row, name)

                if(categoryId !== hymnModel.get(row).categoryId)
                    hymnModel.changeCategory(row, categoryId)

            }

            onRemoveHymn: row => {
                if (hymnModel.get(row).hymnId === screenModel.hymnId) {
                    screenModel.hymnId = -1
                    screenModel.reload()
                }
                hymnModel.removeRow(row)
            }
        }

        ScreenPanel {
            Layout.fillHeight: true
            Layout.fillWidth: true

            setMode: false

            model: screenModel

            onSelected: function(id, row) {
                const page = Navigation.push(
                    Qt.resolvedUrl("../editors/ScreenEditorPage.qml"),
                    {
                        row: row,
                        content: screenModel.get(row).text,
                        fontIndex: screenModel.get(row).font
                    }
                )

                if(page)
                    page.accepted.connect(function(content, fontIndex){
                        screenModel.update(row, content, fontIndex)
                    })
            }

            onAddScreen: {
                const page = Navigation.push(
                    Qt.resolvedUrl("../editors/ScreenEditorPage.qml")
                )

                if(page)
                    page.accepted.connect(function(content, fontIndex){
                        screenModel.add(content, fontIndex)
                    })
            }

            onDuplicateScreen: row => {
                screenModel.duplicate(row)
            }

            onRemoveScreen: row => {
                screenModel.removeRow(row)
            }

            onMoveScreen: (from, to) => {
                screenModel.move(from, to)
            }
        }
    }
}
