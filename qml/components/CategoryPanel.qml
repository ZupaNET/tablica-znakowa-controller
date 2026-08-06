import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../Icon.js" as MdiFont

Item {
    id: root

    property alias model: list.model
    property int pendingRemoveRow: -1
    property string categorySearchText: ""

    signal selected(int id)
    signal addCategory(string name)
    signal updateCategory(int row, string name)
    signal removeCategory(int row)
    signal moveCategory(int from, int to)

    Connections {
        target: root.model

        function onRowsInserted(parent, first, last) {
            if (last >= 0) {
                Qt.callLater(function() {
                    list.currentIndex = last
                    root.selected(root.model.get(last).categoryId)
                    list.positionViewAtIndex(last, ListView.End)
                })
            }
        }

        function onRowsRemoved(parent, first, last) {
            if (first < 0)
                return

            if (list.currentIndex >= first && list.currentIndex <= last) {

                let newIndex = first - 1

                if (newIndex < 0 && list.count > 0)
                    newIndex = 0

                if (list.count === 0) {
                    list.currentIndex = -1
                    return
                }

                list.currentIndex = newIndex

                root.selected(root.model.get(newIndex).categoryId)
            }
            else if (list.currentIndex > last) {
                list.currentIndex -= (last - first + 1)
            }
        }
    }

    Dialog {
        id: addDialog

        title: qsTr("Nowa kategoria")
        modal: true

        parent: Overlay.overlay
		anchors.centerIn: Overlay.overlay
        dim: true

        standardButtons: Dialog.Ok | Dialog.Cancel

        width: 320
        padding: 20

        contentItem: TextField {
            id: categoryName

            placeholderText: qsTr("Nazwa kategorii")

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

        title: qsTr("Zmiana nazwy kategorii")
        modal: true

        property string initialName: ""
        property int categoryRow: -1

        parent: Overlay.overlay
		anchors.centerIn: Overlay.overlay
        dim: true

        standardButtons: Dialog.Ok | Dialog.Cancel

        width: 320
        padding: 20

        contentItem: TextField {
            id: newCategoryName

            placeholderText: qsTr("Nazwa kategorii")

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

        title: qsTr("Usunąć kategorię?")
        modal: true

        parent: Overlay.overlay
        anchors.centerIn: Overlay.overlay
        dim: true

        standardButtons: Dialog.Yes | Dialog.No

        Label {
            text: qsTr("Czy na pewno chcesz usunąć tę kategorię?")
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
            text: qsTr("Kategorie")
            font.pixelSize: 20
            font.bold: true

            color: Theme.text
        }

        TextField {
            Layout.fillWidth: true

            placeholderText: qsTr("Szukaj kategorii...")

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

            Component.onCompleted: {
                list.currentIndex = -1
            }

            delegate: Item {
                id: wrapper
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

                    color:
                        wrapper.ListView.isCurrentItem
                        ? Theme.listItemSelected
                        : Theme.listItem

                    border.color: Theme.listItemBorder

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 8

                        Label {
                            Layout.fillWidth: true

                            text: model.name === "" ? qsTr("Bez kategorii") : model.name

                            font.bold: wrapper.ListView.isCurrentItem
                            elide: Text.ElideRight

                            color: Theme.text
                        }

                        ToolButton {
                            text: MdiFont.Icon.arrowUp

                            enabled: model.id >= 0 && index > 1 && root.categorySearchText == ""
                            visible: model.id >= 0

                            font.family: "Material Design Icons"
                            font.pixelSize: 20

                            onClicked: {
                                root.moveCategory(index, index - 1)
                            }
                        }

                        ToolButton {
                            text: MdiFont.Icon.arrowDown

                            font.family: "Material Design Icons"
                            font.pixelSize: 20

                            enabled: model.id >= 0 && index < list.count - 1 && root.categorySearchText == ""
                            visible: model.id >= 0

                            onClicked: {
                                root.moveCategory(index, index + 1)
                            }
                        }

                        ToolButton {
                            id: moreButton

                            visible: model.id >= 0

                            text: MdiFont.Icon.dotsVertical

                            font.family: "Material Design Icons"
                            font.pixelSize: 22

                            onClicked:
                                menu.open()
                        }


                        Menu {
                            id: menu
                            y: moreButton.height

                            MenuItem {
                                text: qsTr("Edytuj")

                                onTriggered: {
                                    updateDialog.initialName = model.name
                                    updateDialog.categoryRow = index
                                    updateDialog.open()
                                }
                            }

                            MenuSeparator {}

                            MenuItem {
                                text: qsTr("Usuń")

                                Material.foreground: "firebrick"

                                onTriggered: {
                                    root.pendingRemoveRow = index
                                    deleteDialog.open()
                                }
                            }
                        }

                        TapHandler  {
                            onTapped: {
                                list.currentIndex = index
                                root.selected(model.id)
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: toolBar.implicitHeight + 16

            color: "transparent"
            border.color: Theme.surfaceBorder
            border.width: 1

            radius: 5

            RowLayout {
                id: toolBar
                anchors.fill: parent
                anchors.margins: 8

                Button {
                    text: qsTr("+ Dodaj kategorię")

                    onClicked: addDialog.open()
                }
            }
        }
    }
}