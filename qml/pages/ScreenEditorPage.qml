import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Prezenter

Item {
    id: root

    property var screenModel

    property int screenIdx: -1

    property string initialText: ""
    property int initialFont: 2

    Component.onCompleted: {
        if (root.screenIdx >= 0 && root.screenModel) {

            let screen = root.screenModel.get(root.screenIdx)

            root.initialText = screen.text
            root.initialFont = screen.font
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.background
    }

    Rectangle {
        id: topBar

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: 50
        color: Theme.header

        visible: !Qt.inputMethod.visible

        Label {
            anchors.centerIn: parent

            text: root.screenIdx < 0
                  ? qsTr("Nowy slajd")
                  : qsTr("Edycja slajdu")

            color: "white"

            font.pixelSize: 20
            font.bold: true
        }
    }

    ColumnLayout {
        anchors {
            top: Qt.inputMethod.visible ? parent.top : topBar.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        spacing: 15

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true

            color: "transparent"
            clip: true

            Flickable {
                id: flick

                anchors.fill: parent

                clip: true

                contentWidth: width
                contentHeight: Math.max(height, editor.implicitHeight)

                ScrollBar.vertical: ScrollBar {}

                TablicaScreen {
                    id: editor

                    anchors.margins: 20

                    width: flick.width
                    height: Math.max(flick.height, implicitHeight)

                    implicitHeight: 600

                    editable: true
                    content: root.initialText
                    hymnFont: fontSelector.currentIndex
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: toolBar.implicitHeight + 16

            color: Theme.panel

            visible: !Qt.inputMethod.visible

            RowLayout {
                id: toolBar
                anchors.fill: parent
                anchors.margins: 8

                Label {
                    text: qsTr("Rozmiar czcionki: ")

                    color: Theme.text
                }

                ComboBox {
                    id: fontSelector

                    Layout.preferredWidth: 140

                    model: [
                        qsTr("Mała"),
                        qsTr("Średnia"),
                        qsTr("Duża")
                    ]

                    currentIndex: root.initialFont
                }

                Item {
                    Layout.preferredWidth: 10
                }

                Button {
                    text: qsTr("Widok")

                    onClicked: {
                        AppSettings.screenView === "screenView" ? AppSettings.screenView = "textView" : AppSettings.screenView === "textView" ? AppSettings.screenView = "textViewRev" : AppSettings.screenView = "screenView";
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Button {
                    text: qsTr("Anuluj")

                    onClicked: {
                        Navigation.pop()
                    }
                }

                Button {
                    text: qsTr("Zapisz")

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
}
