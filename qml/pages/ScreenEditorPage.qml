import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Prezenter

Item {
    id: root

    property var screenModel

    property int hymnId: -1
    property int screenIdx: -1

    property string initialText: ""
    property int initialFont: 0

    Component.onCompleted: {
        if (root.screenIdx >= 0 && root.screenModel) {

            let screen = root.screenModel.get(root.screenIdx)

            root.initialText = screen.text
            root.initialFont = screen.font
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#FFFFFF"
    }

    Rectangle {
        id: topBar

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: 50
        color: "#474747"

        Label {
            anchors.centerIn: parent

            text: root.screenIdx < 0
                  ? "Nowy slajd"
                  : "Edycja slajdu"

            color: "white"

            font.pixelSize: 20
            font.bold: true
        }
    }

    ColumnLayout {
        anchors {
            top: topBar.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right

            margins: 20
        }

        spacing: 15

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true

            color: "transparent"

            TablicaScreen {
                id: editor

                anchors.fill: parent

                editable: true

                content: root.initialText

                hymnFont: fontSelector.currentIndex
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1

            color: "#cccccc"
        }

        RowLayout {
            Layout.fillWidth: true

            Label {
                text: "Font: "
            }

            ComboBox {
                id: fontSelector

                Layout.preferredWidth: 140

                model: [
                    "MiniSet2",
                    "MiniForma2",
                    "Sans Serif"
                ]
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: "Anuluj"

                onClicked: {
                    Navigation.pop()
                }
            }

            Button {
                text: "Zapisz"

                onClicked: {
                    if (!root.screenModel) {
                        console.error("Brak screenModel")
                        return
                    }


                    if (root.screenIdx < 0) {
                        root.screenModel.add(editor.content, fontSelector.currentIndex)
                    }
                    else {
                        root.screenModel.update(root.screenIdx, editor.content, fontSelector.currentIndex)
                    }

                    Navigation.pop()
                }
            }
        }
    }
}
