import QtQuick 2.15
import QtQuick.Controls 2.15

import Prezenter

ApplicationWindow {
    id: mainWindow

    property bool showImmediately: true

    visible: showImmediately

    width: 1280
    height: 800

    title: AppInfo.name
    color: "#202020"

    signal ready()

    Item {
        anchors.fill: parent

        StackView {
            id: stack

            anchors.fill: parent

            clip: true

            initialItem: MenuPage {}

            Component.onCompleted: {
                Navigation.stackView = stack
                forceActiveFocus()
                ready()
            }
        }
    }
}