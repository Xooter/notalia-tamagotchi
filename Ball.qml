import QtQuick


Rectangle {
    id: root
    width: 30
    height: 30
    radius: 15
    color: "red"
    property real vx: 3
    property real vy: 0
    property real gravity: 0.4
    property real bounce: 0.7
    property real friction: 0.999

    Timer {
        id: physicsTimer
        interval: 16
        running: true
        repeat: true
        onTriggered: {
            if (!root.parent) return
            root.vy += root.gravity
            root.x += root.vx
            root.y += root.vy

            if (root.y + root.height >= root.parent.height) {
                root.y = root.parent.height - root.height
                root.vy *= -root.bounce
            }
            if (root.y <= 0) {
                root.y = 0
                root.vy *= -root.bounce
            }
            if (root.x <= 0) {
                root.x = 0
                root.vx *= -1
            }
            if (root.x + root.width >= root.parent.width) {
                root.x = root.parent.width - root.width
                root.vx *= -1
            }
            root.vx *= root.friction
        }
    }

    MouseArea {
        anchors.fill: parent
        drag.target: root
        drag.axis: Drag.XAndYAxis

        property real lastAbsX
        property real lastAbsY
        property real vxTemp
        property real vyTemp

        onPressed: (mouse) => {
            physicsTimer.running = false   // pausar física
            root.vx = 0
            root.vy = 0
            var abs = mapToItem(root.parent, mouse.x, mouse.y)
            lastAbsX = abs.x
            lastAbsY = abs.y
            vxTemp = 0
            vyTemp = 0
        }

        onPositionChanged: (mouse) => {
            var abs = mapToItem(root.parent, mouse.x, mouse.y)
            vxTemp = abs.x - lastAbsX
            vyTemp = abs.y - lastAbsY
            lastAbsX = abs.x
            lastAbsY = abs.y
        }

        onReleased: {
            root.vx = vxTemp * 1.5
            root.vy = vyTemp * 1.5
            physicsTimer.running = true    // reanudar física
        }
    }
}
