import QtQuick 2.15
import QtQuick.Controls

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Tryb prezentacji")

    Rectangle{
        id: topBar
        anchors{
            top: parent.top
            right: parent.right
            left: parent.left
        }
        color: "#474747"
        height: 50

        Button{
            id: buttonEditSet
            anchors{
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 10
            }
            Material.foreground: "white"
            text: "Edytuj zestaw"
            flat: true
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
            anchors{
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 10
            }

            Material.foreground: "white"

            text: "Zamrożenie"
            flat: true
            onClicked: {
                tablicaZnakowa.setFreeze(!(tablicaZnakowa.isFrozen()));
                this.highlighted = tablicaZnakowa.isFrozen();
            }
        }
    }
    Rectangle{
        id: mainView
        anchors{
            top: topBar.bottom
            right: parent.right
            left: parent.left
            bottom: parent.bottom
        }

        Rectangle{
            id: slideView
            anchors{
                top: parent.top
                right: parent.right
                left: parent.left
                bottom: slideViewButtons.top
            }
            height: parent.height - slideViewButtons

            TextArea{
                anchors{
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
                height: parent.height * 0.9
                width: height * 3/2
            }
        }

        Rectangle{
            id: slideViewButtons
            anchors{
                right: parent.right
                bottom: parent.bottom
                left: parent.left
                margins: 20
            }
            height: 50

            Button{
                anchors{
                    right: parent.right
                    bottom: parent.bottom
                    margins: 20
                }
                id: slideEdit
                text: "Edytuj slajd"
            }

            Button{
                id: setItemProperties
                anchors{
                    right: slideEdit.left
                    bottom: parent.bottom
                    margins: 20
                }
                text: "Właściwości"
            }
        }
    }
}
