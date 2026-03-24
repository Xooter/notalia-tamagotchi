import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets
import QtMultimedia


Item {
    id: root

    property var pluginApi: null

    readonly property var geometryPlaceholder: panelContainer
    readonly property bool allowAttach: true

    property real contentPreferredWidth: 300
    property real contentPreferredHeight: 100

		anchors.fill: parent


SoundEffect {
    id: eatSound
    source: "sounds/eat.wav"
}

    Rectangle {
        id: panelContainer
        anchors.fill: parent
        color: "transparent"

        Column {
            anchors.centerIn: parent
            spacing: 10

            Text {
                text: "Tamagochi 🐣"
                color: "white"
            }

					NIconButton {
							icon: "close"
							onClicked: {
									eatSound.play()
							}
					}
				}

			Rectangle {
					id: food
					width: 40
					height: 40
					radius: 8
					color: "orange"

					property bool dragging: false

					Text {
							anchors.centerIn: parent
							text: "🍗"
					}

					MouseArea {
							anchors.fill: parent

							drag.target: food
							drag.axis: Drag.XAndYAxis

							onPressed: food.dragging = true
							onReleased: food.dragging = false
					}
			}
    }
}
