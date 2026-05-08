import QtQuick 2.15
import TablicaZnakowa

Item {
    id: root
    anchors.fill: parent

    property string content
    property int hymnFont

    signal clicked

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
                font.family: fontMiniForma2.font.family
                font.pixelSize: Math.min(
                    screen.width / screen.columns*1.15,
                    screen.height / screen.rows*1.15
                )
                font.bold: false
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
                font.family: fontArialBold.font.family
                font.pixelSize: Math.min(
                    screen.width / screen.columns*1.4,
                    screen.height / screen.rows*1.4
                )
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
                font.family: fontArialBold.font.family
                font.pixelSize: Math.min(
                    screen.width / screen.columns*1.4,
                    screen.height / screen.rows*1.4
                )
                color: "#000000"
            }
        }
    ]

    Rectangle {
        id: screen
        anchors.centerIn: parent
        property int columns: 24
        property int rows: 16
        property int margins: 20
        width: Math.min(
                parent.width - 2 * margins,
                (parent.height - 2 * margins) * columns / rows
        )
        height: width * rows / columns

        border.color: "#474747"
        border.width: 2
        radius: 10
        clip: true

        FontLoader{
            id: fontMiniForma2
            source: "resources/fonts/MiniForma2.ttf"
        }
        FontLoader{
            id: fontArialBold
            source: "resources/fonts/ARIALBD.TTF"
        }

        Text {
            id: screenText
            anchors.fill: parent
            anchors.margins: 10
            text: content
            color: "#FF0000"
            //wrapMode: Text.Wrap
            font.family: fontMiniForma2.font.family
            font.pixelSize: Math.min(
                screen.width / screen.columns,
                screen.height / screen.rows
            )
        }
    }

}