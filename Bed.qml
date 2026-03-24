import QtQuick
import qs.Commons
import "." as Tamagotchi

Rectangle {
    id: root

    width: 64
    height: 64
    radius: 10
		color: pressed ? Color.mPrimary : Color.mSecondary

    property bool pressed: false

    Behavior on color {
        ColorAnimation { duration: 150 }
    }

    Text {
        anchors.centerIn: parent
        text: Tamagotchi.TamagotchiState.petState === "sleeping" ? "😴" : "a"
        font.pixelSize: 28
        color: Color.mSecondary
    }

    MouseArea {
        anchors.fill: parent

        onPressed: root.pressed = true
        onReleased: {
            root.pressed = false
            Tamagotchi.TamagotchiState.sleep()
        }
    }
}
