pragma Singleton

import QtQuick
import QtQuick.Controls

QtObject {
    id: root

    property StackView stackView

    //Navigation handler

    function push(page, props) {
        if (!stackView)
            return

        stackView.push(page, props || {})
    }

    function pop() {
        if (!stackView)
            return

        if (stackView.depth > 1)
            stackView.pop()
    }

    function replace(page, props) {
        if (!stackView)
            return

        stackView.replace(page, props || {})
    }

    //Android back button handler

    function back() {

        let current = stackView.currentItem

        if (current && current.handleBack) {

            if (current.handleBack())
                return true
        }

        if (stackView.depth > 1) {
            stackView.pop()
            return true
        }

        return false
    }
}