import QtQuick
import QtQuick.Controls

import Prezenter


ApplicationWindow {
    id: mainWindow

    width: 1280
    height: 800

    visible: true

    title: AppInfo.name
    color: "#474747"

    readonly property int keyboardHeight:
        Qt.inputMethod.visible
            ? Qt.inputMethod.keyboardRectangle.height / Screen.devicePixelRatio - SafeArea.margins.bottom
            : 0

    Item {
        id: rootContent

        anchors.fill: parent

        FocusScope {
            id: viewport

            x: 0
            y: 0

            width: rootContent.width

            height:
                rootContent.height
                - mainWindow.keyboardHeight

            StackView {
                id: stack

                anchors.fill: parent

                clip: true

                initialItem: MenuPage {}
            }

            Keys.onReleased: (event) => {

                if (event.key === Qt.Key_Back) {

                    if (Navigation.back()) {
                        event.accepted = true
                    }
                }
            }

            Component.onCompleted: {
                Navigation.stackView = stack
                forceActiveFocus()
            }
        }
    }

    Overlay.overlay.height:
        mainWindow.height - mainWindow.keyboardHeight

    Connections {
        target: Qt.inputMethod

        function onVisibleChanged() {
            console.log(
                "DPR:",
                Screen.devicePixelRatio
            )

            console.log(
                "Keyboard px:",
                Qt.inputMethod.keyboardRectangle.height
            )

            console.log(
                "Keyboard dp:",
                Qt.inputMethod.keyboardRectangle.height
                / Screen.devicePixelRatio
            )
        }
    }
}