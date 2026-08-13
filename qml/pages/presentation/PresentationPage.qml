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
    id: root

    property alias presentId: presentationModel.presentId
    property alias hymnMode: presentationModel.hymnMode
    property string presentName : ""

    property int screenRev: 0

    readonly property var currentScreen: {
        screenRev

        if(screenList.currentIndex < 0) return null
        return presentationModel.get(screenList.currentIndex)
    }

    signal presentationClosed()

    PresentationModel {
        id: presentationModel

        Component.onCompleted: reload()
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.background
    }

    PageHeader {
        id: topBar

        visible: !Qt.inputMethod.visible

        title: root.hymnMode ? qsTr("Prezentacja pieśni") : qsTr("Prezentacja zestawu")

        Button {
            anchors {
                right: parent.right
                rightMargin: 10
                verticalCenter: parent.verticalCenter
            }

            text: qsTr("Transmisja") + " " + Icon.cast

            highlighted: TablicaConnector.enabled
            flat: true

            Material.background: "transparent"
            Material.foreground: "white"
            font.family: "Material Design Icons"
            font.pixelSize: 20

            onClicked: {
                TablicaConnector.enabled = !TablicaConnector.enabled
            }
        }
    }

    RowLayout {
        anchors {
            top: topBar.bottom
            bottom: parent.bottom
            right: parent.right
            left: parent.left
        }

        spacing: 0

        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true

            spacing: 0

            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true

                Layout.rightMargin: 25

                color: "transparent"

                TablicaScreen {
                    anchors.margins: 20
                    anchors.fill: parent

                    editable: false

                    content: root.currentScreen.text
                    hymnFont: root.currentScreen.font
                }

                SwipeArea {
                    anchors.fill: parent

                    threshold: 100

                    onSwipedLeft: root.screenNext()

                    onSwipedRight: root.screenBack()
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: AppSettings.screenViewButtons === "open" ? 65 + 25 : 25

                clip: false

                Behavior on Layout.preferredHeight {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                }

                Rectangle {
                    id: bottomBar

                    anchors.fill: parent
                    anchors.rightMargin: 0
                    anchors.topMargin: 25

                    clip: true

                    color: Theme.panel
                    border.color: Theme.panelBorder
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent

                        spacing: 16

                        Button {
                            Layout.leftMargin: 10

                            text: qsTr("Widok")

                            onClicked: {
                                switch (AppSettings.screenView) {
                                case "screenView":
                                    AppSettings.screenView = "textView"
                                    break

                                case "textView":
                                    AppSettings.screenView = "textViewRev"
                                    break

                                default:
                                    AppSettings.screenView = "screenView"
                                    break
                                }
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Button {
                            text: qsTr("Właściwości")

                            enabled: root.currentScreen.screenId !== -1 && !root.hymnMode

                            onClicked: {
                                screenSwitcherDialog.hymnId = root.currentScreen.hymnId
                                screenSwitcherDialog.savedScreenId = root.currentScreen.screenId
                                screenSwitcherDialog.open()
                            }
                        }

                        Button {
                            Layout.rightMargin: 10

                            text: qsTr("Edytuj slajd")

                            enabled: root.currentScreen.screenId !== -1

                            onClicked: {
                                const page = Navigation.push(
                                    Qt.resolvedUrl("../editors/ScreenEditorPage.qml"),
                                    {
                                        row: screenList.currentIndex,
                                        content: root.currentScreen.text,
                                        fontIndex: root.currentScreen.font
                                    }
                                )

                                if(page)
                                    page.accepted.connect(function(content, fontIndex){
                                        presentationModel.update(screenList.currentIndex, content, fontIndex)
                                        screenRev++
                                    })
                            }
                        }
                    }
                }

                Button {
                    id: bottomBarButton

                    anchors.left: bottomBar.left
                    anchors.bottom: bottomBar.top
                    anchors.leftMargin: 25
                    anchors.bottomMargin: -height/2

                    width: 48
                    height: 80

                    z: -1

                    topPadding: 15

                    text: AppSettings.screenViewButtons === "open" ? Icon.chevronDown : Icon.chevronUp

                    contentItem: Text {
                        text: bottomBarButton.text

                        font.family: "Material Design Icons"
                        font.pixelSize: 22

                        color: Theme.text

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignTop

                        renderType: Text.NativeRendering
                    }

                    onClicked: {
                        AppSettings.screenViewButtons = AppSettings.screenViewButtons === "open" ? "closed" : "open"
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.preferredWidth: AppSettings.setView === "open" ? root.width * 0.2 : 0

            clip: false

            Behavior on Layout.preferredWidth {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }

            Rectangle {
                id: setPanel
                anchors.fill: parent

                clip: true

                color: Theme.panel
                border.color: Theme.panelBorder
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.topMargin: 10
                    anchors.leftMargin: 10
                    anchors.bottomMargin: 10
                    anchors.rightMargin: 2

                    spacing: 10

                    Text {
                        Layout.fillWidth: true

                        text: qsTr("Zestaw:")

                        color: Theme.textSecondary

                        font.pixelSize: 20
                        font.bold: true
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.rightMargin: 3

                        ListView {
                            id: screenList

                            anchors.fill: parent

                            spacing: 6
                            clip: true

                            model: presentationModel

                            delegate: SetViewItemDelegate {
                                width: ListView.view.width - 10

                                vid: model.order + 1
                                title: model.hymnName
                                subtitle: model.excerpt

                                onClicked: {
                                    screenList.currentIndex = index
                                }
                            }

                            Behavior on contentY {
                                id: screenListAnimation

                                SmoothedAnimation {
                                    duration: 150
                                }
                            }

                            ScrollBar.vertical: ScrollBar {
                                width: 6
                                policy: ScrollBar.AlwaysOn
                            }

                            onCurrentIndexChanged: {
                                if(currentIndex < 0)
                                    return

                                let item = presentationModel.get(currentIndex)

                                TablicaConnector.buffer = item

                                root.updateScreenListPosition()
                            }
                        }

                        ListPanelFade {
                            listView: screenList
                            isTop: true
                            fadeColor: Theme.panel
                        }

                        ListPanelFade {
                            listView: screenList
                            isTop: false
                            fadeColor: Theme.panel
                        }

                    }
                }
            }

            Button {
                id: setPanelButton

                anchors.right: setPanel.left
                anchors.top: setPanel.top
                anchors.topMargin: 25
                anchors.rightMargin: -width/2

                width: 80
                height: 48

                z: -1

                leftPadding: 12

                text: AppSettings.setView === "open" ? Icon.chevronRight : Icon.chevronLeft

                contentItem: Text {
                    text: setPanelButton.text

                    font.family: "Material Design Icons"
                    font.pixelSize: 22

                    color: Theme.text

                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter

                    renderType: Text.NativeRendering
                }

                onClicked: {
                    AppSettings.setView = AppSettings.setView === "open" ? "closed" : "open"
                }
            }
        }
    }

    function screenBack() {
        if(screenList.currentIndex - 1 < 0)
            return false

        screenList.currentIndex--

        return true
    }

    function screenNext() {
        if(screenList.currentIndex + 1 >= presentationModel.rowCount())
            return false

        screenList.currentIndex++

        return true
    }

    function goToHymn(id) {
        if(id < 0)
            return

        for(let i = 0; i < presentationModel.rowCount(); i++) {
            if(presentationModel.get(i).hymnId === id) {
                screenList.currentIndex = i
                return
            }
        }
    }

    function goToScreen(id) {
        if(id < 0)
            return

        for(let i = 0; i < presentationModel.rowCount(); i++) {
            if(presentationModel.get(i).screenId === id) {
                screenList.currentIndex = i
                return
            }
        }

        if(!screenBack())
            screenNext()
    }

    function updateScreenListPosition()
    {
        if (screenList.currentIndex < 0)
            return

        const target = Math.max(0, screenList.currentIndex - 1)

        screenList.contentY = Math.max(
            0,
            Math.min(
                target * (60 + screenList.spacing),
                screenList.contentHeight - screenList.height
            )
        )
    }

    Component.onCompleted: {
        ScreenAwake.preventSleep()
        TablicaConnector.enabled = false
    }

    Component.onDestruction: {
        root.presentationClosed()

        ScreenAwake.allowSleep()
        TablicaConnector.enabled = false
    }

    Connections {
        target: TablicaConnector

        function onConnectionFailure() {
            infoPopup.show(qsTr("Nie można połączyć się z tablicą"))
        }
    }

    Connections {
        target: presentationModel

        function onDataChanged() {
            let item = presentationModel.get(screenList.currentIndex)
            TablicaConnector.buffer = item
        }
    }

    ScreenSwitcherDialog {
        id: screenSwitcherDialog

        setId: root.presentId

        onClosed: {
            screenListAnimation.enabled = false
            presentationModel.reload()
            root.goToScreen(screenSwitcherDialog.savedScreenId)
            screenRev++

            Qt.callLater(function() {
                root.updateScreenListPosition()
                screenListAnimation.enabled = true
            })
        }
    }
}