import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../Icon.js" as MdiFont

Item {
    id: root

    property alias model: list.model
    property int selectedId: -1
    property int pendingRemoveRow: -1

    signal selected(int id)
    signal addHymn(string name)
    signal updateHymn(int row, string name)
    signal removeHymn(int row)

    Dialog {
        id: addDialog

        title: "Nowa pieśń"
        modal: true

        anchors.centerIn: Overlay.overlay

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

    Dialog {
        id: updateDialog

        title: "Zmiana nazwy pieśni"
        modal: true

        property string initialName: ""
        property int hymnRow: -1

        anchors.centerIn: Overlay.overlay

        standardButtons: Dialog.Ok | Dialog.Cancel

        width: 320
        padding: 20

        contentItem: TextField {
            id: newHymnName

            placeholderText: "Nazwa pieśni"

            text: updateDialog.initialName

            onAccepted: addDialog.accept()
        }

        onOpened: {
            newHymnName.forceActiveFocus()
        }

        onAccepted: {
            const name = newHymnName.text.trim()
            if (name.length > 0)
                root.updateHymn(updateDialog.hymnRow, name)
        }
    }

    Dialog {
        id: deleteDialog

        title: "Usunąć pieśń?"
        modal: true

        anchors.centerIn: Overlay.overlay

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
            text: "Pieśni"
            font.pixelSize: 20
            font.bold: true
        }

        ListView {
            id: list

            Layout.fillWidth: true
            Layout.fillHeight: true

            spacing: 6
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

            delegate: Rectangle {
                width: list.width - list.rightMargin - list.ScrollBar.vertical.width - 1
                height: 46

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
                        text: MdiFont.Icon.pencil

                        font.family: "Material Design Icons"
                        font.pixelSize: 20

                        onClicked: {
                            updateDialog.initialName = model.name
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
                }

                TapHandler {
                    onTapped: {
                        list.currentIndex = index
                        root.selected(model.id)
                    }
                }
            }
        }

        Button {
            text: "+ Dodaj pieśń"

            enabled: model.parentId >= -1

            onClicked: addDialog.open()
        }
    }
}