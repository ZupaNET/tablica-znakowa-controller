import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../Icon.js" as MdiFont

Item {
    id: root

    property alias model: list.model

    signal changeAllScreens(bool visible)
    signal toggleScreen(int row, bool visible)

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RowLayout {
            Layout.fillWidth: true

            Label {
                text: "Slajdy"

                font.pixelSize: 20
                font.bold: true

                Layout.fillWidth: true
            }
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

            delegate: Rectangle {

                width: list.width - 12
                height: 54

                radius: 8

                color: model.shown ? "#e8f5e9" : "#f4f4f4"

                border.color: model.shown ? "#81c784" : "#d0d0d0"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 8

                    Rectangle {
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 34

                        radius: 17

                        color: model.shown ? "#4caf50" : "#9e9e9e"

                        Label {
                            anchors.centerIn: parent

                            text: index + 1

                            color: "white"

                            font.bold: true
                        }
                    }

                    Label {
                        Layout.fillWidth: true

                        text: model.excerpt

                        elide: Text.ElideRight

                        font.pixelSize: 15
                    }

                    Switch {
                        checked: model.shown

                        onToggled: {
                            root.toggleScreen(index, checked)
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true

            ToolButton {
                text: MdiFont.Icon.eye

                enabled: root.model.hymnId >= 0

                font.family: "Material Design Icons"
                font.pixelSize: 22

                ToolTip.visible: hovered
                ToolTip.text: "Pokaż wszystkie"

                onClicked: {
                    root.changeAllScreens(true)
                }
            }

            ToolButton {
                text: MdiFont.Icon.eyeOff

                enabled: root.model.hymnId >= 0

                font.family: "Material Design Icons"
                font.pixelSize: 22

                ToolTip.visible: hovered
                ToolTip.text: "Ukryj wszystkie"

                onClicked: {
                    root.changeAllScreens(false)
                }
            }
        }
    }
}