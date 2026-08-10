import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Prezenter

Item {
    id: root

    required property int index
    required property var model
    required property ListView listView

    property bool setMode: false
    property bool showPreview: true

    signal clicked()
    signal moveUp()
    signal moveDown()
    signal duplicate()
    signal remove()
    signal toggleShown(bool shown)

    implicitHeight: setMode ? (showPreview ? 290 : 54) : 300
    width: listView.width - listView.ScrollBar.vertical.width - 1

    Rectangle {
        anchors.fill: parent

        radius: 8

        color: root.setMode ? (model.shown ? Theme.successBackground : Theme.inactiveItem) : Theme.listItem
        border.color: root.setMode ? (model.shown ? Theme.successBorder : Theme.inactiveBorder) : Theme.listItemBorder

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: root.setMode ? 0 : 8

            spacing: 6

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: root.setMode ? root.showPreview : true
                Layout.minimumHeight: 0

                visible: root.setMode ? root.showPreview : true

                TablicaScreen {
                    anchors.fill: parent
                    anchors.topMargin: root.setMode ? 8 : 0
                    anchors.leftMargin: root.setMode ? 8 : 0
                    anchors.rightMargin: root.setMode ? 8 : 0

                    content: model.text
                    hymnFont: model.font
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 34

                Layout.leftMargin: root.setMode ? 12 : 0
                Layout.rightMargin: root.setMode ? 8 : 0

                Layout.topMargin: root.setMode ? 10 : 0
                Layout.bottomMargin: root.setMode ? 10 : 0

                Rectangle {
                    visible: root.setMode

                    Layout.preferredHeight: 34
                    Layout.preferredWidth: 34

                    radius: 17

                    color: model.shown ? Theme.badgeActive : Theme.badgeInactive

                    Label {
                        anchors.centerIn: parent

                        text: root.index + 1

                        color: "white"
                        font.bold: true
                    }
                }

                Label {
                    Layout.fillWidth: true

                    text: root.setMode ? model.excerpt : qsTr("Slajd") + " " + (root.index + 1)

                    elide: Text.ElideRight

                    font.pixelSize: root.setMode ? 15 : 14
                    font.bold: !root.setMode

                    color: Theme.text
                }

                Switch {
                    visible: root.setMode

                    checked: model.shown ? model.shown : false

                    onToggled: {
                        root.toggleShown(checked)
                    }
                }

                ToolButton {
                    visible: !root.setMode

                    text: Icon.arrowUp

                    font.family: "Material Design Icons"
                    font.pixelSize: 20

                    enabled: root.index > 0

                    onClicked: {
                        root.moveUp()
                    }
                }

                ToolButton {
                    visible: !root.setMode

                    text: Icon.arrowDown

                    font.family: "Material Design Icons"
                    font.pixelSize: 20

                    enabled: root.index < root.listView.count - 1

                    onClicked: {
                        root.moveDown()
                    }
                }

                ToolButton {
                    visible: !root.setMode

                    text: Icon.contentCopy

                    font.family: "Material Design Icons"
                    font.pixelSize: 20

                    onClicked: {
                        root.duplicate()
                    }
                }

                ToolButton {
                    visible: !root.setMode

                    text: Icon.iDelete

                    font.family: "Material Design Icons"
                    font.pixelSize: 20

                    Material.foreground: "firebrick"

                    onClicked: {
                        root.remove()
                    }
                }
            }
        }

        TapHandler {
            onTapped: {
                root.clicked()
            }
        }
    }
}