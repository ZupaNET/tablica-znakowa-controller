import QtQuick
import QtQuick.Controls
import Prezenter

TextArea {
    id: control

    property real lineHeight: 0
    property real lineHeightMode: LineHeightHelper.SingleHeight

    LineHeightHelper {
        id: lineHeightHelper

        lineHeight: control.lineHeight
        lineHeightMode: control.lineHeightMode

        Component.onCompleted: {
            attach(control.textDocument)
        }
    }

    Component.onDestruction: {
        lineHeightHelper.detach()
    }
}