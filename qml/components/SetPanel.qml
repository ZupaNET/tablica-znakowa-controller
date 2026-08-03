import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../Icon.js" as MdiFont

Item {
    id: root

    property alias model: list.model
    property int selectedId: -2
    property int pendingRemoveRow: -1

    signal selected(int id)
    signal addSet(string name)
    signal updateSet(int row, string name)
    signal removeSet(int row)

    Dialog {
        id: addDialog

        title: qsTr("Nowy zestaw")
        modal: true

        parent: Overlay.overlay
		anchors.centerIn: Overlay.overlay
        dim: true

        standardButtons: Dialog.Ok | Dialog.Cancel

        width: 320
        padding: 20

        contentItem: TextField {
            id: setName

            placeholderText: qsTr("Nazwa zestawu")

            onAccepted: addDialog.accept()
        }

        onOpened: {
            setName.clear()
            setName.forceActiveFocus()
        }

        onAccepted: {
            const name = setName.text.trim()
            if (name.length > 0)
                root.addSet(name)
        }
    }

    Dialog {
        id: updateDialog

        title: qsTr("Zmiana nazwy zestawu")
        modal: true

        property string initialName: ""
        property int setRow: -1

        parent: Overlay.overlay
		anchors.centerIn: Overlay.overlay
        dim: true

        standardButtons: Dialog.Ok | Dialog.Cancel

        width: 320
        padding: 20

        contentItem: TextField {
            id: newSetName

            placeholderText: qsTr("Nazwa zestawu")

            text: updateDialog.initialName

            onAccepted: addDialog.accept()
        }

        onOpened: {
            newSetName.forceActiveFocus()
        }

        onAccepted: {
            const name = newSetName.text.trim()
            if (name.length > 0)
                root.updateSet(setRow, name)
        }
    }

    Dialog {
        id: deleteDialog

        title: qsTr("Usunąć zestaw?")
        modal: true

        parent: Overlay.overlay
		anchors.centerIn: Overlay.overlay
        dim: true

        standardButtons: Dialog.Yes | Dialog.No

        Label {
            text: qsTr("Czy na pewno chcesz usunąć ten zestaw?")
        }

        onAccepted: {
            if (root.pendingRemoveRow >= 0) {
                root.removeSet(root.pendingRemoveRow)
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
            text: qsTr("Zestawy")
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
                            updateDialog.setRow = index
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
            text: "+ Dodaj zestaw"

            onClicked: addDialog.open()
        }
    }
}