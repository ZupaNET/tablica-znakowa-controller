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
                font.family: screen.screenFont
                font.pixelSize: (screen.height / screen.rows) * screen.fontScaleFactor
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
                font.pixelSize: (screen.height / screen.rows) * screen.fontScaleFactorArial
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
                font.pixelSize: (screen.height / screen.rows) * screen.fontScaleFactorArial
                color: "#000000"
            }
        }
    ]

    Rectangle {
        id: screen
        anchors.centerIn: parent
        property real fontScaleFactor: {
            switch(root.hymnFont){
                case 0: return 0.65
                case 1: return 0.60
                case 2: return 0.81
            }
        }

        property real fontScaleFactorArial: {
            switch(root.hymnFont){
                case 0: return 0.75
                case 1: return 0.70
                case 2: return 0.81
            }
        }

        property int rows: {
            switch(root.hymnFont){
                case 0: return 12
                case 1: return 10
                case 2: return 9
            }
        }
        property int columns: Math.ceil(rows*1.5)

        property int margins: 20
        property string screenFont: {
            switch(root.hymnFont){
                case 0: return fontMiniSet2.font.family
                case 1: return fontMiniForma2.font.family
                case 2: return fontMicrosoftSansSerif.font.family
            }
        }

        width: Math.min(
                parent.width - 2 * margins,
                (parent.height - 2 * margins) * 1.5
        )
        height: width /1.5

        border.color: "#474747"
        border.width: 2
        radius: 10
        clip: true

        FontLoader{
            id: fontMiniSet2
            source: "../resources/fonts/MiniSet2.ttf"
        }
        FontLoader{
            id: fontMiniForma2
            source: "../resources/fonts/MiniForma2.ttf"
        }
        FontLoader{
            id: fontMicrosoftSansSerif
            source: "../resources/fonts/micross.ttf"
        }
        FontLoader{
            id: fontArialBold
            source: "../resources/fonts/ARIALBD.TTF"
        }

        Text {
            id: screenText
            anchors.fill: parent
            anchors.margins: 10
            text: content
            color: "#FF0000"
            font.family: screen.screenFont
            font.pixelSize: (screen.height / screen.rows) * screen.fontScaleFactor
        }
    }

}