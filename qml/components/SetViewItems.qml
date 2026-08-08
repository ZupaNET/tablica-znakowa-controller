import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import Prezenter
import "../Icon.js" as MdiFont

Item {
    id: root

    property string title
    property string subtitle
    property string vid
    property bool selected: false

    property bool showAll: false
    property bool shown: false

    signal clicked
    signal visibilityChanged(bool shown)

    height: 60

    Rectangle {
        id: card
        anchors.fill: parent

        radius: 12

        property color baseColor: {

            if (!root.shown && root.showAll)
                return Theme.cardDisabled

            return selected
                ? Theme.cardSelected
                : Theme.setCard
        }

        property color pressedColor:
            Theme.cardPressed

        color:
            root.ListView.isCurrentItem
            ? Theme.cardCurrent
            : tap.pressed
                ? pressedColor
                : baseColor

        border.color:
            selected
            ? Theme.cardSelectedBorder
            : Theme.cardBorder

        Behavior on color {
            ColorAnimation { duration: 120 }
        }

        scale: tap.pressed ? 0.97 : 1.0

        Behavior on scale {
            NumberAnimation { duration: 100 }
        }

        Item {
            id: textArea
            anchors {
                fill: parent
                topMargin: 10
                rightMargin: 20
                bottomMargin: 10
                leftMargin: 10
            }

            Layout.fillWidth: true
            height: textRow.implicitHeight

            RowLayout {
                id: textRow
                anchors.fill: parent

                Rectangle {
                    Layout.preferredWidth: 18
                    Layout.preferredHeight: 18
                    Layout.alignment: Qt.AlignTop

                    visible: root.vid !== "0"

                    radius: 17

                    color: Theme.cardText

                    Label {
                        anchors.centerIn: parent

                        text: root.vid

                        color: card.baseColor

                        font.bold: true
                    }
                }

                ColumnLayout
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop

                    spacing: 0

                    Text {
                        id: titleText
                        Layout.fillWidth: true
                        Layout.minimumWidth: 0

                        text: root.title
                        font.bold: true
                        color: Theme.cardText
                        wrapMode: Text.NoWrap
                        clip: true
                        Behavior on color {
                            ColorAnimation { duration: 250 }
                        }
                    }

                    Text {
                        id: subtitleText
                        Layout.fillWidth: true
                        Layout.minimumWidth: 0

                        text: root.subtitle
                        color: Theme.cardText
                        wrapMode: Text.NoWrap
                        clip: true
                    }
                }
            }

            Rectangle {
                width: 30
                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }

                visible: titleText.paintedWidth > titleText.width
                      || subtitleText.paintedWidth > subtitleText.width

                gradient: Gradient {
                    orientation: Gradient.Horizontal

                    GradientStop {
                        position: 0.0
                        color: Qt.rgba(card.color.r,
                                        card.color.g,
                                        card.color.b,
                                        0.0)
                    }

                    GradientStop {
                        position: 0.6
                        color: card.color
                    }
                }
            }
        }

        ToolButton {
            visible: root.showAll

            width: 36
            height: 36

            anchors {
                right: parent.right
                rightMargin: 8
                verticalCenter: parent.verticalCenter
            }

            flat: true

            text: !root.shown
                  ? MdiFont.Icon.eyeOff
                  : MdiFont.Icon.eye

            font.family: "Material Design Icons"
            font.pixelSize: 20

            ToolTip.visible: hovered
            ToolTip.text: !root.shown
                          ? qsTr("Slajd ukryty")
                          : qsTr("Slajd widoczny")

            onClicked: {
                root.visibilityChanged(!root.shown)
            }
        }
    }

    TapHandler {
        id: tap
        gesturePolicy: TapHandler.ReleaseWithinBounds
        onTapped: root.clicked()
    }
}