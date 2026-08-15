// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

import QtQuick
import QtQuick.Controls

import Prezenter

ApplicationWindow {
    id: mainWindow

    readonly property int keyboardHeight: Qt.inputMethod.visible ? Qt.inputMethod.keyboardRectangle.height / Screen.devicePixelRatio - SafeArea.margins.bottom : 0

    property bool closing: false

    width: 1280
    height: 800

    visible: true

    title: AppInfo.name
    color: Theme.appBackground

    Material.theme: AppSettings.darkMode ? Material.Dark : Material.Light
    Material.accent: Material.Red

    Overlay.overlay.height: mainWindow.height - mainWindow.keyboardHeight

    Item {
        id: rootContent

        anchors.fill: parent

        Rectangle {
            anchors.fill: parent

            visible: mainWindow.closing

            color: Theme.dimBackground

            z: 10

            Row {
               spacing: 10
               anchors.centerIn: parent

               BusyIndicator {
                   width: 32
                   height: 32
                   running: mainWindow.closing
               }

               Label {
                   anchors.verticalCenter: parent.verticalCenter

                   text: qsTr("Trwa zamykanie...")
                   color: Theme.text
               }
            }
        }

        FocusScope {
            id: viewport

            x: 0
            y: 0

            width: rootContent.width
            height: rootContent.height - mainWindow.keyboardHeight

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

    Component.onCompleted: {
        Qt.uiLanguage = LanguageManager.language
    }

    onClosing: function(close) {
        if(BoardController.enabled === false)
        {
            close.accepted = true
            return
        }

        if (closing)
            return

        close.accepted = false
        closing = true

        BoardController.enabled = false
    }

    Connections {
        target: LanguageManager

        function onLanguageChanged() {
            Qt.uiLanguage = LanguageManager.language
        }
    }

    Connections {
        target: BoardController

        function onTransmissionFinished() {
            if (!mainWindow.closing)
                return

            Qt.quit()
        }

        function onTransmissionFailed() {
            if(mainWindow.closing)
                Qt.quit()
        }
    }

    Connections {
        target: Qt.inputMethod

        function onVisibleChanged() {
            console.log(
                "[Main] DPR:",
                Screen.devicePixelRatio
            )

            console.log(
                "[Main] Keyboard px:",
                Qt.inputMethod.keyboardRectangle.height
            )

            console.log(
                "[Main] Keyboard dp:",
                Qt.inputMethod.keyboardRectangle.height
                / Screen.devicePixelRatio
            )
        }
    }
}