import QtQuick
import QtQuick.Controls

Rectangle {
    id: root

    signal clicked

    property string icon
    property string title
    property string description
    property bool danger: false

    implicitWidth: 270
    implicitHeight: 150

    property real scaleFactor:
        Math.min(width / implicitWidth, height / implicitHeight)

    radius: width * 0.07

    color:
        mouse.containsMouse
        ? "#e8f3ff"
        : danger
          ? "#fff1f1"
          : "white"

    border.color:
        danger
        ? "#ef9a9a"
        : "#dddddd"

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    Column {
        anchors.centerIn: parent

        spacing: 8

        scale: root.scaleFactor

        Text {
            anchors.horizontalCenter: parent.horizontalCenter

            text: root.icon

            visible: root.icon !== ""

            font.family: "Material Design Icons"

            font.pixelSize: 46

            color:
                danger
                ? "#d32f2f"
                : "#37474f"
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter

            text: root.title

            visible: root.title !== ""

            font.pixelSize: 20
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter

            text: root.description

            color: "#777"

            font.pixelSize: 13
        }
    }

    MouseArea {
        id: mouse

        anchors.fill: parent

        hoverEnabled: true

        onClicked:
            root.clicked()
    }
}