import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Prezenter
import "../Icon.js" as MdiFont

Item {
    id: root

    property int startYear: 2026


    function copyrightText() {
        let year = new Date().getFullYear()

        return year <= startYear
            ? startYear
            : startYear + "-" + year
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

                icon: MdiFont.Icon.book

                title: qsTr("Lista pieśni")

                description: qsTr("Zarządzanie śpiewnikiem")

                onClicked:
                    Navigation.push(Qt.resolvedUrl("HymnListPage.qml"))
            }


            MenuTile {

                Layout.minimumWidth: 120
                Layout.minimumHeight: 80
                Layout.maximumHeight: 150
                Layout.fillWidth: true
                Layout.fillHeight: true

                icon: MdiFont.Icon.viewDashboard

                title: qsTr("Zestawy")

                description: qsTr("Wyświetlanie slajdów")

                onClicked:
                    Navigation.push(Qt.resolvedUrl("SetListPage.qml"))
            }


            MenuTile {

                Layout.minimumWidth: 120
                Layout.minimumHeight: 80
                Layout.maximumHeight: 150
                Layout.fillWidth: true
                Layout.fillHeight: true

                icon: MdiFont.Icon.textBox

                title: qsTr("Dowolny slajd")

                description: qsTr("Ręczne wyświetlanie")

                onClicked:
                    Navigation.push(Qt.resolvedUrl("QuickScreenPage.qml"))
            }


            MenuTile {

                Layout.minimumWidth: 120
                Layout.minimumHeight: 80
                Layout.maximumHeight: 150
                Layout.fillWidth: true
                Layout.fillHeight: true

                icon: MdiFont.Icon.cog

                title: qsTr("Ustawienia")

                description: qsTr("Konfiguracja systemu")

                onClicked:
                    Navigation.push(Qt.resolvedUrl("SettingsPage.qml"))
            }

            MenuTile {

                Layout.minimumWidth: 120
                Layout.minimumHeight: 80
                Layout.maximumHeight: 150
                Layout.fillWidth: true
                Layout.fillHeight: true

                icon: MdiFont.Icon.information

                title: qsTr("O aplikacji")

                description: qsTr("Informacje i licencje")

                onClicked:
                    Navigation.push(Qt.resolvedUrl("AboutPage.qml"))
            }


            MenuTile {

                Layout.minimumWidth: 120
                Layout.minimumHeight: 80
                Layout.maximumHeight: 150
                Layout.fillWidth: true
                Layout.fillHeight: true

                icon: MdiFont.Icon.power

                title: qsTr("Wyłącz tablicę")

                description: qsTr("Zakończ pracę urządzenia")

                danger: true

                onClicked:
                    shutdownDialog.open()
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

                text:
                    "Copyright © " +
                    root.copyrightText() +
                    " " +
                    AppInfo.company

                color: Theme.textSecondary

                font.pixelSize: 14
            }
        }
    }



    Dialog {

        id: shutdownDialog

        title: qsTr("Wyłączyć tablicę?")

        modal: true

		Overlay.modal: Rectangle {
			color: Theme.dimBackground
		}

        parent: Overlay.overlay
		anchors.centerIn: Overlay.overlay

        standardButtons:
            Dialog.Yes | Dialog.No


        Label {

            text:
                qsTr("Czy na pewno chcesz wyłączyć tablicę?")

            padding: 20
        }


        onAccepted: {
            TablicaConnector.shutdown()
        }
    }

    Connections {
        target: TablicaConnector

        function onConnectionFailure() {
            if(root.focus)
                infoPopup.show(qsTr("Nie można połączyć się z tablicą"))
        }
    }



    Popup {

        id: infoPopup
		
		parent: Overlay.overlay

        x: (parent.width - width) / 2
        y: parent.height - height - 40


        padding: 14


        background: Rectangle {

            radius: 10

            color: Theme.popup
        }


        Label {

            id: infoText

            color: "white"
        }


        Timer {

            id: hideTimer

            interval: 2500

            onTriggered:
                infoPopup.close()
        }


        function show(text) {

            infoText.text = text

            open()

            hideTimer.restart()
        }
    }
}