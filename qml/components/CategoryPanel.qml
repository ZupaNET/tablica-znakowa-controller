import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../Icon.js" as MdiFont

Item {
    id: root

    property alias model: list.model
    property int selectedId: -2
    property int pendingRemoveRow: -1
    property string categorySearchText: ""

    signal selected(int id)
    signal addCategory(string name)
    signal updateCategory(int row, string name)
    signal removeCategory(int row)

    Dialog {
        id: addDialog

        title: "Nowa kategoria"
        modal: true

        parent: Overlay.overlay
        anchors.centerIn: parent
        dim: true

        standardButtons: Dialog.Ok | Dialog.Cancel

        width: 320
        padding: 20

        contentItem: TextField {
            id: categoryName

            placeholderText: "Nazwa kategorii"

            onAccepted: addDialog.accept()
        }

        onOpened: {
            categoryName.clear()
            categoryName.forceActiveFocus()
        }

        onAccepted: {
            const name = categoryName.text.trim()
            if (name.length > 0)
                root.addCategory(name)
        }
    }

    Dialog {
        id: updateDialog

        title: "Zmiana nazwy kategorii"
        modal: true

        property string initialName: ""
        property int categoryRow: -1

        parent: Overlay.overlay
        anchors.centerIn: parent
        dim: true

        standardButtons: Dialog.Ok | Dialog.Cancel

        width: 320
        padding: 20

        contentItem: TextField {
            id: newCategoryName

            placeholderText: "Nazwa kategorii"

            text: updateDialog.initialName

            onAccepted: addDialog.accept()
        }

        onOpened: {
            newCategoryName.forceActiveFocus()
        }

        onAccepted: {
            const name = newCategoryName.text.trim()
            if (name.length > 0)
                root.updateCategory(categoryRow, name)
        }
    }

    Dialog {
        id: deleteDialog

        title: "Usunąć kategorię?"
        modal: true

        parent: Overlay.overlay
        anchors.centerIn: parent
        dim: true

        standardButtons: Dialog.Yes | Dialog.No

        Label {
            text: "Czy na pewno chcesz usunąć tę kategorię?"
        }

        onAccepted: {
            if (root.pendingRemoveRow >= 0) {
                root.removeCategory(root.pendingRemoveRow)
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
            text: "Kategorie"
            font.pixelSize: 20
            font.bold: true
        }

        TextField {
            Layout.fillWidth: true

            placeholderText: "Szukaj kategorii..."

            onTextChanged: {
                root.categorySearchText = text
            }
        }

        ListView {
            id: list

            Layout.fillWidth: true
            Layout.fillHeight: true

            clip: true

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
                    let filter = root.categorySearchText.trim().toLowerCase()
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

                            text: model.name === "" ? "Bez kategorii" : model.name

                            font.bold: ListView.isCurrentItem
                            elide: Text.ElideRight
                        }

                        ToolButton {
                            text: MdiFont.Icon.pencil

                            enabled: model.id >= 0
                            visible: model.id >= 0

                            font.family: "Material Design Icons"
                            font.pixelSize: 20

                            onClicked: {
                                updateDialog.initialName = model.name
                                updateDialog.categoryRow = index
                                updateDialog.open()
                            }
                        }

                        ToolButton {
                            text: MdiFont.Icon.delete

                            enabled: model.id >= 0
                            visible: model.id >= 0

                            font.family: "Material Design Icons"
                            font.pixelSize: 20

                            Material.foreground: "firebrick"

                            onClicked: {
                                root.pendingRemoveRow = index
                                deleteDialog.open()
                            }
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

        Button {
            text: "+ Dodaj kategorię"

            onClicked: addDialog.open()
        }
    }
}