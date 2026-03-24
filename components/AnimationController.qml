// AnimationController.qml
// Controla qué frame del spritesheet mostrar según el estado del pet.
//
// Spritesheet esperado: pet_spritesheet.png
//   - 8 columnas × 6 filas  →  48 frames de 64×64 px (spritesheet 512×384)
//   - Fila 0: idle    (frames 0-7)
//   - Fila 1: eating  (frames 8-15)
//   - Fila 2: playing (frames 16-23)
//   - Fila 3: cleaning(frames 24-31)
//   - Fila 4: sleeping(frames 32-39)
//   - Fila 5: special (happy=40, sad=41, dirty=42, frames 44-47 libres)

import QtQuick

Item {
    id: root

    // El llamador enlaza esto al singleton: petState: TamagotchiState.petState
    property string petState:    "idle"

    // Tamaño del frame en el spritesheet
    readonly property int frameW: 450
    readonly property int frameH: 450
    readonly property int cols:    8

    implicitWidth:  frameW
    implicitHeight: frameH

    // ── Mapa estado → { row, frameCount, fps, loop } ─────────────
    readonly property var _animMap: ({
        "idle":     { row: 0, frameCount: 4, fps: 4,  loop: true  },
        "eating":   { row: 1, frameCount: 6, fps: 8,  loop: false },
        "playing":  { row: 2, frameCount: 8, fps: 10, loop: false },
        "cleaning": { row: 3, frameCount: 6, fps: 8,  loop: false },
        "sleeping": { row: 4, frameCount: 4, fps: 2,  loop: true  },
        "happy":    { row: 5, frameCount: 1, fps: 1,  loop: true  },
        "sad":      { row: 5, frameCount: 1, fps: 1,  loop: true  },
        "dirty":    { row: 5, frameCount: 1, fps: 1,  loop: true  },
    })

    // ── Estado interno de animación ───────────────────────────────
    property int _currentFrame: 0
    property var _anim: _animMap["idle"]

    on_AnimChanged: {
        _currentFrame = 0
        _frameTimer.restart()
    }

    onPetStateChanged: {
        var a = _animMap[petState]
        if (a) {
            _anim = a
            _currentFrame = 0
        }
    }

    Timer {
        id: _frameTimer
        interval: _anim ? Math.round(1000 / _anim.fps) : 250
        running:  true
        repeat:   true
        onTriggered: {
            if (!_anim) return
            if (_currentFrame < _anim.frameCount - 1) {
                _currentFrame++
            } else if (_anim.loop) {
                _currentFrame = 0
            } else {
                _frameTimer.stop()
            }
        }
    }

		Image {
				id: spriteImage

				anchors.centerIn: parent

				width: root.frameW
				height: root.frameH

				source: "../assets/sapo_base.png"

				fillMode: Image.PreserveAspectFit
				smooth: false
		}
}
