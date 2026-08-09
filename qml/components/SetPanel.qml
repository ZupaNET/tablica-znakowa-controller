import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Prezenter
import "../Icon.js" as MdiFont

Item {
    id: root

    property alias model: list.model
    property int pendingRemoveRow: -1

    signal selected(int id)
    signal addSet(string name)
    signal updateSet(int row, string name)
    signal removeSet(int row)
    signal moveSet(int from, int to)

    Connections {
        target: root.model

        function onRowsInserted(parent, first, last) {
            if (last >= 0) {
                Qt.callLater(function() {
                    list.currentIndex = last
                    root.selected(root.model.get(last).setId)
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

                root.selected(root.model.get(newIndex).setId)
            }
            else if (list.currentIndex > last) {
                list.currentIndex -= (last - first + 1)
            }
        }
    }

    Dialog {
        id: addDialog

        title: qsTr("Nowy zestaw")
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

		Overlay.modal: Rectangle {
			color: Theme.dimBackground
		}

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

		Overlay.modal: Rectangle {
			color: Theme.dimBackground
		}

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

            color: Theme.text
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                id: list

                anchors.fill: parent

                spacing: 6
                clip: true

                ScrollBar.vertical: ScrollBar {
                    width: 8
                    policy: ScrollBar.AlwaysOn
                }

                Component.onCompleted: {
                    list.currentIndex = -1
                }

                delegate: Rectangle {
                    id: wrapper

                    width: list.width - list.rightMargin - list.ScrollBar.vertical.width - 1
                    height: 46

                    radius: 6

                    color:
                        wrapper.ListView.isCurrentItem
                        ? Theme.listItemSelected
                        : Theme.listItem

                    border.color:
                        Theme.listItemBorder

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
                            text: MdiFont.Icon.arrowUp

                            enabled: index > 0

                            font.family: "Material Design Icons"
                            font.pixelSize: 20

                            onClicked: {
                                root.moveSet(index, index - 1)
                            }
                        }

                        ToolButton {
                            text: MdiFont.Icon.arrowDown

                            font.family: "Material Design Icons"
                            font.pixelSize: 20

                            enabled: index < list.count - 1

                            onClicked: {
                                root.moveSet(index, index + 1)
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

                            MenuItem {
                                text: qsTr("Edytuj")

                                onTriggered: {
                                    updateDialog.initialName = model.name
                                    updateDialog.setRow = index
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
                    }

                    TapHandler {
                        onTapped: {
                            list.currentIndex = index
                            root.selected(model.id)
                        }
                    }
                }
            }

            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right

                height: 8
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

                height: 8
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
                    text: qsTr("+ Dodaj zestaw")

                    onClicked: addDialog.open()
                }
            }
        }
    }
}