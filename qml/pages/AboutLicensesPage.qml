import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../Icon.js" as MdiFont

import Prezenter

Item {
    id: root

    Rectangle {
        anchors.fill: parent

        color: "#f3f5f7"

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
                text: qsTr("Powrót")

                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }

                flat: true

                Material.foreground: "white"

                onClicked: Navigation.pop()
            }

            Text {
                anchors.centerIn: parent

                text: qsTr("Licencje")

                color: "white"

                font.pixelSize: 22
                font.bold: true
            }
        }

        RowLayout {
            anchors {
                top: topBar.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom

                margins: 24
            }

            Rectangle {
                Layout.preferredWidth: 260
                Layout.fillHeight: true

                radius: 16

                color: "white"

                border.color: "#dddddd"


                ListView {
                    id: list

                    anchors.fill: parent
                    anchors.margins: 8

                    clip: true

                    spacing: 6

                    model: [
                        {
                            name: "GNU GPL 2.0-only",
                            file: "qrc:/licenses/GPL-2.0-only.txt"
                        },
                        {
                            name: "Qt Framework",
                            file: "qrc:/licenses/Qt.txt"
                        },
                        {
                            name: "Arimo",
                            file: "qrc:/licenses/Arimo.txt"
                        },
                        {
                            name: "FreeSans",
                            file: "qrc:/licenses/FreeSans.txt"
                        },
                        {
                            name: "Material Design Icons",
                            file: "qrc:/licenses/MaterialDesignIcons.txt"
                        },
                        {
                            name: "MiniForma2",
                            file: "qrc:/licenses/MiniForma2.txt"
                        },
                        {
                            name: "MiniSet2",
                            file: "qrc:/licenses/MiniSet2.txt"
                        }
                    ]

                    delegate: Rectangle {

                        width: ListView.view.width

                        height: 48

                        radius: 8

                        color:
                            ListView.isCurrentItem
                            ? "#d7ecff"
                            : "#f4f4f4"

                        Label {
                            anchors.fill: parent

                            anchors.leftMargin: 12

                            verticalAlignment: Text.AlignVCenter

                            text: modelData.name
                        }

                        TapHandler {
                            onTapped: {

                                list.currentIndex = index

                                licenses.load(
                                    modelData.file
                                )
                            }
                        }
                    }
                }
            }

            Rectangle {

                Layout.fillWidth: true
                Layout.fillHeight: true

                radius: 16

                color: "white"

                border.color: "#dddddd"


                Flickable {

                    anchors.fill: parent

                    anchors.margins: 16

                    clip: true


                    contentWidth: width
                    contentHeight: licenseText.implicitHeight


                    Text {

                        id: licenseText

                        width: parent.width

                        wrapMode: Text.WordWrap

                        textFormat: Text.PlainText

                        color: "#333333"

                        text: licenses.text
                    }
                }
            }
        }
    }

    QtObject {
        id: licenses


        property string currentFile: "qrc:/licenses/GPL-2.0-only.txt"

        property string text: ""

        function load(path) {
            currentFile = path

            var request = new XMLHttpRequest()

            request.onreadystatechange = function() {

                if(request.readyState === XMLHttpRequest.DONE) {

                    if(request.status === 200) {
                        text = request.responseText
                    }
                    else {
                        text = qsTr("Nie można załadować licencji.")
                    }
                }
            }

            request.open(
                "GET",
                path
            )

            request.send()
        }
    }

    Component.onCompleted: {

        list.currentIndex = 0

        licenses.load(
            list.model[0].file
        )
    }
}