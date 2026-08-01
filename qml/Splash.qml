import QtQuick 2.15
import QtQuick.Controls 2.15

Window {
    id: splash

    visible: true
    flags: Qt.SplashScreen
    color: "transparent"

    Image {
        id: image
        anchors.fill: parent
        source: "qrc:/images/splash.png"
    }

    function startFadeOut() {
        fade.start()
    }

    SequentialAnimation {
        id: fade

        OpacityAnimator {
            target: image
            from: 1
            to: 0
            duration: 300
        }

        ScriptAction {
            script: splash.close()
        }
    }
}