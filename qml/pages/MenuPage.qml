import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import Prezenter

Item {
    Rectangle{
        anchors.fill: parent
        color: "#FFFFFF"

        Text{
            anchors{
                top: parent.top
                left: parent.left
                margins: 10
            }
            font.pixelSize: 36
            font.bold: true
            text: "Tablica znakowa"
        }

        ColumnLayout{
            anchors.centerIn: parent
            spacing: 6
            Button{
                Layout.alignment: "AlignCenter"
                text: "Lista pieśni"
                onClicked: {
                    Navigation.push(Qt.resolvedUrl("HymnListPage.qml"))
                }
            }
            Button{
                Layout.alignment: "AlignCenter"
                text: "Zestawy"
                onClicked: {
                    Navigation.push(Qt.resolvedUrl("SetListPage.qml"))
                }
            }
            Button{
                Layout.alignment: "AlignCenter"
                text: "Ustawienia"
                onClicked: {
                    Navigation.push(Qt.resolvedUrl("SettingsPage.qml"))
                }
            }
        }

        Text{
            anchors{
                bottom: parent.bottom
                left: parent.left
                margins: 10
            }
            text: "Copyright © 2026 ŻupaNET Development"
        }
    }
}
