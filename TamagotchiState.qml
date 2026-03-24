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

    function feed() {
        hunger = Math.min(100, hunger + 20)
        petState = "eating"
        statChanged("hunger", hunger)
        _returnToIdleTimer.restart()
        save()
    }

    function play() {
        if (energy < 10) return
        happiness   = Math.min(100, happiness + 20)
        energy      = Math.max(0, energy - 15)
        petState = "playing"
        statChanged("happiness", happiness)
        _returnToIdleTimer.restart()
        save()
    }

    function clean() {
        cleanliness = Math.min(100, cleanliness + 25)
        petState = "cleaning"
        statChanged("cleanliness", cleanliness)
        _returnToIdleTimer.restart()
        save()
    }

    function sleep() {
        if (petState === "sleeping") {
            // Despertar
            energy  = Math.min(100, energy + 40)
            petState = "idle"
        } else {
            petState = "sleeping"
        }
        save()
    }

    function decay() {
        if (petState === "sleeping") {
            // Dormir recupera energía pero baja otras stats más lento
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
        if (petState === "eating" || petState === "playing" ||
            petState === "cleaning" || petState === "sleeping") return

        if (hunger < 20)      petState = "sad"
        else if (cleanliness < 20) petState = "dirty"
        else if (happiness > 80)   petState = "happy"
        else                       petState = "idle"
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
