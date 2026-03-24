import QtQuick
import QtQuick.Layouts
import QtMultimedia
import qs.Commons
import "." as Tamagotchi
import "./components"

Item {
    id: root

    property var pluginApi: null

		property real contentPreferredWidth: 600 * Style.uiScaleRatio
		property real contentPreferredHeight: 400 * Style.uiScaleRatio
  

    Component.onCompleted: {
        if (pluginApi) {
            Tamagotchi.TamagotchiState.pluginApi = pluginApi
            Tamagotchi.TamagotchiState.load()
        }
    }

    SoundEffect { id: soundEat;     source: "sounds/eat.wav"    }
    SoundEffect { id: soundPlay;    source: "sounds/eat.wav"    }
    SoundEffect { id: soundClean;   source: "sounds/eat.wav"    }
    SoundEffect { id: soundSleep;   source: "sounds/eat.wav"    }

    Connections {
        target: Tamagotchi.TamagotchiState

        function onPetStateChanged() {
            var s = Tamagotchi.TamagotchiState.petState
            if      (s === "eating")   soundEat.play()
            else if (s === "playing")  soundPlay.play()
            else if (s === "cleaning") soundClean.play()
            else if (s === "sleeping") soundSleep.play()
        }
    }

    Timer {
        interval: 1000   // cada 8s
        running:  true
        repeat:   true
        onTriggered: Tamagotchi.TamagotchiState.decay()
    }

    ColumnLayout {
        anchors.fill:    parent
				anchors.margins: 8
				spacing: 8

        Item {
            Layout.fillWidth: true
            height: 140

							Pet {
                id: pet
                anchors.centerIn: parent
							}

							Row {
								
							Food {}

							Soap{}
						}
				}

				Ball {}

        StatBars {
            Layout.fillWidth: true
            hunger:      Tamagotchi.TamagotchiState.hunger
            happiness:   Tamagotchi.TamagotchiState.happiness
            cleanliness: Tamagotchi.TamagotchiState.cleanliness
            energy:      Tamagotchi.TamagotchiState.energy
				}

        DebugButtons {
            Layout.alignment: Qt.AlignHCenter
        }

        // ActionButtons {
        //     Layout.alignment: Qt.AlignHCenter
        //     petState: Tamagotchi.TamagotchiState.petState
        //     energy:   Tamagotchi.TamagotchiState.energy
        //     onAction: function(action) {
        //         var s = Tamagotchi.TamagotchiState
        //         if      (action === "feed")  s.feed()
        //         else if (action === "play")  s.play()
        //         else if (action === "clean") s.clean()
        //         else if (action === "sleep") s.sleep()
        //     }
        // }
    }
}
