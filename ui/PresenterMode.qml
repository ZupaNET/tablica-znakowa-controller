import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Effects

import TablicaZnakowa

Item {
    ScreenListModel {
        id: screensModel
        hymnId: 152
        Component.onCompleted: reload()
    }

    Rectangle{
        id: root
        anchors.fill: parent
        color: "#FFFFFF"

        //property real scaleFactor: Math.min(width / 1280, height / 800)

        Rectangle{
            id: topBar
            anchors {
                top: parent.top
                right: parent.right
                left: parent.left
            }
            color: "#474747"
            height: 50

            Button{
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
                    Navigation.pop()
                }
            }

            Button{
                id: buttonFreeze
                anchors {
                    right: parent.right
                    rightMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                text: "Transmisja"
                Material.foreground: "white"
                flat: true
                onClicked: {
                    TablicaConnector.enabled = (!(TablicaConnector.enabled));
                    this.highlighted = TablicaConnector.enabled;
                }
            }
        }

        Rectangle{
            id: mainView
            anchors {
                top: topBar.bottom
                right: setView.left
                bottom: parent.bottom
                left: parent.left
            }

            // Text{
            //     id: textSetTitle
            //     anchors {
            //         top: parent.top
            //         left: parent.left
            //         topMargin: 10
            //         leftMargin: 20
            //     }
            //     text: "Niedziela zwykła"
            //     font.pixelSize: 30
            // }

            // Text{
            //     id: textHymnTitle
            //     anchors {
            //         top: textSetTitle.bottom
            //         left: parent.left
            //         topMargin: -3
            //         bottomMargin: 10
            //         leftMargin: 20
            //     }
            //     text: TablicaConnector.buffer.hymnName
            //     font.pixelSize: 15
            // }

            Rectangle {
                id: screenView
                anchors {
                    top: parent.top
                    right: parent.right
                    bottom: parent.bottom
                    left: parent.left
                    rightMargin: 50
                    leftMargin: 50
                    bottomMargin: screenViewButtonsDrawer.position * screenViewButtonsDrawer.height
                }

                TablicaScreen {
                    id: tablicaScreen
                    content: TablicaConnector.buffer.text
                    hymnFont: TablicaConnector.buffer.font
                }
            }

            Button{
                id: buttonHideScreenOptions
                x: 10
                y: root.height - height - 20 - (screenViewButtonsDrawer.position * screenViewButtonsDrawer.height)
                height: 75;
                width: 50;
                Text{
                    anchors{
                        top: parent.top
                        topMargin: 5
                        horizontalCenter: parent.horizontalCenter
                    }

                    text: "..."
                    font.pixelSize: 24
                }
                onClicked: {
                    if(screenViewButtonsDrawer.opened){
                        screenViewButtonsDrawer.close()
                    }else{
                        screenViewButtonsDrawer.open()
                    }
                }
            }

            Drawer{
                id: screenViewButtonsDrawer
                edge: Qt.BottomEdge
                width: parent.width
                height: 65
                modal: false
                interactive: true
                closePolicy: Popup.NoAutoClose

                background: Rectangle{
                        color: "#cfcfcf"
                    }

                    Button{
                        id: buttonChangeView
                        anchors {
                            left: parent.left
                            bottom: parent.bottom
                            margins: 10
                        }
                        text: "Widok"
                        onClicked: {
                            AppSettings.screenView === "screenView"? AppSettings.screenView = "textView" : AppSettings.screenView === "textView"? AppSettings.screenView = "textViewRev" : AppSettings.screenView = "screenView";
                        }
                    }

                    Button{
                        id: buttonSetItemProperties
                        anchors {
                            right: buttonScreenEdit.left
                            bottom: parent.bottom
                            margins: 10
                        }
                        text: "Właściwości"
                    }

                    Button{
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

        Button{
            id: buttonHideSetView
            anchors {
                top: topBar.bottom
                right: setView.left
                rightMargin: -20
            }
            text: setView.state === "open"? ">" : "<"
            onClicked: {
                if(setView.state === "open"){
                    AppSettings.setView = "closed";
                }else{
                    AppSettings.setView = "open";
                }
            }
        }

        Rectangle{
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

            Text{
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
                    width: ListView.view.width - 10

                    vid: model.order
                    title: model.hymnName
                    subtitle: model.excerpt

                    onClicked: {
                        TablicaConnector.buffer = screen
                        console.log("Wybrano:", title)
                    }
                }
            }
        }
    }
}
