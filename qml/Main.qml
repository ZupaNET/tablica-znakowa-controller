import QtQuick 2.15
import QtQuick.Controls 2.15

import Prezenter

ApplicationWindow {
    id: mainWindow

    visible: true

    width: 1280
    height: 800

    title: AppInfo.name
    color: "#202020"

    Item {
        anchors.fill: parent

        StackView {
            id: stack

            anchors.fill: parent

            clip: true

            initialItem: MenuPage {}

            Component.onCompleted: {
                Navigation.stackView = stack
                splashTimer.start()
            }
        }

        Rectangle {
            id: splash

            anchors.fill: parent

            z: 10000

            color: "#202020"

            Image {
                anchors.fill: parent

                source: "qrc:/images/splash.png"

                fillMode: Image.PreserveAspectCrop
            }

            MouseArea {
                anchors.fill: parent
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }
        }

        Timer {
            id: splashTimer

            interval: 700
            repeat: false

            onTriggered:
                splash.opacity = 0
        }

        Connections {
            target: splash

            function onOpacityChanged() {
                if (splash.opacity === 0)
                    splash.visible = false
            }
        }
    }
}