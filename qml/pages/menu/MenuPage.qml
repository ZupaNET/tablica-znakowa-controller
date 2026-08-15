// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Prezenter

Item {
    id: root

    property int startYear: 2026

    function copyrightText() {
        let year = new Date().getFullYear()

        return year <= startYear ? startYear : startYear + "-" + year
    }

    Rectangle {
        anchors.fill: parent

        color: Theme.background

        Rectangle {
            id: header

            height: 120

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            color: Theme.header

            Column {
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: 40
                }

                spacing: 5

                Text {
                    text: AppInfo.name
                    color: "white"

                    font.pixelSize: 38
                    font.bold: true
                }

                Text {
                    text: qsTr("Kontroler")
                    color: Theme.headerSecondaryText

                    font.pixelSize: 17
                }
            }
        }

        GridLayout {
            id: menuGrid

            anchors {
                top: header.bottom
                bottom: footer.top
                horizontalCenter: parent.horizontalCenter

                topMargin: 40
                bottomMargin: 30
            }

            width: Math.min(900, parent.width - 40)

            columns: 3
            columnSpacing: 25
            rowSpacing: 25

            MenuTile {
                Layout.minimumWidth: 120
                Layout.minimumHeight: 80
                Layout.maximumHeight: 150
                Layout.fillWidth: true
                Layout.fillHeight: true

                icon: Icon.book
                title: qsTr("Lista pieśni")
                description: qsTr("Zarządzanie śpiewnikiem")

                onClicked: Navigation.push(Qt.resolvedUrl("../hymns/HymnListPage.qml"))
            }

            MenuTile {
                Layout.minimumWidth: 120
                Layout.minimumHeight: 80
                Layout.maximumHeight: 150
                Layout.fillWidth: true
                Layout.fillHeight: true

                icon: Icon.viewDashboard
                title: qsTr("Zestawy")
                description: qsTr("Wyświetlanie slajdów")

                onClicked: Navigation.push(Qt.resolvedUrl("../sets/SetListPage.qml"))
            }

            MenuTile {
                Layout.minimumWidth: 120
                Layout.minimumHeight: 80
                Layout.maximumHeight: 150
                Layout.fillWidth: true
                Layout.fillHeight: true

                icon: Icon.textBox
                title: qsTr("Dowolny slajd")
                description: qsTr("Ręczne wyświetlanie")

                onClicked: Navigation.push(Qt.resolvedUrl("../presentation/QuickScreenPage.qml"))
            }

            MenuTile {
                Layout.minimumWidth: 120
                Layout.minimumHeight: 80
                Layout.maximumHeight: 150
                Layout.fillWidth: true
                Layout.fillHeight: true

                icon: Icon.cog
                title: qsTr("Ustawienia")
                description: qsTr("Konfiguracja systemu")

                onClicked: Navigation.push(Qt.resolvedUrl("../settings/SettingsPage.qml"))
            }

            MenuTile {
                Layout.minimumWidth: 120
                Layout.minimumHeight: 80
                Layout.maximumHeight: 150
                Layout.fillWidth: true
                Layout.fillHeight: true

                icon: Icon.information
                title: qsTr("O aplikacji")
                description: qsTr("Informacje i licencje")

                onClicked: Navigation.push(Qt.resolvedUrl("../about/AboutPage.qml"))
            }

            MenuTile {
                Layout.minimumWidth: 120
                Layout.minimumHeight: 80
                Layout.maximumHeight: 150
                Layout.fillWidth: true
                Layout.fillHeight: true

                icon: Icon.power
                title: qsTr("Wyłącz tablicę")
                description: qsTr("Zakończ pracę urządzenia")

                danger: true

                onClicked: shutdownDialog.open()
            }
        }

        Rectangle {
            id: footer

            height: 45

            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }

            color: Theme.footer

            Text {
                anchors.centerIn: parent

                text: "Copyright © " + root.copyrightText() + " " + AppInfo.company

                color: Theme.textSecondary
                font.pixelSize: 14
            }
        }
    }

    ConfirmDialog {
        id: shutdownDialog

        title: qsTr("Wyłączyć tablicę?")
        message: qsTr("Czy na pewno chcesz wyłączyć tablicę?")

        onAccepted: BoardController.powerOff()
    }

    Connections {
        target: BoardController

        function onTransmissionFailed(error) {
            if (root.focus)
                infoPopup.show(qsTr("Nie można połączyć się z tablicą:") + " " + error)
        }
    }

    QuickPopup {
        id: infoPopup
    }
}