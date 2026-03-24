import QtQuick
import QtQuick.Layouts
import qs.Commons

Column {
    id: root
    spacing: 8
		width: parent.width

    property int hunger:      100
    property int happiness:   100
    property int cleanliness: 100
    property int energy:      100

    component StatBar: Item {
        id: barRoot

        property string label:    "Stat"
        property int    value:    100     
        property string icon:     "●"
        readonly property color barColor: {
            if (value < 25)      return "#E24B4A"   
            else if (value < 50) return "#EF9F27"   
            else                 return "#1D9E75"   
        }

        width:  parent.width
				height: 28
				anchors.horizontalCenter: parent.horizontalCenter

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

    StatBar {
        icon:  "🍗"
        value: root.hunger
        width: parent.width
    }

    StatBar {
        icon:  "😃"
        value: root.happiness
        width: parent.width
    }

    StatBar {
        icon:  "🧼"
        value: root.cleanliness
        width: parent.width
    }

    StatBar {
        icon:  "🛏️"
        value: root.energy
        width: parent.width
    }
}
