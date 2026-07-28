import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Effects

import TablicaZnakowa

Item {
    id: root1

    property int currentSet

    PresentationModel {
        id: screensModel
        setId: root1.currentSet
        Component.onCompleted: reload()
    }

    Rectangle {
        id: root
        anchors.fill: parent
        color: "#FFFFFF"

        Rectangle {
            id: topBar
            anchors {
                top: parent.top
                right: parent.right
                left: parent.left
            }
            color: "#474747"
            height: 50

            Button {
                id: buttonEditSet
                anchors {
                    left: parent.left
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                text: "Edytuj zestaw"
                flat: true
                Material.foreground: "white"
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
                text: "Transmisja"
                Material.foreground: "white"
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

                TablicaScreen {
                    id: tablicaScreen
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

                            if (delta < -100) {
                                if (screensView.currentIndex < screensModel.rowCount() - 1) {
                                    screensView.currentIndex++;
                                }
                            } else if (delta > 100) {
                                if (screensView.currentIndex > 0) {
                                    screensView.currentIndex--;
                                }
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
                        topMargin: 5
                        horizontalCenter: parent.horizontalCenter
                    }

                    text: "..."
                    font.pixelSize: 24
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
                color: "#cfcfcf"

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
                    text: "Widok"
                    onClicked: {
                        AppSettings.screenView === "screenView" ? AppSettings.screenView = "textView" : AppSettings.screenView === "textView" ? AppSettings.screenView = "textViewRev" : AppSettings.screenView = "screenView";
                    }
                }

                Button {
                    id: buttonSetItemProperties
                    anchors {
                        right: buttonScreenEdit.left
                        bottom: parent.bottom
                        margins: 10
                    }
                    text: "Właściwości"
                }

                Button {
                    id: buttonScreenEdit
                    anchors {
                        right: parent.right
                        bottom: parent.bottom
                        margins: 10
                    }
                    text: "Edytuj slajd"
                }
            }
        }

        Button {
            id: buttonHideSetView
            anchors {
                top: topBar.bottom
                right: setView.left
                rightMargin: -20
            }
            text: setView.state === "open" ? ">" : "<"
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
            color: "#cfcfcf"
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
                text: "Zestaw:"
                color: "#595959"
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
                        color: "#888888"
                    }

                    background: Rectangle {
                        color: "transparent"
                    }
                }

                model: screensModel

                delegate: SetViewItems {
                    id: setViewItemsDelegate
                    width: ListView.view.width - 10

                    vid: model.order
                    title: model.hymnName
                    subtitle: model.excerpt

                    onClicked: {
                        screensView.currentIndex = index;
                    }
                }
                onCurrentIndexChanged: {
                    let item = screensModel.get(currentIndex);
                    TablicaConnector.buffer = item;

                    let target = Math.max(0, currentIndex - 1)

                    contentY = Math.max(0,Math.min(target * (60 + screensView.spacing),contentHeight-height))
                }
            }
        }
    }
}
