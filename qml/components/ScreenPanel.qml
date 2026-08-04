import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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
        }

        ListView {
            id: list

            Layout.fillHeight: true
            Layout.fillWidth: true

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

                color: "#f4f4f4"

                border.color: "#d0d0d0"

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

        Button {
            text: qsTr("+ Dodaj slajd")

            enabled: model.hymnId >= 0

            onClicked: {
                root.addScreen()
            }
        }
    }
}