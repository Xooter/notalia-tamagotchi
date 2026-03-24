// StatBars.qml
// Barras de stats con animación y color dinámico según nivel.

import QtQuick
import QtQuick.Layouts
import qs.Commons

Column {
    id: root
    spacing: 8
    width: parent.width

    // El llamador pasa las stats explícitamente para evitar
    // problemas de resolución del singleton desde subdirectorios.
    property int hunger:      100
    property int happiness:   100
    property int cleanliness: 100
    property int energy:      100

    // ── Barra reutilizable ────────────────────────────────────────
    component StatBar: Item {
        id: barRoot

        property string label:    "Stat"
        property int    value:    100     // 0-100
        property string icon:     "●"
        // Color baja (rojo) → medio (amarillo) → alta (verde)
        readonly property color barColor: {
            if (value < 25)      return "#E24B4A"   // c-red-400
            else if (value < 50) return "#EF9F27"   // c-amber-400
            else                 return "#1D9E75"    // c-teal-400
        }

        width:  parent.width
        height: 28

        Row {
            anchors.fill: parent
            spacing: 8

            Text {
                text:           barRoot.icon
                font.pixelSize: 14
                color:          Style.colorOnSurface ?? "#ffffff"
                anchors.verticalCenter: parent.verticalCenter
                width: 18
            }

            Text {
                text:           barRoot.label
                font.pixelSize: 11
                color:          Style.colorOnSurfaceVariant ?? "#aaaaaa"
                width:          56
                anchors.verticalCenter: parent.verticalCenter
            }

            // Track de la barra
            Rectangle {
                width:               parent.width - 18 - 56 - 8*2 - 32
                height:              8
                radius:              4
                color:               Qt.rgba(1,1,1,0.12)
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    id: fill
                    height:  parent.height
                    radius:  parent.radius
                    color:   barRoot.barColor
                    width:   parent.width * (barRoot.value / 100)

                    Behavior on width {
                        NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
                    }
                    Behavior on color {
                        ColorAnimation { duration: 300 }
                    }
                }
            }

            // Número
            Text {
                text:           barRoot.value + "%"
                font.pixelSize: 11
                color:          barRoot.barColor
                width:          32
                horizontalAlignment: Text.AlignRight
                anchors.verticalCenter: parent.verticalCenter

                Behavior on color {
                    ColorAnimation { duration: 300 }
                }
            }
        }
    }

    // ── Instancias ────────────────────────────────────────────────
    StatBar {
        label: "Hambre"
        icon:  "🍗"
        value: root.hunger
        width: parent.width
    }

    StatBar {
        label: "Felicidad"
        icon:  "💛"
        value: root.happiness
        width: parent.width
    }

    StatBar {
        label: "Limpieza"
        icon:  "🧼"
        value: root.cleanliness
        width: parent.width
    }

    StatBar {
        label: "Energía"
        icon:  "⚡"
        value: root.energy
        width: parent.width
    }
}
