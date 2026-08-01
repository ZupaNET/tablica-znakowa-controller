import QtQuick 2.15
import QtQuick.Controls 2.15

import Prezenter

ApplicationWindow {
    width: 1280
    height: 800
    visible: true
    id: mainwindow
    title: AppInfo.name
    color: "#202020"

    Item {
        anchors.fill: parent
        focus: true

        StackView {
            id: stack
            anchors.fill: parent
            clip: true

            initialItem: MenuPage{}
        }

        Component.onCompleted: {
            Navigation.stackView = stack
            forceActiveFocus()
        }

        Keys.onReleased: (event) => {
            if (event.key === Qt.Key_Back) {
                if (Navigation.back()) {
                    event.accepted = true
                }
            }
        }
    }
}