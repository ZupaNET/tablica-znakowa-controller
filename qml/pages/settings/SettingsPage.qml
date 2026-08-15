// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import Prezenter

Item {
    id: root

    Rectangle {
        anchors.fill: parent
        color: Theme.background
    }

    PageHeader {
        id: topBar

        title: qsTr("Ustawienia")
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
                color: Theme.card
                border.color: Theme.cardBorder

                implicitHeight: boardColumn.implicitHeight + 32

                ColumnLayout {
                    id: boardColumn

                    anchors.fill: parent
                    anchors.margins: 16

                    spacing: 18

                    RowLayout {
                        spacing: 10

                        Label {
                            text: Icon.ledOn

                            font.family: "Material Design Icons"
                            font.pixelSize: 28
                        }

                        Label {
                            text: qsTr("Tablica")

                            font.bold: true
                            font.pixelSize: 25

                            color: Theme.text
                        }
                    }

                    RowLayout {

                        Layout.fillWidth: true

                        ColumnLayout {
                            Layout.fillWidth: true

                            Label {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                text: qsTr("Tryb pojedynczej sesji")

                                color: Theme.text

                                font.bold: true
                            }

                            Label {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                text: qsTr("Każdy slajd jest wysyłany do tablicy w ramach jednej sesji zamiast wielu sesji.")

                                color: Theme.textSecondary

                                font.pixelSize: 12
                                font.bold: true
                            }
                        }

                        Switch {

                            checked: AppSettings.singleConnection

                            onToggled: {
                                AppSettings.singleConnection = checked
                            }
                        }
                    }

                    Label {
                        text: qsTr("Adres IP")
                        font.bold: true

                        color: Theme.text
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

                        color: Theme.text
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

                    Label {
                        text: qsTr("Jasność")
                        font.bold: true

                        color: Theme.text
                    }

                    RowLayout {

                        Label {
                            text: Icon.weatherNight

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
                            text: Icon.whiteBalanceSunny

                            font.family: "Material Design Icons"
                            font.pixelSize: 20
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                radius: 16
                color: Theme.card
                border.color: Theme.cardBorder

                implicitHeight: appColumn.implicitHeight + 32

                ColumnLayout {
                    id: appColumn

                    anchors.fill: parent
                    anchors.margins: 16

                    spacing: 18

                    RowLayout {
                        spacing: 10

                        Label {
                            text: Icon.cog

                            font.family: "Material Design Icons"
                            font.pixelSize: 28
                        }

                        Label {
                            text: qsTr("Aplikacja")

                            font.bold: true
                            font.pixelSize: 25

                            color: Theme.text
                        }
                    }

                    RowLayout {

                        Layout.fillWidth: true

                        Label {
                            Layout.fillWidth: true

                            text: qsTr("Tryb ciemny")

                            color: Theme.text

                            font.bold: true
                        }

                        Switch {

                            checked: AppSettings.darkMode

                            onToggled: {
                                AppSettings.darkMode = checked
                            }
                        }
                    }

                    RowLayout {

                        Layout.fillWidth: true

                        Label {
                            Layout.fillWidth: true

                            text: qsTr("Język")

                            color: Theme.text

                            font.bold: true
                        }

                        ComboBox {
                            id: languageBox

                            Layout.preferredWidth: 200

                            model: LanguageManager.availableLanguages

                            textRole: "name"
                            valueRole: "lang"

                            Component.onCompleted: {
                                currentIndex = indexOfValue(LanguageManager.language)
                            }

                            onActivated: {
                                LanguageManager.language = currentValue
                            }

                            Connections {
                                target: LanguageManager

                                function onLanguageChanged() {
                                    languageBox.currentIndex = languageBox.indexOfValue(LanguageManager.language)
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {

                Layout.fillWidth: true

                radius: 16

                color: Theme.card
                border.color: Theme.cardBorder

                implicitHeight: databaseColumn.implicitHeight + 32

                ColumnLayout {
                    id: databaseColumn

                    anchors.fill: parent
                    anchors.margins: 16

                    spacing: 18

                    RowLayout {
                        spacing: 10

                        Label {
                            text: Icon.bookCross

                            font.family: "Material Design Icons"
                            font.pixelSize: 28
                        }

                        Label {
                            text: qsTr("Śpiewnik")

                            font.bold: true
                            font.pixelSize: 25

                            color: Theme.text
                        }
                    }

                    SettingsAction {
                        icon: Icon.databaseImport
                        title: qsTr("Importuj śpiewnik")
                        description: qsTr("Wczytaj śpiewnik z pliku. Zastępuje poprzedni śpiewnik")

                        onClicked: dbImportDialog.open()
                    }

                    SettingsAction {
                        icon: Icon.databaseExport
                        title: qsTr("Eksportuj śpiewnik")
                        description: qsTr("Zapisz śpiewnik do pliku")

                        onClicked: dbExportDialog.open()
                    }

                    SettingsAction {
                        icon: Icon.databaseRefresh
                        title: qsTr("Zresetuj śpiewnik")
                        description: qsTr("Usuń własne dane i przywróć domyślny śpiewnik")

                        destructive: true

                        onClicked: dbResetDialog.open()
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1

                        color: Theme.divider
                    }

                    SettingsAction {
                        icon: Icon.sortAlphabeticalAscending
                        title: qsTr("Posortuj kategorie")
                        description: qsTr("Zresetuj ustaloną kolejność kategorii i ustaw je alfabetycznie")

                        onClicked: dbCategoryReorderDialog.open()
                    }

                    SettingsAction {
                        icon: Icon.sortAlphabeticalAscending
                        title: qsTr("Posortuj zestawy")
                        description: qsTr("Zresetuj ustaloną kolejność zestawów i ustaw je alfabetycznie")

                        onClicked: dbSetReorderDialog.open()
                    }
                }
            }
        }
    }

    ConfirmDialog {
        id: dbCategoryReorderDialog

        title: qsTr("Posortować kategorie?")
        message: qsTr("Czy na pewno chcesz posortować kategorie alfabetycznie?")

        onAccepted: {
            DatabaseCleanupService.reorderCategoriesByName()
            infoPopup.show(qsTr("Posortowano kategorie alfabetycznie"))
        }
    }

    ConfirmDialog {
        id: dbSetReorderDialog

        title: qsTr("Posortować zestawy?")
        message: qsTr("Czy na pewno chcesz posortować zestawy alfabetycznie?")

        onAccepted: {
            DatabaseCleanupService.reorderSetsByName()
            infoPopup.show(qsTr("Posortowano zestawy alfabetycznie"))
        }
    }

    ConfirmDialog {
        id: dbResetDialog

        title: qsTr("Zresetować śpiewnik?")
        message: qsTr("Czy na pewno chcesz zresetować śpiewnik?")

        onAccepted: {
            if(!DatabaseBackupService.resetDatabase())
                infoPopup.show(qsTr("Wystąpił problem podczas resetowania śpiewnika"))
            else
                infoPopup.show(qsTr("Zresetowano śpiewnik"))
        }
    }

    FileDialog {
        id: dbImportDialog
        title: qsTr("Import śpiewnika")
        nameFilters: [qsTr("Śpiewnik (*.db)")]

        onAccepted: {
            if(!DatabaseBackupService.importDatabase(selectedFiles[0]))
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
            if(!DatabaseBackupService.exportDatabase(selectedFile))
                infoPopup.show(qsTr("Wystąpił problem podczas zapisywania śpiewnika"))
            else
                infoPopup.show(qsTr("Zapisano śpiewnik"))
        }
    }

    QuickPopup {
        id: infoPopup
    }
}