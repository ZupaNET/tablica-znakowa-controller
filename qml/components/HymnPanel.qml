import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Prezenter

import "../Icon.js" as MdiFont

Item {
    id: root

    property alias model: list.model
    property int selectedId: -1
    property int pendingRemoveRow: -1
    property string hymnSearchText: ""

    property bool setMode: false

    signal selected(int id)
    signal addHymn(string name)
    signal addHymnToSet(int hymnId)
    signal updateHymn(int row, string name, int categoryId)
    signal removeHymn(int row)
    signal moveHymn(int from, int to)

    Dialog {
        id: addDialog

        title: "Nowa pieśń"
        modal: true

        parent: Overlay.overlay
		anchors.centerIn: Overlay.overlay
        dim: true

        standardButtons: Dialog.Ok | Dialog.Cancel

        width: 320
        padding: 20

        contentItem: TextField {
            id: hymnName

            placeholderText: "Nazwa pieśni"

            onAccepted: addDialog.accept()
        }

        onOpened: {
            hymnName.clear()
            hymnName.forceActiveFocus()
        }

        onAccepted: {
            const name = hymnName.text.trim()
            if (name.length > 0)
                root.addHymn(name)
        }
    }

    HymnPickerDialog {
        id: hymnPicker

        existingModel: root.model

        onSelected: hymnId => {
            root.addHymnToSet(hymnId)
        }
    }

    Dialog {
        id: updateDialog

        title: "Edytuj pieśń"
        modal: true

        property string initialName: ""
        property int initialCategoryId: -2
        property int hymnRow: -1

        parent: Overlay.overlay
		anchors.centerIn: Overlay.overlay
        dim: true

        standardButtons: Dialog.Ok | Dialog.Cancel

        width: 400
        padding: 20

        CategoryModel {
            id: categoryModel

            Component.onCompleted: reload()
        }
        contentItem: ColumnLayout {
            spacing: 12

            TextField {
                id: newHymnName

                Layout.fillWidth: true

                placeholderText: "Nazwa pieśni"
                text: updateDialog.initialName

                onAccepted: updateDialog.accept()
            }

            ComboBox {
                id: categoryBox

                Layout.fillWidth: true

                model: categoryModel

                textRole: "name"

                Component.onCompleted: updateSelection()

                function updateSelection() {
                    for (let i = 0; i < categoryModel.rowCount(); ++i) {
                        if (categoryModel.get(i).categoryId === updateDialog.initialCategoryId) {
                            currentIndex = i
                            return
                        }
                    }

                    currentIndex = -1
                }

                Connections {
                    target: updateDialog

                    function onInitialCategoryIdChanged() {
                        categoryBox.updateSelection()
                    }
                }
            }
        }

        onOpened: {
            newHymnName.forceActiveFocus()
            categoryBox.updateSelection()
        }

        onAccepted: {
            const name = newHymnName.text.trim()

            if (name.length === 0 || categoryBox.currentIndex < 0)
                return

            const categoryId = categoryModel.get(categoryBox.currentIndex).categoryId

            root.updateHymn(
                updateDialog.hymnRow,
                name,
                categoryId
            )
        }
    }

    Dialog {
        id: deleteDialog

        title: "Usunąć pieśń?"
        modal: true

        parent: Overlay.overlay
        anchors.centerIn: Overlay.overlay
        dim: true

        standardButtons: Dialog.Yes | Dialog.No

        Label {
            text: "Czy na pewno chcesz usunąć tę pieśń?"
        }

        onAccepted: {
            if (root.pendingRemoveRow >= 0) {
                root.removeHymn(root.pendingRemoveRow)
                root.pendingRemoveRow = -1
            }
        }

        onRejected: {
            root.pendingRemoveRow = -1
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        Label {
            text: root.setMode ? "Składniki zestawu" : "Pieśni"
            font.pixelSize: 20
            font.bold: true
        }

        TextField {
            Layout.fillWidth: true
            enabled: !root.setMode
            visible: !root.setMode

            placeholderText: "Szukaj pieśni..."

            onTextChanged: {
                root.hymnSearchText = text
            }
        }

        ListView {
            id: list

            Layout.fillWidth: true
            Layout.fillHeight: true

            clip: true
            spacing: root.setMode ? 6 : 0

            ScrollBar.vertical: ScrollBar {
                width: 8
                policy: ScrollBar.AlwaysOn
            }

            currentIndex: {
                for (let i = 0; i < count; i++) {
                    if (model.get(i).id === selectedId)
                        return i
                }

                return -1
            }

            delegate: Item {
                width: list.width - list.rightMargin - list.ScrollBar.vertical.width - 1

                property bool filteredOut: {
                    let filter = root.hymnSearchText.trim().toLowerCase()
                    let text = model.name.toLowerCase()
                    let ok = text.indexOf(filter) !== -1

                    if (filter === "")
                        return false

                    return !ok
                }


                height: filteredOut ? 0 : 49
                visible: !filteredOut

                Behavior on height {
                    NumberAnimation {
                        duration: 150
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 45

                    radius: 6

                    color: model.id === root.selectedId ? "#d7ecff" : "#f4f4f4"
                    border.color: "#d0d0d0"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 8

                        Label {
                            Layout.fillWidth: true

                            text: model.name

                            font.bold: ListView.isCurrentItem
                            elide: Text.ElideRight
                        }

                        ToolButton {
                            visible: root.setMode

                            text: MdiFont.Icon.arrowUp

                            font.family: "Material Design Icons"
                            font.pixelSize: 20

                            enabled: index > 0

                            onClicked: {
                                root.moveHymn(index, index - 1)
                            }
                        }

                        ToolButton {
                            visible: root.setMode

                            text: MdiFont.Icon.arrowDown

                            font.family: "Material Design Icons"
                            font.pixelSize: 20

                            enabled: index < list.count - 1

                            onClicked: {
                                root.moveHymn(index, index + 1)
                            }
                        }

                        ToolButton {
                            visible: !root.setMode

                            text: MdiFont.Icon.pencil

                            font.family: "Material Design Icons"
                            font.pixelSize: 20

                            onClicked: {
                                updateDialog.initialName = model.name
                                updateDialog.initialCategoryId = model.categoryId
                                updateDialog.hymnRow = index
                                updateDialog.open()
                            }
                        }

                        ToolButton {
                            text: MdiFont.Icon.delete

                            font.family: "Material Design Icons"
                            font.pixelSize: 20

                            Material.foreground: "firebrick"

                            onClicked: {
                                root.pendingRemoveRow = index
                                deleteDialog.open()
                            }
                        }

                        TapHandler {
                            onTapped: {
                                list.currentIndex = index
                                root.selected(model.id)
                            }
                        }
                    }
                }
            }
        }

        Button {
            text: "+ Dodaj pieśń"

            enabled: model.parentId >= (root.setMode ? 0 : -1)

            onClicked: {
                if(root.setMode)
                    hymnPicker.open()
                else
                    addDialog.open()
            }
        }
    }
}