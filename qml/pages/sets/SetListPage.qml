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

    SetModel {
        id: setModel

        Component.onCompleted:
            reload()
    }

    SetHymnModel {
        id: hymnModel

        Component.onCompleted:
            reload()
    }

    SetScreenModel {
        id: screenModel
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.background
    }

    PageHeader {
        id: topBar

        title: qsTr("Zestawy")

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

            enabled: hymnModel.parentId >= 0

            flat: true

            onClicked: {
                const page = Navigation.push(
                    Qt.resolvedUrl("../presentation/PresentationPage.qml"),
                    {
                        "presentId": hymnModel.parentId
                    }
                )

                if(page) {
                    page.presentationClosed.connect(function(){
                        screenModel.reload()
                    })

                    page.goToHymn(screenModel.hymnId)
                }
            }
        }
    }

    // Body
    RowLayout {
        anchors {
            top: topBar.bottom
            bottom: parent.bottom

            left: parent.left
            right: parent.right

            margins: 10
        }

        spacing: 10

        SetPanel {
            id: setPanel

            Layout.fillHeight: true
            Layout.preferredWidth:  parent.width * 0.32

            model: setModel

            onSelected: id => {
                hymnModel.parentId = id
                screenModel.setId = id
                screenModel.hymnId = -1
                hymnPanel.resetSelection()
            }

            onAddSet: name => {
                setModel.add(name)
            }

            onUpdateSet: (row, name) => {
                setModel.update(row, name)
            }

            onRemoveSet: row => {
                if(setModel.get(row).setId === hymnModel.parentId)
                {
                    screenModel.setId = -1
                    hymnModel.parentId = -1
                }
                setModel.removeRow(row)
                hymnModel.reload()
            }

            onMoveSet: (from, to) => {
                setModel.move(from, to)
            }

        }

        HymnPanel {
            id: hymnPanel
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.32

            setMode: true

            model: hymnModel

            onSelected: id => {
                screenModel.hymnId = id
            }

            onAddHymnToSet: id => {
                hymnModel.addHymn(id)
            }

            onRemoveHymn: row => {
                if (hymnModel.get(row).hymnId === screenModel.hymnId) {
                    screenModel.hymnId = -1
                    screenModel.reload()
                }
                hymnModel.removeHymn(row)
            }

            onMoveHymn: (from, to) => {
                hymnModel.move(from, to)
            }
        }

        ScreenPanel {
            Layout.fillHeight: true
            Layout.fillWidth: true

            setMode: true

            model: screenModel

            onChangeAllScreens: visible => {
                screenModel.changeAllScreenVisibility(visible)
            }

            onToggleScreen: (row, visible) => {
                screenModel.changeScreenVisibility(row,visible)
            }
        }
    }
}
