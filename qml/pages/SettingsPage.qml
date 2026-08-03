import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import Prezenter
import "../Icon.js" as MdiFont

Item {
    id: root

    Rectangle {
        anchors.fill: parent
        color: "#f3f5f7"

        FileDialog {
            id: dbImportDialog
            title: qsTr("Import śpiewnika")
            nameFilters: [qsTr("Śpiewnik (*.db)")]

            onAccepted: {
                if(!DatabaseManager.importDatabase(selectedFiles[0]))
                    infoPopup.show(qsTr("Wystąpił problem podczas wczytywania śpiewnika"))
                else
                    infoPopup.show(qsTr("Wczytano śpiewnik"))
            }
        }

        FileDialog {
            id: dbExportDialog

            title: qsTr("Eksport śpiewnika")

            fileMode: FileDialog.SaveFile
            defaultSuffix: "db"

            nameFilters: [qsTr("Śpiewnik (*.db)")]

            onAccepted: {
                if(!DatabaseManager.exportDatabase(selectedFile))
                    infoPopup.show(qsTr("Wystąpił problem podczas zapisywania śpiewnika"))
                else
                    infoPopup.show(qsTr("Zapisano śpiewnik"))
            }
        }

        Dialog {
            id: dbResetDialog

            title: qsTr("Zresetować śpiewnik?")
            modal: true

            parent: Overlay.overlay
            anchors.centerIn: Overlay.overlay
            dim: true

            standardButtons: Dialog.Yes | Dialog.No

            Label {
                text: qsTr("Czy na pewno chcesz zresetować śpiewnik?")
            }

            onAccepted: {
                if(!DatabaseManager.resetDatabase())
                    infoPopup.show(qsTr("Wystąpił problem podczas resetowania śpiewnika"))
                else
                    infoPopup.show(qsTr("Zresetowano śpiewnik"))
            }
        }

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

                onClicked: {
                    Navigation.pop()
                }
            }

            Text {
                anchors.centerIn: parent

                text: qsTr("Ustawienia")

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

            contentWidth: width
            contentHeight: layout.implicitHeight

            clip: true

            ColumnLayout {
                id: layout

                width: parent.width

                spacing: 20

                Rectangle {
                    Layout.fillWidth: true
                    radius: 16
                    color: "white"
                    border.color: "#dddddd"

                    implicitHeight: connectionColumn.implicitHeight + 32

                    ColumnLayout {
                        id: connectionColumn

                        anchors.fill: parent
                        anchors.margins: 16

                        spacing: 18

                        RowLayout {
                            spacing: 10

                            Label {
                                text: MdiFont.Icon.lan

                                font.family: "Material Design Icons"
                                font.pixelSize: 28
                            }

                            Label {
                                text: qsTr("Łączność")

                                font.bold: true
                                font.pixelSize: 20
                            }
                        }

                        Label {
                            text: qsTr("Adres IP")
                            font.bold: true
                        }

                        ColumnLayout {
                            Layout.fillWidth: true

                            spacing: 6

                            TextField {
                                id: ipField

                                Layout.fillWidth: true

                                text: AppSettings.ipAddress

                                placeholderText: qsTr("np. 192.168.1.100")

                                inputMethodHints: Qt.ImhFormattedNumbersOnly

                                validator: RegularExpressionValidator {
                                    regularExpression:
                                        /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
                                }

                                onEditingFinished: {
                                    if (acceptableInput) {
                                        AppSettings.ipAddress = text
                                    }
                                }

                                onTextEdited: {
                                    ipError.visible = !acceptableInput && text.length > 0
                                }
                            }

                            Label {
                                id: ipError

                                Layout.fillWidth: true

                                text: qsTr("Niepoprawny adres IP")

                                color: "#e53935"

                                font.pixelSize: 13

                                visible: false
                            }
                        }

                        Label {
                            text: qsTr("Port")
                            font.bold: true
                        }

                        ColumnLayout {
                            Layout.fillWidth: true

                            spacing: 6

                            TextField {
                                id: portField

                                Layout.fillWidth: true

                                text: AppSettings.port

                                placeholderText: qsTr("np. 60023")

                                inputMethodHints: Qt.ImhDigitsOnly

                                validator: IntValidator {
                                    bottom: 1
                                    top: 65535
                                }

                                onEditingFinished: {
                                    if (acceptableInput) {
                                        AppSettings.port = parseInt(text)
                                    }
                                }

                                onTextEdited: {
                                    portError.visible = !acceptableInput && text.length > 0
                                }
                            }

                            Label {
                                id: portError

                                Layout.fillWidth: true

                                text: qsTr("Port musi być w zakresie 1-65535")

                                color: "#e53935"

                                font.pixelSize: 13

                                visible: false
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true

                    radius: 16

                    color: "white"

                    border.color: "#dddddd"

                    implicitHeight: displayColumn.implicitHeight + 32

                    ColumnLayout {
                        id: displayColumn

                        anchors.fill: parent
                        anchors.margins: 16

                        spacing: 18

                        RowLayout {
                            spacing: 10

                            Label {
                                text: MdiFont.Icon["brightness-6"]

                                font.family: "Material Design Icons"
                                font.pixelSize: 28
                            }

                            Label {
                                text: qsTr("Wyświetlacz")

                                font.bold: true
                                font.pixelSize: 20
                            }
                        }

                        RowLayout {

                            Label {
                                text: MdiFont.Icon.weatherNight

                                font.family: "Material Design Icons"
                                font.pixelSize: 20
                            }

                            Slider {

                                Layout.fillWidth: true

                                from: 1
                                to: 4

                                stepSize: 1

                                snapMode: Slider.SnapAlways

                                value: AppSettings.brightness

                                onMoved:
                                    AppSettings.brightness = value
                            }

                            Label {
                                text: MdiFont.Icon.whiteBalanceSunny

                                font.family: "Material Design Icons"
                                font.pixelSize: 20
                            }
                        }

                        Label {
                            text: qsTr("Poziom:") + " " + AppSettings.brightness + " / 4"
                            color: "#666666"
                        }
                    }
                }

                Rectangle {

                    Layout.fillWidth: true

                    radius: 16

                    color: "white"

                    border.color: "#dddddd"

                    implicitHeight: databaseColumn.implicitHeight + 32

                    ColumnLayout {
                        id: databaseColumn

                        anchors.fill: parent
                        anchors.margins: 16

                        spacing: 18

                        RowLayout {
                            spacing: 10

                            Label {
                                text: MdiFont.Icon.book

                                font.family: "Material Design Icons"
                                font.pixelSize: 28
                            }

                            Label {
                                text: qsTr("Śpiewnik")

                                font.bold: true
                                font.pixelSize: 20
                            }
                        }

                        RowLayout {

                            Layout.fillWidth: true

                            spacing: 16

                            Button {

                                Layout.fillWidth: true
                                Layout.preferredHeight: 64

                                text: qsTr("Import")
                                font.pixelSize: 15

                                onClicked: dbImportDialog.open()
                            }

                            Button {

                                Layout.fillWidth: true
                                Layout.preferredHeight: 64

                                text: qsTr("Eksport")
                                font.pixelSize: 15

                                onClicked: dbExportDialog.open()
                            }

                            Button {

                                Layout.fillWidth: true
                                Layout.preferredHeight: 64

                                text: qsTr("Resetuj")
                                font.pixelSize: 15

                                onClicked: dbResetDialog.open()
                            }
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: infoPopup

        x: (parent.width - width) / 2
        y: parent.height - height - 20

        padding: 12
        modal: false
        focus: false
        closePolicy: Popup.NoAutoClose

        background: Rectangle {
            radius: 6
            color: "#323232"
        }

        Label {
            id: infoText
            color: "white"
        }

        Timer {
            id: hideTimer
            interval: 2500
            onTriggered: infoPopup.close()
        }

        function show(message) {
            infoText.text = message
            open()
            hideTimer.restart()
        }
    }
}