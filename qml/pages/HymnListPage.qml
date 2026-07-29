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
                text: "Powrót"

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

                text: "Biblioteka pieśni"

                color: "white"

                font.pixelSize: 22
                font.bold: true
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

                onRemoveCategory: row => {
                    categoryModel.removeRow(row)
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

                onRemoveHymn: row => {
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

                onRemoveScreen: row => {
                    screenModel.removeRow(row)
                }
            }
        }
    }

}
