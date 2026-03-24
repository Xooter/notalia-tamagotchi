
// Soap.qml
// Ítem de limpieza draggeable. Emite la key "soap" para el DropArea del pet.

import QtQuick
import qs.Commons

Rectangle {
    id: root

    width:  44
    height: 44
    radius: 10
    color:  _dragging ? Qt.rgba(0.2,0.7,1.0,0.9) : Qt.rgba(0.2,0.7,1.0,0.75)
    border.color: Qt.rgba(0.5,0.85,1.0,0.5)
    border.width: 1

    property bool _dragging: false

    Drag.active:  _dragging
    Drag.keys:    ["soap"]
    Drag.hotSpot.x: width  / 2
    Drag.hotSpot.y: height / 2

    property real _restX: x
    property real _restY: y

    scale: _dragging ? 1.15 : 1.0
    Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutBack } }

    Text {
        anchors.centerIn: parent
        text:          "🧼"
        font.pixelSize: 22
    }

    // Burbujas decorativas
    Repeater {
        model: 3
        delegate: Rectangle {
            property real angle: index * 120 * Math.PI / 180
            x: root.width/2 + Math.cos(angle)*14 - 3
            y: root.height/2 + Math.sin(angle)*14 - 3
            width:  6
            height: 6
            radius: 3
            color:  Qt.rgba(1,1,1,0.35)
            visible: root._dragging
            opacity: root._dragging ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
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
                disappearAnim.start()
            } else {
                root.x = root._restX
                root.y = root._restY
            }
        }
    }

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
