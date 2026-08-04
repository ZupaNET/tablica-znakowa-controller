import QtQuick
import QtQuick.Controls
import Prezenter

Item {
    id: root

    anchors.fill: parent

    property alias content: screenText.text
    property int hymnFont: 0

    property real outerMargin: 20
    property real textPadding: 8
    property real aspectRatio: 3 / 2

    property bool editable: false

    signal contentTextChanged(string content)

    FontMetricsUtility
    {
        id: fontUtility
    }

    state: AppSettings.screenView
    states: [
        State {
            name: "screenView"

            PropertyChanges {
                target: screen
                color: "#111111"
            }

            PropertyChanges {
                target: screenText

                font.family: screen.screenFont
                font.bold: false
                font.pixelSize: fontUtility.pixelSizeForHeight(screen.textHeight, root.hymnFont, 0)

                color: "#FF0000"
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
                font.pixelSize: fontUtility.pixelSizeForHeight(screen.textHeight, root.hymnFont, 1)

                color: "#FFFFFF"
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
                font.pixelSize: fontUtility.pixelSizeForHeight(screen.textHeight, root.hymnFont, 1)

                color: "#000000"
            }
        }
    ]

    Rectangle {
        id: screen
        anchors.centerIn: parent

        property string screenFont: {
            switch(root.hymnFont){
            case 0: return "MiniSet2"
            case 1: return "MiniForma2"
            case 2: return "FreeSans"
            }
            return "MiniSet2"
        }

        property real availableWidth: parent.width - 2 * root.outerMargin
        property real availableHeight: parent.height - 2 * root.outerMargin

        width: Math.min(availableWidth, availableHeight * root.aspectRatio)
        height: width / root.aspectRatio

        property real textWidth: width - 2 * root.textPadding
        property real textHeight: height - 2 * root.textPadding

        border.color: "#474747"
        border.width: 2
        radius: 10

        clip: true

        TextArea {
            id: screenText

            anchors.fill: parent

            enabled: root.editable
            opacity: 1.0
            palette.disabled.text: color

            focusPolicy: Qt.NoFocus

            leftPadding: root.textPadding
            rightPadding: root.textPadding
            topPadding: root.textPadding
            bottomPadding: root.textPadding

            readOnly: !root.editable
            wrapMode: TextEdit.NoWrap

            horizontalAlignment: Text.AlignLeft

            verticalAlignment: Text.AlignTop

            background: null

            onTextChanged: {
                root.contentTextChanged(text)
            }
        }
    }
}