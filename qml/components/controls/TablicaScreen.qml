// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

import QtQuick
import QtQuick.Controls
import Prezenter

Item {
    id: root

    anchors.fill: parent

    readonly property real aspectRatio: 3/2
    readonly property real tablicaWidth: 192
    readonly property real tablicaHeight: 128

    readonly property string tablicaFontFamily: {
        switch(root.hymnFont){
        case 0: return "MiniSet2"
        case 1: return "MiniForma2"
        case 2: return "FreeSans"
        }
        return "MiniSet2"
    }

    readonly property real tablicaFontSize:
    {
        switch(root.hymnFont){
        case 0: return 8.0
        case 1: return 8.0
        case 2: return 11.7 // FreeSans is not necessary fully metric-correct with MSSans, should be 12
        }
        return 8.0
    }

    readonly property real tablicaLineHeight:
    {
        switch(root.hymnFont){
        case 0: return 9.0
        case 1: return 11.0
        case 2: return 14.0
        }
        return 9.0
    }

    property alias content: screenText.text
    property int hymnFont: 0    
    property real textPadding: 8
    property bool editable: false

    signal contentTextChanged(string content)

    property int charsPerLine: {
        switch(root.hymnFont) {
        case 0: return 32
        case 1: return 32
        case 2: return 21
        }
        return 21
    }

    TextMetrics {
        id: limitMetrics

        font: screenText.font
        text: "O".repeat(root.charsPerLine)
    }

    state: AppSettings.screenView
    states: [
        State {
            name: "screenView"

            PropertyChanges {
                target: screen
                color: "#000000"
            }

            PropertyChanges {
                target: screenText

                font.family: root.tablicaFontFamily
                font.bold: false
                font.pixelSize: root.tablicaFontSize * screen.scale
                lineHeight: root.tablicaLineHeight * screen.scale

                color: "#FF0000"
            }

            PropertyChanges {
                target: limitLine
                color: "#404040"
            }
        },

        State {
            name: "textView"

            PropertyChanges {
                target: screen
                color: "#000000"
            }

            PropertyChanges {
                target: screenText

                font.family: "Arimo"
                font.bold: true
                font.pixelSize: root.tablicaFontSize * screen.scale

                color: "#FFFFFF"
            }

            PropertyChanges {
                target: limitLine
                color: "#404040"
            }
        },

        State {
            name: "textViewRev"

            PropertyChanges {
                target: screen
                color: "#FFFFFF"
            }

            PropertyChanges {
                target: screenText

                font.family: "Arimo"
                font.bold: true
                font.pixelSize: root.tablicaFontSize * screen.scale

                color: "#000000"
            }

            PropertyChanges {
                target: limitLine
                color: "#404040"
            }
        }
    ]

    Rectangle {
        id: screen
        anchors.centerIn: parent

        readonly property real scale: Math.min((screenText.height / root.tablicaHeight), (screenText.width / root.tablicaWidth))

        width: Math.min( parent.width, parent.height * root.aspectRatio )
        height: width / root.aspectRatio

        border.color: "#474747"
        border.width: 2
        radius: 10

        clip: true

        Item {
            id: textAreaContainer
            anchors.fill: parent
            anchors.margins: root.textPadding

            clip: true

            EnhancedTextArea {
                id: screenText

                anchors.fill: parent

                leftPadding: 0
                rightPadding: 0
                topPadding: 0
                bottomPadding: 0

                background: null

                wrapMode: TextEdit.NoWrap

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignTop

                lineHeightMode: LineHeightHelper.FixedHeight

                readOnly: !root.editable
                enabled: root.editable
                opacity: 1.0
                palette.disabled.text: color

                focusPolicy: Qt.NoFocus

                onTextChanged: {
                    root.contentTextChanged(text)
                }
            }
        }

        Rectangle {
            id: limitLine

            width: 1
            height: screenText.height

            x: screenText.x + limitMetrics.width
            y: 0

            visible: root.editable

            opacity: 0.5
        }
    }
}