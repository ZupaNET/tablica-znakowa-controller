import QtQuick 2.15
import QtQuick.Controls 2.15

import TablicaZnakowa

Item {
    SetHymnListModel{
        id: setHymnListModel
        Component.onCompleted: reload()
    }

    SetListModel{
        id: setListModel
        Component.onCompleted: reload()
    }

    Rectangle{
        anchors.fill: parent
        color: "#FFFFFF"

        Dialog {
            id: dialogDelete
            anchors.centerIn: parent

            title: "Usunąć listę?"
            modal: true
            focus: true

            standardButtons: Dialog.Yes | Dialog.No

            onAccepted: {
                console.log("Usunięto")
            }

            onRejected: {
                console.log("Anulowano")
            }
        }

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
                id: backButton
                anchors {
                    left: parent.left
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                text: "Powrót"
                flat: true
                Material.foreground: "white"
                onClicked: {
                    stack.pop()
                }
            }
        }
        Rectangle{
            id: setsViewContainer
            anchors {
                top: topBar.bottom
                right: setDetails.left
                bottom: parent.bottom
                left: parent.left
            }

            ListView{
                id: setsView
                anchors {
                    fill: parent
                    topMargin: 10
                    rightMargin: 3
                    bottomMargin: 10
                    leftMargin: 10
                }
                spacing: 6
                clip: true
                rightMargin: 8

                ScrollBar.vertical: ScrollBar{
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

                model: setListModel

                delegate: Button{
                    id: setsViewDelegate
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: model.name
                    width: parent.width - 50
                    onClicked: {
                        setHymnListModel.setId = model.id
                        setsView.currentIndex = index
                    }
                }

                highlight: Rectangle{
                    color: "blue"
                }
            }
        }
        Rectangle{
            id: setDetails
            anchors {
                top: topBar.bottom
                right: parent.right
                bottom: parent.bottom
            }
            width: parent.width * 0.4
            color: "#f2f2f2"

            Text{
                id: textSetDetails
                anchors {
                    top: parent.top
                    left: parent.left
                    margins: 10
                }
                text: "Składniki zestawu:"
                color: "#595959"
                font.pixelSize: 20
                font.bold: true
            }

            Rectangle{
                anchors{
                    top: textSetDetails.bottom
                    right: parent.right
                    bottom: buttonRemoveSet.top
                    left: parent.left
                }

                ListView{
                    id: setComponents
                    anchors {
                        fill: parent
                        topMargin: 10
                        rightMargin: 3
                        bottomMargin: 10
                        leftMargin: 10
                    }
                    spacing: 6
                    clip: true

                    model: setHymnListModel
                    delegate: Button{
                        id: setsComponentsDelegate
                        anchors.horizontalCenter: parent?.horizontalCenter
                        text: model.name
                        width: parent?.width - 50
                    }
                }
            }

            Button {
                id: buttonRemoveSet
                anchors {
                    left: parent.left
                    bottom: parent.bottom
                    margins: 10
                }
                Material.foreground: "red"
                text: "Skasuj"

                onClicked: {
                    dialogDelete.open()
                }
            }

            Button {
                id: buttonEditSet
                anchors {
                    right: buttonPresent.left
                    bottom: parent.bottom
                    rightMargin: 30
                    bottomMargin: 10
                }
                text: "Edytuj"
                onClicked: {

                }
            }

            Button {
                id: buttonPresent
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    margins: 10
                }
                text: "Prezentuj >"
                onClicked: {
                    Navigation.push(Qt.resolvedUrl("PresenterMode.qml"),{"currentSet":setHymnListModel.setId})
                }
            }
        }
    }
}
