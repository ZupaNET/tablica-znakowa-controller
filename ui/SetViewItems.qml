import QtQuick 2.15
import QtQuick.Layouts 2.15
import QtQuick.Effects

Item {
    id: root

    property string title
    property string subtitle
    property string vid
    property bool selected: false

    signal clicked

    implicitHeight: Math.max(60, Screen.pixelDensity * 12)

    Rectangle {
        id: card
        anchors.fill: parent

        radius: 12

        property color baseColor: selected ? "#d0e6ff" : "#d7d7d7"
        property color pressedColor: "#cacaca"

        color: tap.pressed ? pressedColor : baseColor
        border.color: selected ? "#3399ff" : "#cccccc"

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
                leftMargin: 20
            }

            Layout.fillWidth: true
            height: textColumn.implicitHeight

            Column {
                id: textColumn
                anchors {
                    fill: parent
                }

                spacing: 2

                Text {
                    id: titleText
                    width: parent.width
                    text: "["+ root.vid + "] " + root.title
                    font.bold: true
                    color: "#595959"
                    wrapMode: Text.NoWrap
                    clip: true
                }

                Text {
                    id: subtitleText
                    width: parent.width
                    text: root.subtitle
                    color: "#595959"
                    wrapMode: Text.NoWrap
                    clip: true
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
    }

    TapHandler {
        id: tap
        gesturePolicy: TapHandler.ReleaseWithinBounds
        onTapped: root.clicked()
    }
}