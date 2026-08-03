import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Prezenter
import "../Icon.js" as MdiFont

Item {
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

                text: qsTr("O aplikacji")

                color: "white"

                font.pixelSize: 22
                font.bold: true
            }
        }


        Flickable {
            anchors {
                top: topBar.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom

                margins: 24
            }

            contentHeight: content.implicitHeight

            clip: true


            ColumnLayout {
                id: content

                width: parent.width

                spacing: 20


                Rectangle {
                    Layout.fillWidth: true

                    radius: 16
                    color: "white"
                    border.color: "#dddddd"

                    implicitHeight: intro.implicitHeight + 32

                    ColumnLayout {
                        id: intro

                        anchors.fill: parent
                        anchors.margins: 16

                        spacing: 10

                        Label {
                            text: AppInfo.name + " - " + qsTr("Kontroler")

                            font.pixelSize: 28
                            font.bold: true
                        }


                        Label {
                            text: qsTr("Wersja:") + " " + AppInfo.version

                            font.pixelSize: 18
                            color: "#666666"
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true

                    radius: 16
                    color: "white"
                    border.color: "#dddddd"

                    implicitHeight: licenseL.implicitHeight + 32

                    ColumnLayout {
                        id: licenseL

                        anchors.fill: parent
                        anchors.margins: 16

                        spacing: 10
                        Label {
                            Layout.fillWidth: true

                            text:
                            "Copyright © 2026 " + AppInfo.company +
                            "\n\n" +
                            "This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation version 2 of the License.\n" +
                            "\n" +
                            "This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details." +
                            "\n" +
                            "The above copyright notice, this permission notice, and its license shall be included in all copies or substantial portions of the Software."

                            color: "#777"

                            wrapMode: Text.Wrap

                            font.pixelSize: 13
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true

                    radius: 16
                    color: "white"
                    border.color: "#dddddd"

                    implicitHeight: mkeiaL.implicitHeight + 32

                    ColumnLayout {
                        id: mkeiaL

                        anchors.fill: parent
                        anchors.margins: 16

                        spacing: 10
                        Label {
                            Layout.fillWidth: true

                            text:
                                qsTr("Oryginalna tablica LED oraz pierwotne aplikacje ") +
                                qsTr("zostały stworzone przez:\n\n") +
                                "Marek Kopeć Elektronika i Automatyka s. c."

                            color: "#777"

                            wrapMode: Text.Wrap

                            font.pixelSize: 13
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true

                    radius: 16
                    color: "white"
                    border.color: "#dddddd"

                    implicitHeight: componentsL.implicitHeight + 32

                    ColumnLayout {
                        id: componentsL

                        anchors.fill: parent
                        anchors.margins: 16

                        spacing: 10
                        Label {
                            Layout.fillWidth: true

                            text:
                                qsTr("Aplikacja wykorzystuje następujące komponenty:\n\n") +

                                "• Qt Framework (The Qt Company, LGPL-3.0-only)\n" +
                                "• Arimo font (Steve Matteson, OFL-1.1)\n" +
                                "• FreeSans font (GNU FreeFont, GPL-2.0-with-font-exception)\n" +
                                "• Material Design Icons (Google, Apache-2.0)\n" +
                                "• MiniForma2 (Bartek Nowak, freeware for non-commercial use)\n" +
                                "• MiniSet2 (Bartek Nowak, freeware for non-commercial use)\n\n" +

                                qsTr("Szczegółowe informacje licencyjne znajdują się ") +
                                qsTr("w katalogu resources/licenses w repozytorium oraz poniżej.")

                            color: "#777"

                            wrapMode: Text.Wrap

                            font.pixelSize: 13
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true

                    radius: 16
                    color: "white"
                    border.color: "#dddddd"

                    implicitHeight: licenses.implicitHeight + 32

                    ColumnLayout {
                        id: licenses

                        anchors.fill: parent
                        anchors.margins: 16

                        spacing: 10

                        Button {
                            text: qsTr("Licencje i informacje prawne")

                            onClicked:
                                Navigation.push(
                                    Qt.resolvedUrl("AboutLicensesPage.qml")
                                )
                        }
                    }
                }
            }
        }
    }


    component InfoCard: Rectangle {

        property string title
        property string text
        property string icon


        Layout.fillWidth: true

        radius: 16

        color: "white"

        border.color: "#dddddd"

        implicitHeight: column.implicitHeight + 32


        ColumnLayout {
            id: column

            anchors.fill: parent
            anchors.margins: 16

            spacing: 10


            RowLayout {

                Label {
                    text: icon

                    font.family: "Material Design Icons"
                    font.pixelSize: 26
                }


                Label {
                    text: title

                    font.bold: true
                    font.pixelSize: 20
                }
            }


            Label {

                Layout.fillWidth: true

                wrapMode: Text.WordWrap

                color: "#444444"

                text: parent.parent.text
            }
        }
    }
}