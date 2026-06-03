import QtQuick 2.15
import QtQuick.Controls 2.15

import TablicaZnakowa

ApplicationWindow {
    width: 1280
    height: 800
    visible: true
    id: mainwindow
    title: qsTr("Tryb prezentacji")
    color: "#202020"

    Item {
        anchors.fill: parent
        focus: true

        StackView {
            id: stack
            anchors.fill: parent
            clip: true

            initialItem: Menu{}
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