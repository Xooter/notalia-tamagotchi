import QtQuick
import ".." as Tamagotchi

Item {
    id: root

		property int frameH: 64
    property int frameW: 64

    implicitWidth:  frameW
    implicitHeight: frameH

    readonly property var _imageMap: ({
        "idle":     "../assets/sapo_idle.png",
				"sleeping": "../assets/sapo_sleeping.png",
				"eating":   "../assets/sapo_open_mouth.png",

        "sad":      "../assets/sapo_sad.png",
        "dirty":    "../assets/sapo_tired.png",
				"hungry":   "../assets/sapo_tired.png",
				"tired":   	"../assets/sapo_tired.png",
				"angry":    "../assets/sapo_angry.png"
			})

		Image {
        anchors.centerIn: parent
        width:    root.frameW
        height:   root.frameH
        source:   root._imageMap[Tamagotchi.TamagotchiState.petState] ?? "../assets/sapo_idle.png"
        fillMode: Image.PreserveAspectFit
        smooth:   false
    }
}
