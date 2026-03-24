import QtQuick

Item {
    id: root

    property string petState: "idle"

    readonly property int frameW: 320
    readonly property int frameH: 320

    implicitWidth:  frameW
    implicitHeight: frameH

    readonly property var _imageMap: ({
        "idle":     "../assets/sapo_idle.png",
        "eating":   "../assets/sapo_open_mouth.png",
        "playing":  "../assets/sapo_idle.png",
        "cleaning": "../assets/sapo_idle.png",
        "sleeping": "../assets/sapo_sleeping.png",
        "happy":    "../assets/sapo_idle.png",
        "sad":      "../assets/sapo_sad.png",
        "dirty":    "../assets/sapo_tired.png",
        "hunger":    "../assets/sapo_tired.png",
    })

    Image {
        anchors.centerIn: parent
        width:    root.frameW
        height:   root.frameH
        source:   root._imageMap[root.petState] ?? "../assets/sapo_idle.png"
        fillMode: Image.PreserveAspectFit
        smooth:   false
    }
}
