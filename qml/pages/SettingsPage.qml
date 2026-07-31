import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import QtQuick.Layouts 2.15

import Prezenter

Item {
    Rectangle{
        anchors.fill: parent
        color: "#FFFFFF"

        FileDialog{
            id: dbImportDialog
            title: "Wybierz plik śpiewnika"

            nameFilters: ["SQLite database (*.db)"]

            onAccepted: {
                DatabaseImporter.importDatabase(selectedFiles[0])
            }
        }

        FileDialog {
            id: dbExportDialog

            title: "Zapisz kopię śpiewnika"

            fileMode: FileDialog.SaveFile

            nameFilters: [
                "SQLite database (*.db)"
            ]

            defaultSuffix: "db"

            onAccepted: {
                DatabaseManager.exportDatabase(selectedFile)
            }
        }

        Dialog {
            id: ipChangeDialog

            x: (parent.width - width) / 2
            y: Qt.inputMethod.visible ? parent.height * 0.05 : (parent.height-height)/2

            Behavior on y {

                NumberAnimation {
                    duration: 200
                }
            }

            title: "Zmień adres IP tablicy"
            modal: true
            focus: true

            standardButtons: Dialog.Ok | Dialog.Cancel

            property alias text: ipField.text

            Column{
                spacing: 6

                TextField {
                    id: ipField
                    text: AppSettings.ipAddress
                    width: 200
                    activeFocusOnPress: true
                    focusPolicy: Qt.StrongFocus

                    validator: RegularExpressionValidator {
                        regularExpression:
                            /^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}$/
                    }
                    onTextEdited: {
                        ipChangeDialog.standardButton(Dialog.Ok).enabled = ipField.acceptableInput
                        ipChangeDialogError.visible = !ipField.acceptableInput
                    }
                }

                Label{
                    text: "Adres IP jest niepoprawny"
                    id: ipChangeDialogError
                    color: "#FF0000"
                    visible: false
                }
            }

            onAccepted: {
                if(ipField.acceptableInput)
                {
                    AppSettings.ipAddress = ipField.text
                }
                focus = false
                Qt.inputMethod.hide()
            }
        }

        Dialog {
            id: portChangeDialog

            x: (parent.width - width) / 2
            y: Qt.inputMethod.visible ? parent.height * 0.05 : (parent.height-height)/2

            Behavior on y {

                NumberAnimation {
                    duration: 200
                }
            }

            title: "Zmień port tablicy"
            modal: true
            focus: true

            standardButtons: Dialog.Ok | Dialog.Cancel

            property alias text: portField.text

            Column{
                spacing: 6

                TextField {
                    id: portField
                    text: AppSettings.port
                    width: 200
                    activeFocusOnPress: true
                    focusPolicy: Qt.StrongFocus

                    inputMethodHints: Qt.ImhDigitsOnly

                    validator: IntValidator {
                        bottom: 1
                        top: 65535
                    }

                    onTextEdited: {
                        portChangeDialog.standardButton(Dialog.Ok).enabled = portField.acceptableInput
                        portChangeDialogError.visible = !portField.acceptableInput
                    }
                }

                Label{
                    text: "Port jest niepoprawny."
                    id: portChangeDialogError
                    color: "#FF0000"
                    visible: false
                }
            }

            onAccepted: {
                if(portField.acceptableInput)
                {
                    AppSettings.port = parseInt(portField.text)
                }
                focus = false
                Qt.inputMethod.hide()
            }
        }
        Dialog {
            id: brightnessChangeDialog

            x: (parent.width - width) / 2
            y: Qt.inputMethod.visible ? parent.height * 0.05 : (parent.height-height)/2

            Behavior on y {

                NumberAnimation {
                    duration: 200
                }
            }

            title: "Zmień jasność tablicy"
            modal: true
            focus: true

            standardButtons: Dialog.Ok | Dialog.Cancel

            property alias text: portField.text

            Column{
                spacing: 6

                ComboBox {
                    id: brightnessField
                    currentValue: AppSettings.brightness
                    width: 200
                    //activeFocusOnPress: true
                    focusPolicy: Qt.StrongFocus

                    inputMethodHints: Qt.ImhDigitsOnly

                    model: [1, 2, 3, 4]
                }
            }

            onAccepted: {
                AppSettings.brightness = brightnessField.currentText
                focus = false
                Qt.inputMethod.hide()
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
            id: mainView
            anchors {
                top: topBar.bottom
                right: parent.right
                bottom: parent.bottom
                left: parent.left
            }
            ColumnLayout{
                anchors.fill: parent.fill
                spacing: 6
                Button{
                    text: "Importuj bazę danych"
                    onClicked: {
                        dbImportDialog.open()
                    }
                }
                Button{
                    text: "Eksportuj bazę danych"
                    onClicked: {
                        dbExportDialog.open()
                    }
                }
                Button{
                    text: "Ustaw adres IP tablicy"
                    onClicked: {
                        ipChangeDialog.open()
                    }
                }
                Button{
                    text: "Ustaw port tablicy"
                    onClicked: {
                        portChangeDialog.open()
                    }
                }
                Button{
                    text: "Ustaw jasność"
                    onClicked: {
                        brightnessChangeDialog.open()
                    }
                }
            }
        }
    }
}
