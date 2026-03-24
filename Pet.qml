import QtQuick
import qs.Commons
import "./components"
import "." as Tamagotchi

Item {
    id: root

    property string petState:     Tamagotchi.TamagotchiState.petState

    implicitWidth:  120
    implicitHeight: 120

    AnimationController {
        id: animCtrl
        anchors.centerIn: parent
        width:        64
        height:       64
        petState:     Tamagotchi.TamagotchiState.petState
    }

		Repeater {
				id: foodParticles
        model: 5
				delegate: Text {
						id: foodParticle

						text: ["🍗","✨","💛","🌟","💫"][index]
						font.pixelSize: 14

						property real startX: 0
						property real startY: 0

						opacity: 0
						visible: false

						Component.onCompleted: {
								resetPosition()
						}

						function resetPosition() {
								startX = root.width / 2 + (Math.random() * 60 - 30)
								startY = root.height / 2

								x = startX
								y = startY
						}

						function burst() {
								resetPosition()

								visible = true
								opacity = 1
								burstAnim.restart()
						}

						SequentialAnimation {
								id: burstAnim

								ParallelAnimation {
										NumberAnimation {
												target: foodParticle
												property: "y"
												to: foodParticle.startY - 40 - Math.random()*20
												duration: 600
												easing.type: Easing.OutCubic
										}

										NumberAnimation {
												target: foodParticle
												property: "opacity"
												to: 0
												duration: 600
												easing.type: Easing.InQuad
										}
								}

								ScriptAction {
										script: {
												foodParticle.visible = false
												foodParticle.x = foodParticle.startX
												foodParticle.y = foodParticle.startY
										}
								}
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

						property real startX: 0
						property real startY: 0

						opacity: 0
						visible: false

						Component.onCompleted: {
								resetPosition()
						}

						function resetPosition() {
								startX = root.width / 2 + (Math.random() * 60 - 30)
								startY = root.height / 2

								x = startX
								y = startY
						}

						function burst() {
								resetPosition()

								visible = true
								opacity = 1
								burstAnim.restart()
						}

						SequentialAnimation {
								id: burstAnim

								ParallelAnimation {
										NumberAnimation {
												target: cleanParticle
												property: "y"
												to: cleanParticles.startY - 40 - Math.random()*20
												duration: 600
												easing.type: Easing.OutCubic
										}

										NumberAnimation {
												target: cleanParticle
												property: "opacity"
												to: 0
												duration: 600
												easing.type: Easing.InQuad
										}
								}

								ScriptAction {
										script: {
												cleanParticles.visible = false
												cleanParticles.x = cleanParticles.startX
												cleanParticles.y = foodcleanParticlesParticle.startY
										}
								}
						}
				}
    }

    DropArea {
        anchors.fill: parent
				keys: ["food"]
				z: 999

				onDropped: (drop) => {
						drop.acceptProposedAction()

						if (drop.source) {
								drop.source.wasDropped = true
						}

						Tamagotchi.TamagotchiState.feed(10)
						root.burstFood()
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
				z: 999

				onDropped: (drop) => {
						drop.acceptProposedAction()

						if (drop.source) {
								drop.source.wasDropped = true
						}

						Tamagotchi.TamagotchiState.clean(10)
						root.burstFood()
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
				for (var i = 0; i < foodParticles.count; i++) {
						var item = foodParticles.itemAt(i)
						if (item) item.burst()
				}
		}

		function burstClean() {
				for (var i = 0; i < cleanParticles.count; i++) {
						var item = cleanParticles.itemAt(i)
						if (item) item.burst()
				}
		}
}
