import QtQuick
import qs.Commons

Rectangle {
    id: root

    width:  44
    height: 44
    radius: 10
    color:  "transparent"

		property bool _dragging: false
		property bool wasDropped: false

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
						root.Drag.drop()

						if (root.wasDropped) {
								disappearAnim.start()
						} else {
								root.x = root._restX
								root.y = root._restY
						}

						root.wasDropped = false
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
