// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import Prezenter

Item {
    id: root1

    property int currentSet
    property var currentScreen: null
    property int selectedScreenId: -1
    property int selectedHymnId: -1

    property bool showHymnMode: false

    PresentationModel {
        id: screensModel
        setId: root1.currentSet
        hymnMode: root1.showHymnMode
        Component.onCompleted: reload()
    }

    ScreenSwitcherDialog {
        id: screenSwitcherDialog
        setId: root1.currentSet

        onClosed: {
            screensModel.reload()
            Qt.callLater(() => {
                restoreSelection()
                let item = screensModel.get(screensView.currentIndex)

                TablicaConnector.buffer = item

                let target = Math.max(0, screensView.currentIndex - 1)

                screensView.contentY = Math.max(
                    0,
                    Math.min(
                        target * (60 + screensView.spacing),
                        screensView.contentHeight - screensView.height
                    )
                )
            })
        }
    }

    function findFirstScreenByHymnId(id) {
        if(id < 0)
            return

        for (let i = 0; i < screensModel.rowCount(); i++) {
            if (screensModel.get(i).hymnId === id) {
                return i
            }
        }
    }

    function restoreSelection() {
        if (root1.selectedScreenId < 0)
            return

        for (let i = 0; i < screensModel.rowCount(); i++) {
            if (screensModel.get(i).screenId === root1.selectedScreenId) {
                screensView.currentIndex = i
                return
            }
        }
    }

    function changeScreen(direction) {
        let index = screensView.currentIndex + direction;

        while (index >= 0 && index < screensModel.rowCount()) {

            let screen = screensModel.get(index);

            if (!screensModel.showAll || screen.shown) {
                screensView.currentIndex = index;
                return;
            }

            index += direction;
        }
    }

    Connections {
        target: screensModel

        function onShowAllChanged() {
            Qt.callLater(() => {
                restoreSelection()
            })
        }
    }

    Connections {
        target: TablicaConnector

        function onConnectionFailure() {
            infoPopup.show(qsTr("Nie można połączyć się z tablicą"))
        }
    }

    onVisibleChanged: {
        if (visible && screensView.currentIndex >= 0) {
            let item = screensModel.get(screensView.currentIndex)

            TablicaConnector.buffer = item
        }
    }

    Component.onCompleted: {
        ScreenAwake.preventSleep()
    }

    Component.onDestruction: {
        ScreenAwake.allowSleep()
        TablicaConnector.clearScreen()
    }

    Rectangle {
        id: root
        anchors.fill: parent
        color: Theme.background

        Rectangle {
            id: topBar
            anchors {
                top: parent.top
                right: parent.right
                left: parent.left
            }
            color: Theme.header
            height: 50

            Button {
                id: buttonEditSet
                anchors {
                    left: parent.left
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                text: Icon.arrowLeft

                Material.background: "transparent"
                Material.foreground: "white"
                font.family: "Material Design Icons"
                font.pixelSize: 20

                flat: true
                onClicked: {
                    Navigation.pop();
                }
            }

            Button {
                id: buttonEnableTransmission
                anchors {
                    right: parent.right
                    rightMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                text: qsTr("Transmisja") + " " + Icon.cast

                Material.background: "transparent"
                Material.foreground: "white"
                font.family: "Material Design Icons"
                font.pixelSize: 20

                highlighted: TablicaConnector.enabled
                flat: true
                onClicked: {
                    TablicaConnector.enabled = (!(TablicaConnector.enabled));
                    this.highlighted = TablicaConnector.enabled;
                }
            }
        }

        Rectangle {
            id: mainView
            anchors {
                top: topBar.bottom
                right: setView.left
                bottom: parent.bottom
                left: parent.left
            }

            color: "transparent"

            Rectangle {
                id: screenView
                anchors {
                    top: parent.top
                    right: parent.right
                    bottom: screenViewButtons.top
                    left: parent.left
                    rightMargin: 50
                    leftMargin: 50
                }

                color: "transparent"

                TablicaScreen {
                    id: tablicaScreen
                    anchors.margins: 20

                    content: TablicaConnector.buffer.text
                    hymnFont: TablicaConnector.buffer.font
                }

                //Change screens by swiping gesture
                DragHandler {
                    id: swipeHandler

                    target: null

                    xAxis.enabled: true
                    yAxis.enabled: false

                    property real startX: 0

                    onActiveChanged: {
                        if (active) {
                            startX = centroid.position.x;
                        } else {
                            let delta = centroid.position.x - startX;

                            if (delta < -150) {
                                root1.changeScreen(1);
                            }
                            else if (delta > 150) {
                                root1.changeScreen(-1);
                            }
                        }
                    }
                }
            }
            Button {
                id: buttonHideScreenOptions
                anchors {
                    bottom: screenViewButtons.top
                    left: parent.left
                    leftMargin: 10
                    bottomMargin: -30
                }

                height: 75
                width: 50
                Text {
                    anchors {
                        top: parent.top
                        topMargin: 20
                        horizontalCenter: parent.horizontalCenter
                    }

                    text: Icon.dotsHorizontal
                    font.family: "Material Design Icons"
                    font.pixelSize: 24
                    color: Theme.text
                }
                onClicked: {
                    AppSettings.screenViewButtons === "open" ? AppSettings.screenViewButtons = "closed" : AppSettings.screenViewButtons = "open";
                    console.log(AppSettings.screenViewButtons);
                }
            }

            Rectangle {
                id: screenViewButtons
                anchors {
                    left: parent.left
                    right: parent.right
                }

                width: parent.width
                height: 65
                color: Theme.panel

                border.color: Theme.panelBorder
                border.width: 1

                state: AppSettings.screenViewButtons
                states: [
                    State {
                        name: "open"
                        PropertyChanges {
                            target: screenViewButtons
                            y: parent.height - screenViewButtons.height
                        }
                    },
                    State {
                        name: "closed"
                        PropertyChanges {
                            target: screenViewButtons
                            y: parent.height
                        }
                    }
                ]
                transitions: Transition {
                    NumberAnimation {
                        properties: "y"
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                }

                Button {
                    id: buttonChangeView
                    anchors {
                        left: parent.left
                        bottom: parent.bottom
                        margins: 10
                    }
                    text: qsTr("Widok")
                    onClicked: {
                        AppSettings.screenView === "screenView" ? AppSettings.screenView = "textView" : AppSettings.screenView === "textView" ? AppSettings.screenView = "textViewRev" : AppSettings.screenView = "screenView";
                    }
                }

                // Switch {
                //     id: buttonShowAll

                //     anchors {
                //         right: buttonScreenEdit.left
                //         rightMargin: 10
                //         verticalCenter: parent.verticalCenter
                //     }

                //     text: qsTr("Pokaż wszystkie slajdy")

                //     checked: screensModel.showAll

                //     onToggled: {
                //         screensModel.showAll = checked
                //     }
                // }

                Button {
                    id: buttonSetItemProperties
                    anchors {
                        right: buttonScreenEdit.left
                        bottom: parent.bottom
                        margins: 10
                    }
                    text: qsTr("Właściwości")

                    enabled: root1.currentScreen !== null && root1.currentScreen.screenId !== -1 && !root1.showHymnMode

                    onClicked: {
                        if (!enabled)
                            return

                        screenSwitcherDialog.hymnId = root1.currentScreen.hymnId
                        screenSwitcherDialog.open()
                    }
                }


                Button {
                    id: buttonScreenEdit

                    anchors {
                        right: parent.right
                        bottom: parent.bottom
                        margins: 10
                    }

                    text: qsTr("Edytuj slajd")
                    enabled: root1.currentScreen !== null && root1.currentScreen.screenId !== -1

                    onClicked: {
                        if (!enabled)
                            return

                        Navigation.push(
                            Qt.resolvedUrl("../editors/ScreenEditorPage.qml"),
                            {
                                screenIdx: screensView.currentIndex,
                                screenModel: screensModel
                            }
                        )
                    }
                }
            }
        }

        Button {
            id: buttonHideSetView
            anchors {
                top: topBar.bottom
                right: setView.left
                rightMargin: -30
            }

            Text {
                anchors {
                    left: parent.left
                    top: parent.top
                    topMargin: 15
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                }

                text: setView.state === "open" ? Icon.chevronRight : Icon.chevronLeft

                font.family: "Material Design Icons"
                font.pixelSize: 24
                color: Theme.text
            }

            onClicked: {
                if (setView.state === "open") {
                    AppSettings.setView = "closed";
                } else {
                    AppSettings.setView = "open";
                }
            }
        }

        Rectangle {
            id: setView
            anchors {
                top: topBar.bottom
                bottom: parent.bottom
            }
            width: parent.width * 0.2
            color: Theme.panel
            border.color: Theme.panelBorder
            border.width: 1
            state: AppSettings.setView
            states: [
                State {
                    name: "open"
                    PropertyChanges {
                        target: setView
                        x: parent.width - setView.width
                    }
                },
                State {
                    name: "closed"
                    PropertyChanges {
                        target: setView
                        x: parent.width
                    }
                }
            ]
            transitions: Transition {
                NumberAnimation {
                    properties: "x"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }

            Text {
                id: textSetView
                anchors {
                    top: parent.top
                    left: parent.left
                    margins: 10
                }
                text: qsTr("Zestaw:")
                color: Theme.textSecondary
                font.pixelSize: 20
                font.bold: true
            }

            ListView {
                id: screensView
                anchors {
                    top: textSetView.bottom
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    topMargin: 10
                    rightMargin: 3
                    bottomMargin: 10
                    leftMargin: 10
                }
                spacing: 6
                clip: true

                Behavior on contentY {
                    SmoothedAnimation {
                        duration: 150
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    width: 6
                    policy: ScrollBar.AlwaysOn

                    contentItem: Rectangle {
                        radius: 3
                        color: Theme.scrollbar
                    }

                    background: Rectangle {
                        color: "transparent"
                    }
                }

                model: screensModel

                Component.onCompleted: {
                    if(root1.selectedHymnId > -1)
                        screensView.currentIndex = root1.findFirstScreenByHymnId(root1.selectedHymnId)
                }

                delegate: SetViewItems {
                    id: setViewItemsDelegate
                    width: ListView.view.width - 10

                    vid: model.order+1
                    title: model.hymnName
                    subtitle: model.excerpt

                    showAll: screensModel.showAll
                    shown: model.shown


                    onClicked: {
                        screensView.currentIndex = index;
                    }

                    onVisibilityChanged: shown => {
                        screensModel.changeScreenVisibility(index, shown)
                    }
                }
                onCurrentIndexChanged: {
                    if (currentIndex < 0)
                        return

                    let item = screensModel.get(currentIndex)

                    root1.currentScreen = item
                    root1.selectedScreenId = item.screenId

                    TablicaConnector.buffer = item

                    let target = Math.max(0, currentIndex - 1)

                    contentY = Math.max(
                        0,
                        Math.min(
                            target * (60 + screensView.spacing),
                            contentHeight - height
                        )
                    )
                }
            }
        }
    }

    Popup {
        id: infoPopup

        parent: Overlay.overlay

        x: (parent.width - width) / 2
        y: parent.height - height - 40

        padding: 12
        modal: false
        focus: false
        closePolicy: Popup.NoAutoClose

        background: Rectangle {
            radius: 6
            color: Theme.popup
        }

        Label {
            id: infoText
            color: "white"
        }

        Timer {
            id: hideTimer
            interval: 2500
            onTriggered: infoPopup.close()
        }

        function show(message) {
            infoText.text = message
            open()
            hideTimer.restart()
        }
    }
}
