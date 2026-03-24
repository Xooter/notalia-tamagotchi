// Pet.qml
// Sprite del pet con DropArea para comida y jabón.
// Usa AnimationController para manejar el spritesheet.

import QtQuick
import qs.Commons
import "./components"

Item {
    id: root

    property string petState:     "idle" 

    signal fed()
    signal cleaned()

    implicitWidth:  120
    implicitHeight: 120

    AnimationController {
        id: animCtrl
        anchors.centerIn: parent
        width:        64
        height:       64
        petState:     root.petState
    }

    Repeater {
        model: 5
        delegate: Text {
            id: foodParticle
            text: ["🍗","✨","💛","🌟","💫"][index]
            font.pixelSize: 14
            x: root.width / 2 + (Math.random() * 60 - 30)
            y: root.height / 2
            opacity: 0
            visible: false

            function burst() {
                visible = true
                opacity = 1
                burstAnim.restart()
            }

            SequentialAnimation {
                id: burstAnim
                ParallelAnimation {
                    NumberAnimation { target: foodParticle; property: "y";       to: foodParticle.y - 40 - Math.random()*20; duration: 600; easing.type: Easing.OutCubic }
                    NumberAnimation { target: foodParticle; property: "opacity"; to: 0; duration: 600; easing.type: Easing.InQuad }
                }
                ScriptAction { script: foodParticle.visible = false }
            }
        }
    }

    Repeater {
        id: cleanParticles
        model: 5
        delegate: Text {
            id: cleanParticle
            text: ["🧼","✨","💧","⭐","🫧"][index]
            font.pixelSize: 14
            x: root.width / 2 + (Math.random() * 60 - 30)
            y: root.height / 2
            opacity: 0
            visible: false

            function burst() {
                visible = true
                opacity = 1
                cleanBurstAnim.restart()
            }

            SequentialAnimation {
                id: cleanBurstAnim
                ParallelAnimation {
                    NumberAnimation { target: cleanParticle; property: "y";       to: cleanParticle.y - 40 - Math.random()*20; duration: 600; easing.type: Easing.OutCubic }
                    NumberAnimation { target: cleanParticle; property: "opacity"; to: 0; duration: 600; easing.type: Easing.InQuad }
                }
                ScriptAction { script: cleanParticle.visible = false }
            }
        }
    }

    DropArea {
        anchors.fill: parent
        keys: ["food"]

        onDropped: {
            root.fed()
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.width / 2
            color: "transparent"
            border.color: Qt.rgba(1, 0.8, 0, 0.6)
            border.width: 2
            opacity: parent.containsDrag ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
    }

    DropArea {
        anchors.fill: parent
        keys: ["soap"]

        onDropped: {
            root.cleaned()
        }

				Rectangle {
            anchors.fill: parent
            radius: parent.width / 2
            color: "transparent"
            border.color: Qt.rgba(0.2, 0.7, 1.0, 0.6)
            border.width: 2
            opacity: parent.containsDrag ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
    }

    function burstFood() {
        for (var i = 0; i < 5; i++) {
            // Usamos el índice i directamente
        }
    }
}
