import QtQuick
import qs.Commons

Rectangle {
    id: root

    property bool consumed: false

    width:  44
    height: 44
    radius: 10
    color:  _dragging ? Qt.rgba(1,0.6,0.2,0.9) : Qt.rgba(1,0.6,0.2,0.75)
    border.color: Qt.rgba(1,0.8,0.4,0.5)
    border.width: 1

    property bool _dragging: false

    Drag.active:  _dragging
    Drag.keys:    ["food"]
    Drag.hotSpot.x: width  / 2
    Drag.hotSpot.y: height / 2

    // Guardamos la posición de reposo para volver si no hubo drop
    property real _restX: x
    property real _restY: y

    // Escala al arrastrar
    scale: _dragging ? 1.15 : 1.0
    Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutBack } }

    Text {
        anchors.centerIn: parent
        text:          "🍗"
        font.pixelSize: 22
    }

    // Sombra sutil al arrastrar
    Rectangle {
        anchors.centerIn: parent
        width:   parent.width  + 6
        height:  parent.height + 6
        radius:  parent.radius + 3
        color:   "transparent"
        border.color: Qt.rgba(1,0.6,0.2,0.3)
        border.width: root._dragging ? 2 : 0
        z: -1
        Behavior on border.width { NumberAnimation { duration: 120 } }
    }

    MouseArea {
        anchors.fill: parent
        drag.target:  root
        drag.axis:    Drag.XAndYAxis

        onPressed: {
            root._dragging = true
            root._restX = root.x
            root._restY = root.y
        }

        onReleased: {
            root._dragging = false
            if (root.Drag.drop() !== Qt.IgnoreAction) {
                // Drop exitoso: animar desaparición
                disappearAnim.start()
            } else {
                // Volver a la posición original
                root.x = root._restX
                root.y = root._restY
            }
        }
    }

    // Animación al ser consumido
    SequentialAnimation {
        id: disappearAnim
        ParallelAnimation {
            NumberAnimation { target: root; property: "scale";   to: 1.6; duration: 200 }
            NumberAnimation { target: root; property: "opacity"; to: 0;   duration: 200 }
        }
        ScriptAction {
            script: {
                root.scale   = 1.0
                root.opacity = 1.0
                root.x       = root._restX
                root.y       = root._restY
            }
        }
    }
}
