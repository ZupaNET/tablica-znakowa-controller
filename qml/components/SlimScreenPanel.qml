import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Prezenter
import "../Icon.js" as MdiFont

Item {
    id: root

    property alias model: list.model
    property bool showPreview: AppSettings.showPreview

    signal changeAllScreens(bool visible)
    signal toggleScreen(int row, bool visible)

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RowLayout {
            Layout.fillWidth: true

            Label {
                text: qsTr("Slajdy")

                font.pixelSize: 20
                font.bold: true

                Layout.fillWidth: true

                color: Theme.text
            }
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

                    width: list.width - 12
                    height: root.showPreview ? 330 : 54

                    radius: 8

                    color:
                        model.shown
                        ? Theme.successBackground
                        : Theme.inactiveItem

                    border.color:
                        model.shown
                        ? Theme.successBorder
                        : Theme.inactiveBorder

                    ColumnLayout {
                        anchors.fill: parent

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            Layout.minimumHeight: 0

                            visible: root.showPreview

                            TablicaScreen {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8

                                content: model.text
                                hymnFont: model.font
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.leftMargin: 12
                            Layout.rightMargin: 8
                            Layout.topMargin: 10
                            Layout.bottomMargin: 10

                            Layout.alignment: Qt.AlignVCenter

                            Rectangle {
                                Layout.preferredWidth: 34
                                Layout.preferredHeight: 34

                                radius: 17

                                color:
                                    model.shown
                                    ? Theme.badgeActive
                                    : Theme.badgeInactive

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

                                color: Theme.text
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
            Layout.preferredHeight: toolBar.implicitHeight + 8

            color: "transparent"

            RowLayout {
                id: toolBar
                anchors.fill: parent

                ToolButton {
                    text: MdiFont.Icon.eye

                    enabled: root.model.hymnId >= 0

                    font.family: "Material Design Icons"
                    font.pixelSize: 22

                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Pokaż wszystkie")

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
                    ToolTip.text: qsTr("Ukryj wszystkie")

                    onClicked: {
                        root.changeAllScreens(false)
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Switch {
                    checked: root.showPreview

                    text: qsTr("Pokaż podgląd")

                    onToggled: {
                        root.showPreview = checked
                        AppSettings.showPreview = checked
                    }
                }
            }
        }
    }
}