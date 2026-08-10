import QtQuick
import QtQuick.Controls

import Prezenter

ApplicationWindow {
    id: mainWindow

    width: 1280
    height: 800

    visible: true

    title: AppInfo.name
    color: Theme.appBackground

    Material.theme: AppSettings.darkMode ? Material.Dark : Material.Light
    Material.accent: Material.Red

    readonly property int keyboardHeight:
        Qt.inputMethod.visible
            ? Qt.inputMethod.keyboardRectangle.height / Screen.devicePixelRatio - SafeArea.margins.bottom
            : 0

    property bool closing: false

    onClosing: function(close) {
        if(TablicaConnector.enabled === false)
        {
            close.accepted = true
            return
        }

        if (closing)
            return

        close.accepted = false
        closing = true

        TablicaConnector.enabled = true
        TablicaConnector.clearScreen()
    }

    Connections {
        target: TablicaConnector

        function onCommandQueueEmpty() {
            if (!mainWindow.closing)
                return

            Qt.quit()
        }

        function onConnectionFailure() {
            if(mainWindow.closing)
                Qt.quit()
        }
    }

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

    Component.onCompleted: {
        Qt.uiLanguage = LanguageManager.language
    }

    Connections {
        target: LanguageManager

        function onLanguageChanged() {
            Qt.uiLanguage = LanguageManager.language
        }
    }
}