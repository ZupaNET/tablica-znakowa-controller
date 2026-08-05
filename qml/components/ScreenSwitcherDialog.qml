import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Prezenter

Dialog {
    id: root

    property int setId: -1
    property int hymnId: -1

    title: qsTr("Widoczność slajdów")

    modal: true

    width: 650
    height: 600

    padding: 16

    parent: Overlay.overlay
	anchors.centerIn: Overlay.overlay
    dim: true

    standardButtons: Dialog.Close

    SetScreenModel {
        id: screenModel

        setId: root.setId
        hymnId: root.hymnId
    }

    onOpened: {
        screenModel.reload()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true

            radius: 6
            color: "transparent"

            border.color: Theme.surfaceBorder
            border.width: 1

            SlimScreenPanel {
                anchors.fill: parent
                anchors.margins: 8

                model: screenModel

                onToggleScreen: function(row, shown) {
                    screenModel.changeScreenVisibility(row, shown)
                }

                onChangeAllScreens: function(shown) {
                    screenModel.changeAllScreenVisibility(shown)
                }
            }
        }
    }
}