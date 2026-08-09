import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Prezenter
import "../Icon.js" as MdiFont

Item {
    id: root

    property alias model: list.model
    property int pendingRemoveRow: -1
    property string hymnSearchText: ""

    property bool setMode: false

    signal selected(int id)
    signal addHymn(string name)
    signal addHymnToSet(int hymnId)
    signal updateHymn(int row, string name, int categoryId)
    signal removeHymn(int row)
    signal moveHymn(int from, int to)

    function resetSelection()
    {
        list.currentIndex = -1
    }

    Connections {
        target: root.model

        function onRowsInserted(parent, first, last) {
            if (last >= 0) {
                Qt.callLater(function() {
                    list.currentIndex = last
                    root.selected(root.model.get(last).hymnId)
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

                root.selected(root.model.get(newIndex).hymnId)
            }
            else if (list.currentIndex > last) {
                list.currentIndex -= (last - first + 1)
            }
        }

        function onParentIdChanged() {
            Qt.callLater(function() {
                list.currentIndex = -1
            })
        }
    }

    Dialog {
        id: addDialog

        title: qsTr("Nowa pieśń")
        modal: true

		Overlay.modal: Rectangle {
			color: Theme.dimBackground
		}

        parent: Overlay.overlay
		anchors.centerIn: Overlay.overlay
        dim: true

        standardButtons: Dialog.Ok | Dialog.Cancel

        width: 320
        padding: 20

        contentItem: TextField {
            id: hymnName

            placeholderText: qsTr("Nazwa pieśni")

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

        title: qsTr("Edytuj pieśń")
        modal: true

		Overlay.modal: Rectangle {
			color: Theme.dimBackground
		}

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

                placeholderText: qsTr("Nazwa pieśni")
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

        title: qsTr("Usunąć pieśń?")
        modal: true

		Overlay.modal: Rectangle {
			color: Theme.dimBackground
		}

        parent: Overlay.overlay
        anchors.centerIn: Overlay.overlay
        dim: true

        standardButtons: Dialog.Yes | Dialog.No

        Label {
            text: qsTr("Czy na pewno chcesz usunąć tę pieśń?")
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
            text: root.setMode ? qsTr("Składniki zestawu") : qsTr("Pieśni")
            font.pixelSize: 20
            font.bold: true

            color: Theme.text
        }

        TextField {
            Layout.preferredWidth: list.width - list.rightMargin - list.ScrollBar.vertical.width - 1
            Layout.preferredHeight: 45
            enabled: !root.setMode
            visible: !root.setMode

            placeholderText: qsTr("Szukaj pieśni...")

            onTextChanged: {
                root.hymnSearchText = text
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                id: list

                anchors.fill: parent

                clip: true
                spacing: root.setMode ? 6 : 0

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

                                text: model.name

                                font.bold: wrapper.ListView.isCurrentItem
                                elide: Text.ElideRight

                                color: Theme.text
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
                                id: moreButton

                                text: MdiFont.Icon.dotsVertical

                                font.family: "Material Design Icons"
                                font.pixelSize: 22

                                onClicked:
                                    menu.open()
                            }


                            Menu {
                                id: menu
                                x: moreButton.x + moreButton.width - width
                                y: moreButton.height

                                Loader {
                                    active: !root.setMode

                                    sourceComponent: MenuItem {
                                        text: qsTr("Edytuj")

                                        onTriggered: {
                                            updateDialog.initialName = model.name
                                            updateDialog.initialCategoryId = model.categoryId
                                            updateDialog.hymnRow = index
                                            updateDialog.open()
                                        }
                                    }
                                }

                                Loader {
                                    active: !root.setMode

                                    sourceComponent: MenuSeparator {}
                                }

                                MenuItem {
                                    text: qsTr("Usuń")

                                    Material.foreground: "firebrick"

                                    onTriggered: {
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
            }

            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right

                height: 32
                z: 10

                gradient: Gradient {
                    GradientStop {
                        position: 1
                        color: "transparent"
                    }
                    GradientStop {
                        position: 0
                        color: Theme.background
                    }
                }

                opacity: list.contentY > 0 ? 1 : 0
                visible: opacity > 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 180
                        easing.type: Easing.OutCubic
                    }
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right

                height: 32
                z: 10

                gradient: Gradient {
                    GradientStop {
                        position: 0
                        color: "transparent"
                    }
                    GradientStop {
                        position: 1
                        color: Theme.background
                    }
                }

                opacity: list.contentY + list.height < list.contentHeight ? 1 : 0
                visible: opacity > 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 180
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: toolBar.implicitHeight + 5

            color: "transparent"

            RowLayout {
                id: toolBar
                anchors.fill: parent

                Button {
                    text: qsTr("+ Dodaj pieśń")

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
    }
}