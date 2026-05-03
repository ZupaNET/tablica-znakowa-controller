import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("Tryb prezentacji")

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
            id: buttonEditSet
            anchors {
                left: parent.left
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }
            text: "Edytuj zestaw"
            flat: true
            Material.foreground: "white"
        }

        // Button{
        //     id: buttonConnect
        //     anchors{
        //         right: parent.right
        //         verticalCenter: parent.verticalCenter
        //         rightMargin: 10
        //     }
        //     text: "Połącz"
        // }

        Button{
            id: buttonFreeze
            anchors {
                right: parent.right
                rightMargin: 10
                verticalCenter: parent.verticalCenter
            }
            text: "Zamrożenie"
            Material.foreground: "white"
            flat: true
            onClicked: {
                tablicaZnakowa.setFreeze(!(tablicaZnakowa.isFrozen()));
                this.highlighted = tablicaZnakowa.isFrozen();
            }
        }
    }

    Rectangle{
        id: mainView
        anchors {
            top: topBar.bottom
            right: buttonHideSetView.left
            bottom: parent.bottom
            left: parent.left
            rightMargin: 10
        }

        Text{
            id: textSetTitle
            anchors {
                top: parent.top
                left: parent.left
                margins: 10
            }
            text: "Niedziela zwykła"
            font.pointSize: 20
        }

        Rectangle {
            id: screenView
            anchors {
                top: textSetTitle.bottom
                right: parent.right
                bottom: screenViewButtons.top
                left: parent.left
            }

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
                state: "screenView"
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
                                screen.width / screen.columns,
                                screen.height / screen.rows
                            )
                            color: "#FF0000"
                        }
                    },
                    State {
                        name: "textView"
                        PropertyChanges {
                            target: screen
                            color: "#FFFFFF"
                        }
                        PropertyChanges {
                            target: screenText
                            font.family: "Arial"
                            font.pixelSize: Math.min(
                                screen.width / screen.columns*1.2,
                                screen.height / screen.rows*1.2
                            )
                            color: "#000000"
                        }
                    }
                ]
                border.color: "#000000"
                border.width: 1

                FontLoader{
                    id: fontMiniForma2
                    source: "resources/MiniForma2.ttf"
                }

                Text {
                    id: screenText
                    anchors.fill: parent
                    anchors.margins: 10
                    text: "CZEGO CHCESZ
OD NAS, PANIE,
ZA TWE HOJNE DARY?
CZEGO ZA DOBRODZIEJSTWA,
KTÓRYM NIE MASZ MIARY,
KOŚCIÓŁCIĘ NIE OGARNIE,
WSZĘDY PEŁNO CIEBIE,
I W OTCHŁANIACH I W MORZU,
NA ZIEMI I W NIEBIE."
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

        Rectangle{
            id: screenViewButtons
            anchors {
                right: parent.right
                bottom: parent.bottom
                left: parent.left
            }
            height: 65

            Button{
                id: buttonChangeView
                anchors {
                    left: parent.left
                    bottom: parent.bottom
                    margins: 10
                }
                text: "Widok"
                onClicked: {
                    screen.state === "screenView"? screen.state = "textView" : screen.state = "screenView";
                }
            }

            Button{
                id: buttonScreenEdit
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    margins: 10
                }
                text: "Edytuj slajd"
            }

            Button{
                id: buttonSetItemProperties
                anchors {
                    right: buttonScreenEdit.left
                    bottom: parent.bottom
                    margins: 10
                }
                text: "Właściwości"
            }
        }
    }

    Button{
        id: buttonHideSetView
        anchors {
            top: topBar.bottom
            right: setView.left
            rightMargin: -20
        }
        text: "> "
        onClicked: {
            if(setView.state === "open"){
                setView.state = "closed";
                buttonHideSetView.text = "< "
            }else{
                setView.state = "open";
                buttonHideSetView.text = "> "
            }
        }
    }

    Rectangle{
        id: setView
        anchors {
            top: topBar.bottom
            bottom: parent.bottom
        }
        width: parent.width * 0.2
        color: "#cfcfcf"
        state: "open"
        states: [
            State {
                name: "open"
                PropertyChanges {
                    target: setView
                    x: parent.width - setView.width
                }
            },
            State {
                name: "closed"
                PropertyChanges {
                    target: setView
                    x: parent.width
                }
            }
        ]
        transitions: Transition {
            NumberAnimation {
                properties: "x"
                duration: 250
                easing.type: Easing.InOutQuad
            }
        }

        Text{
            id: textSetView
            anchors {
                top: parent.top
                left: parent.left
                margins: 10
            }
            text: "Zestaw:"
            //color: "#ffffff"
            font.pointSize: 11
        }

        Rectangle {
            id: screensView
            anchors {
               top: textSetView.bottom
               left: parent.left
               right: parent.right
               bottom: parent.bottom
               topMargin: 10
            }
            color: parent.color

            Button{
                id: miniscreen
                text: "Czego chcesz od... \n1. CZEGO CHCESZ.."
                font.pixelSize: 12
                width: parent.width - 10
                anchors.left: parent.left
                anchors.leftMargin: 5
                contentItem: Text {
                        text: parent.text
                        //font: parent.font
                        horizontalAlignment : Text.AlignLeft
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        clip: true
                }
            }

            Button{
                anchors.top: miniscreen.bottom
                text: "Czego chcesz od...\n2. ZŁOTA TEŻ WIEM.."
                font.pixelSize: 12
                width: parent.width - 10
                anchors.left: parent.left
                anchors.leftMargin: 5
                contentItem: Text {
                        text: parent.text
                        //font: parent.font
                        horizontalAlignment : Text.AlignLeft
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        clip: true
                }
            }

//             Rectangle {
//                 id: miniscreen
//                 anchors.horizontalCenter: parent.horizontalCenter
//                 anchors.topMargin: 10
//                 property int columns: 24
//                 property int rows: 16
//                 property int margins: 5
//                 width: Math.min(
//                         parent.width - 2 * margins,
//                         (parent.height - 2 * margins) * columns / rows
//                 )
//                 height: width * rows / columns
//                 color: "#111111"
//                 border.color: "#FFFF00"
//                 border.width: 5

//                 Text {
//                     id: miniscreenText
//                     anchors.fill: parent
//                     anchors.margins: 5
//                     text: "CZEGO CHCESZ
// OD NAS, PANIE,
// ZA TWE HOJNE DARY?
// CZEGO ZA DOBRODZIEJSTWA,
// KTÓRYM NIE MASZ MIARY,
// KOŚCIÓŁCIĘ NIE OGARNIE,
// WSZĘDY PEŁNO CIEBIE,
// I W OTCHŁANIACH I W MORZU,
// NA ZIEMI I W NIEBIE."
//                     clip: true
//                     color: "#FF0000"
//                     //wrapMode: Text.Wrap
//                     font.family: fontMiniForma2.font.family
//                     font.pixelSize: Math.min(
//                         screen.width / screen.columns,
//                         screen.height / screen.rows
//                     )/2
//                 }
//             }
//             Rectangle {
//                 id: miniscreen2
//                 anchors.horizontalCenter: parent.horizontalCenter
//                 anchors.top: miniscreen.bottom
//                 anchors.topMargin: 10
//                 property int columns: 24
//                 property int rows: 16
//                 property int margins: 5
//                 width: Math.min(
//                         parent.width - 2 * margins,
//                         (parent.height - 2 * margins) * columns / rows
//                 )
//                 height: width * rows / columns
//                 color: "#111111"
//                 //border.color: "#FFFF00"
//                 //border.width: 5

//                 Text {
//                     id: miniscreen2Text
//                     anchors.fill: parent
//                     anchors.margins: 5
//                     text: "ZŁOTA TEŻ, WIEM,
// NIE PRAGNIESZ,
// BO TO WSZYSTKO TWOJE,
// COKOLWIEK NA TYM ŚWIECIE
// CZŁOWIEK MIENI SWOJE."
//                     clip: true
//                     color: "#FF0000"
//                     //wrapMode: Text.Wrap
//                     font.family: fontMiniForma2.font.family
//                     font.pixelSize: Math.min(
//                         screen.width / screen.columns,
//                         screen.height / screen.rows
//                     )/2
//                 }
//             }
        }
    }
}
