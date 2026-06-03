import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import QtQuick.Layouts 2.15

import TablicaZnakowa

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
                    text: TablicaConnector.ipAddress
                    width: 200
                    activeFocusOnPress: true
                    focusPolicy: Qt.StrongFocus

                    validator: RegularExpressionValidator {
                        regularExpression:
                            /^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}$/
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
                    TablicaConnector.ipAddress = ipField.text
                }
                focus = false
                Qt.inputMethod.hide()
            }
            onTextChanged: {
                standardButton(Dialog.Ok).enabled = ipField.acceptableInput
                ipChangeDialogError.visible = !ipField.acceptableInput
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
                    text: TablicaConnector.port
                    width: 200
                    activeFocusOnPress: true
                    focusPolicy: Qt.StrongFocus

                    inputMethodHints: Qt.ImhDigitsOnly

                    validator: IntValidator {
                        bottom: 1
                        top: 65535
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
                    TablicaConnector.port = portField.text
                }
                focus = false
                Qt.inputMethod.hide()
            }
            onTextChanged: {
                standardButton(Dialog.Ok).enabled = portField.acceptableInput
                portChangeDialogError.visible = !portField.acceptableInput
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
            }
        }
    }
}
