import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Widgets

Item {
    id: root

    property var pluginApi
    property ShellScreen screen
    property string widgetId: ""
    property string section: ""

    readonly property string screenName: screen?.name ?? ""
    readonly property real capsuleHeight: Style.getCapsuleHeightForScreen(screenName)

    implicitHeight: capsuleHeight
    implicitWidth: content.implicitWidth + Style.marginM * 2

    Rectangle {
        id: capsule
        anchors.centerIn: parent
        height: capsuleHeight
        width: root.implicitWidth
        radius: Style.radiusL
        color: Color.mSurfaceVariant

        Row {
            id: content
            anchors.centerIn: parent
            spacing: 6

            Text {
                text: "🐣"
                color: Color.mOnSurface
            }

            Text {
                text: "100%"
                color: Color.mOnSurface
            }
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if (!pluginApi) {
                return
            }

            let ok = pluginApi.openPanel(root.screen, root)
        }
    }
}
