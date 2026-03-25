pragma Singleton
import QtQuick


// Enojado = felicidad
// Cansado = sue;o
// Limpio = limpieza
//
//
// Idle
// Triste = falta de juego
// Enojodo = falta de comida y cansancio
// Cansado = cansancio
// Hambre = falta de comida
// Durmiendo 

QtObject {
    id: root

    property int hunger:      100
    property int happiness:   100
    property int cleanliness: 100
    property int energy:      100

    // "idle" | "eating" | "playing" | "cleaning" | "sleeping"
    //           | "happy" | "sad" | "dirty" 
		property string petState: "idle"
		property string lastPetState: "idle"

    property var pluginApi: null

    signal statChanged(string stat, int value)

    function load() {
        if (!pluginApi) return
        var s = pluginApi.settings
        hunger      = s.hunger      !== undefined ? s.hunger      : 100
        happiness   = s.happiness   !== undefined ? s.happiness   : 100
        cleanliness = s.cleanliness !== undefined ? s.cleanliness : 100
        energy      = s.energy      !== undefined ? s.energy      : 100
        _updatePetState()
    }

    function save() {
        if (!pluginApi) return
        pluginApi.settings = {
            hunger:      hunger,
            happiness:   happiness,
            cleanliness: cleanliness,
            energy:      energy,
        }
    }

    function feed(v) {
        hunger = Math.min(100, hunger + v)
				save()
    }

    function play(h,e = 15) {
        if (energy < 10) return
        happiness   = Math.min(100, happiness + h)
        energy      = Math.max(0, energy - e)
				save()
    }

    function clean(c) {
        cleanliness = Math.min(100, cleanliness + c)
        save()
    }

    function sleep(e) {
        if (petState === "sleeping") {
					petState = lastPetState
				} else {
					lastPetState = petState
					petState = "sleeping"
				}
        save()
    }

    function decay() {
        if (petState === "sleeping") {
            energy      = Math.min(100, energy + 5)
            hunger      = Math.max(0, hunger - 1)
            happiness   = Math.max(0, happiness - 1)
            cleanliness = Math.max(0, cleanliness - 1)
        } else {
            hunger      = Math.max(0, hunger - 2)
            happiness   = Math.max(0, happiness - 1)
            cleanliness = Math.max(0, cleanliness - 2)
            energy      = Math.max(0, energy - 1)
        }
        _updatePetState()
        save()
    }

		function _updatePetState() {
				const isSad    = happiness   < 30
				const isTired  = energy      < 30
				const isDirty  = cleanliness < 20
				const isHungry = hunger      < 20

				if (isTired && isSad && isHungry)      petState = "angry"
				else if (isHungry && isSad)            petState = "angry"
				else if (isTired && isSad)             petState = "angry"
				else if (isHungry)                     petState = "hungry"
				else if (isDirty)                      petState = "dirty"
				else if (isSad)                        petState = "sad"
				else if (isTired)                      petState = "tired"
				else                                   petState = "idle"
		}


    property Timer _returnToIdleTimer: Timer {
        interval: 2000
        repeat:   false
        onTriggered: {
            if (root.petState !== "sleeping") {
                root._updatePetState()
            }
        }
    }
}
