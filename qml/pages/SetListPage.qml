import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Prezenter

Item {
    id: root

    property int selectedSetId: -1
    property int selectedHymnId: -1

    SetModel {
        id: setModel

        Component.onCompleted:
            reload()
    }

    SetHymnModel {
        id: hymnModel

        Component.onCompleted:
            reload()
    }

    SetScreenModel {
        id: screenModel
    }

    Rectangle {
        anchors.fill: parent
        color: "#ffffff"

        // Top Bar
        Rectangle {
            id: topBar

            height: 50

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            color: "#474747"


            Button {
                text: "Powrót"

                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }

                flat: true

                Material.foreground: "white"

                onClicked: {
                    Navigation.pop()
                }
            }

            Text {
                anchors.centerIn: parent

                text: "Zestawy"

                color: "white"

                font.pixelSize: 22
                font.bold: true
            }

            Button {
                text: "Prezentuj >"

                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                flat: true

                Material.foreground: "white"

                onClicked: {
                    Navigation.push(Qt.resolvedUrl("PresentationPage.qml"),{"currentSet": root.selectedSetId})
                }
            }
        }

        // Body
        RowLayout {
            anchors {
                top: topBar.bottom
                bottom: parent.bottom

                left: parent.left
                right: parent.right

                margins: 10
            }

            spacing: 10

            SetPanel {
                Layout.fillHeight: true
                Layout.preferredWidth:  parent.width * 0.25

                model: setModel

                selectedId: root.selectedSetId

                onSelected: id => {
                    root.selectedSetId = id

                    hymnModel.parentId = id
                    screenModel.setId = id

                    root.selectedHymnId = -1
                    screenModel.hymnId = -1
                }

                onAddSet: name => {
                    setModel.add(name)
                }

                onUpdateSet: (row, name) => {
                    setModel.update(row, name)
                }

                onRemoveSet: row => {
                    if(setModel.get(row).setId === root.selectedSetId)
                    {
                        screenModel.setId = -1
                        hymnModel.parentId = -1
                        root.selectedSetId = -1
                    }
                    setModel.removeRow(row)
                    hymnModel.reload()
                }

            }

            HymnPanel {
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.35

                setMode: true

                model: hymnModel

                selectedId: root.selectedHymnId

                onSelected: id => {
                    root.selectedHymnId = id
                    screenModel.hymnId = id
                }

                onAddHymnToSet: id => {
                    hymnModel.addHymn(id)
                }

                onRemoveHymn: row => {
                    if (hymnModel.get(row).hymnId === root.selectedHymnId) {
                        root.selectedHymnId = -1
                        screenModel.hymnId = -1
                        screenModel.reload()
                    }
                    hymnModel.removeHymn(row)
                }

                onMoveHymn: (from, to) => {
                    hymnModel.move(from, to)
                }
            }

            SlimScreenPanel {
                Layout.fillHeight: true
                Layout.fillWidth: true

                model: screenModel

                onChangeAllScreens: visible => {
                    screenModel.changeAllScreenVisibility(visible)
                }

                onToggleScreen: (row, visible) => {
                    screenModel.changeScreenVisibility(row,visible)
                }
            }
        }
    }

}
