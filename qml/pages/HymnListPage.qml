import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Prezenter

Item {
    id: root

    property int selectedCategoryId: -1
    property int selectedHymnId: -1

    CategoryModel {
        id: categoryModel

        Component.onCompleted:
            reload()
    }

    CategoryHymnModel {
        id: hymnModel

        Component.onCompleted:
            reload()
    }

    ScreenModel {
        id: screenModel
    }

    Rectangle {
        anchors.fill: parent
        color: "#ffffff"

        // Top Bar
        Rectangle {
            id: topBar

            height: 50

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            color: "#474747"


            Button {
                text: qsTr("Powrót")

                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }

                flat: true

                Material.foreground: "white"

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
                text: qsTr("Prezentuj >")

                enabled: root.selectedHymnId >= 0

                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                flat: true

                Material.foreground: "white"

                onClicked: {
                    Navigation.push(Qt.resolvedUrl("PresentationPage.qml"),{"currentSet": root.selectedHymnId, "showHymnMode": true})
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
                Layout.preferredWidth:  parent.width * 0.25

                model: categoryModel

                selectedId: root.selectedCategoryId

                onSelected: id => {
                    root.selectedCategoryId = id

                    hymnModel.parentId = id

                    root.selectedHymnId = -1
                    screenModel.hymnId = -1
                }

                onAddCategory: name => {
                    categoryModel.add(name)
                }

                onUpdateCategory: (row, name) => {
                    categoryModel.update(row, name)
                }

                onRemoveCategory: row => {
                    if(categoryModel.get(row).categoryId === root.selectedCategoryId)
                    {
                        hymnModel.parentId = -1
                        root.selectedCategoryId = -1
                    }
                    categoryModel.removeRow(row)
                    hymnModel.reload()
                }

            }

            HymnPanel {
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.35

                model: hymnModel

                selectedId: root.selectedHymnId

                onSelected: id => {
                    root.selectedHymnId = id
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
                    if (hymnModel.get(row).hymnId === root.selectedHymnId) {
                        root.selectedHymnId = -1
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
                            hymnId: root.selectedHymnId,
                            screenModel: screenModel
                        }
                    )
                }

                onAddScreen: {
                    Navigation.push(
                        Qt.resolvedUrl("ScreenEditorPage.qml"),
                        {
                            hymnId: root.selectedHymnId,
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
