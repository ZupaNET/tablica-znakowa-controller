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

    ScreenModel {
        id: screenModel
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.background

        // Top Bar
        Rectangle {
            id: topBar

            height: 50

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            color: Theme.header


            Button {
                text: Icon.arrowLeft

                Material.background: "transparent"
                Material.foreground: "white"
                font.family: "Material Design Icons"
                font.pixelSize: 20

                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }

                flat: true

                onClicked: {
                    Navigation.pop()
                }
            }

            Text {
                anchors.centerIn: parent

                text: qsTr("Lista pieśni")

                color: "white"

                font.pixelSize: 22
                font.bold: true
            }

            Button {
                text: qsTr("Prezentuj") + " " + Icon.chevronRight

                Material.background: "transparent"
                Material.foreground: "white"
                font.family: "Material Design Icons"
                font.pixelSize: 20

                enabled: screenModel.hymnId >= 0

                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                flat: true

                onClicked: {
                    Navigation.push(Qt.resolvedUrl("PresentationPage.qml"),{"currentSet": screenModel.hymnId, "showHymnMode": true})
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

            CategoryPanel {
                Layout.fillHeight: true
                Layout.preferredWidth:  parent.width * 0.30

                model: categoryModel

                onSelected: id => {
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

                model: hymnModel

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

                model: screenModel

                onSelected: function(id, row) {
                    Navigation.push(
                        Qt.resolvedUrl("ScreenEditorPage.qml"),
                        {
                            screenIdx: row,
                            screenModel: screenModel
                        }
                    )
                }

                onAddScreen: {
                    Navigation.push(
                        Qt.resolvedUrl("ScreenEditorPage.qml"),
                        {
                            screenModel: screenModel,
                        }
                    )
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

}
