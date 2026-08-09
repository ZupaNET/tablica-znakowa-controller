import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Prezenter
import "../Icon.js" as MdiFont

Item {
    id: root

    property alias model: list.model

    property int pendingRemoveRow: -1

    signal selected(int id, int row)

    signal addScreen()
    signal removeScreen(int row)
    signal duplicateScreen(int row)
    signal moveScreen(int from, int to)

    Connections {
        target: root.model

        function onRowsInserted(parent, first, last) {
            if (last >= 0) {
                Qt.callLater(function() {
                    list.positionViewAtIndex(last, ListView.End)
                })
            }
        }
    }

    Dialog {
        id: deleteDialog

        title: qsTr("Usunąć slajd?")
        modal: true

		Overlay.modal: Rectangle {
			color: Theme.dimBackground
		}

        parent: Overlay.overlay
		anchors.centerIn: Overlay.overlay
        dim: true

        standardButtons: Dialog.Yes | Dialog.No

        Label {
            text: qsTr("Czy na pewno chcesz usunąć ten slajd?")
        }

        onAccepted: {

            if (root.pendingRemoveRow >= 0) {
                root.removeScreen(root.pendingRemoveRow)
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
            text: qsTr("Slajdy")

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

                spacing: 8
                clip: true

                ScrollBar.vertical: ScrollBar {
                    width: 8
                    policy: ScrollBar.AlwaysOn
                }

                delegate: Rectangle {
                    width: list.width - list.ScrollBar.vertical.width - 1
                    height: 300

                    radius: 8

                    color: Theme.listItem

                    border.color: Theme.listItemBorder

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8

                        spacing: 6

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            Layout.minimumHeight: 0

                            TablicaScreen {
                                anchors.fill: parent

                                content: model.text
                                hymnFont: model.font
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 32

                            Label {
                                Layout.fillWidth: true

                                text: qsTr("Slajd") + " " + (index + 1)

                                font.bold: true

                                color: Theme.text
                            }

                            ToolButton {
                                   text: MdiFont.Icon.arrowUp

                                   font.family: "Material Design Icons"
                                   font.pixelSize: 20

                                   enabled: index > 0

                                   onClicked: {
                                       root.moveScreen(index, index - 1)
                                   }
                               }

                               ToolButton {
                                   text: MdiFont.Icon.arrowDown

                                   font.family: "Material Design Icons"
                                   font.pixelSize: 20

                                   enabled: index < list.count - 1

                                   onClicked: {
                                       root.moveScreen(index, index + 1)
                                   }
                               }

                            ToolButton {
                                text: MdiFont.Icon.contentCopy

                                font.family: "Material Design Icons"
                                font.pixelSize: 20

                                onClicked: {
                                    root.duplicateScreen(index)
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
                    }

                    TapHandler {
                        onTapped: {
                            list.currentIndex = index
                            root.selected(model.id, index)
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
                    text: qsTr("+ Dodaj slajd")

                    enabled: model.hymnId >= 0

                    onClicked: {
                        root.addScreen()
                    }
                }
            }
        }
    }
}