import QtQuick
import Quickshell.Widgets
import qs.services
import qs.services.theme

WrapperRectangle {
    id: root
    required property string icon
    required property int index
    required property var modelData
    property bool isActive: modelData.is_active
    property bool isEmpty: modelData.active_window_id === null

    margin: ThemeProvider.getMargin()
    topMargin: ThemeProvider.getMargin() - 3
    bottomMargin: ThemeProvider.getMargin() - 3
    radius: ThemeProvider.getRadius()

    child: wsIcon

    children: [root.child, mouseArea]

    color: ThemeProvider.getColor("secondary").alpha(0)

    transitions: Transition {
        ColorAnimation {
            duration: 300
        }
    }

    states: [
        State {
            name: "hovered"
            when: mouseArea.containsMouse
            PropertyChanges {
                target: root
                color: ThemeProvider.getColor("secondary").alpha(0.3)
            }
        },
        State {
            name: "active"
            when: isActive
            PropertyChanges {
                target: root
                color: ThemeProvider.getColor("secondary").alpha(0.3)
            }
        }
    ]

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Niri.focusWorkspace(root.index)
    }

    Text {
        id: wsIcon
        anchors.centerIn: parent
        font.pixelSize: 18
        text: root.icon
        property string textColor: isEmpty ? "mutedForeground" : "foreground"
        color: ThemeProvider.getColor(textColor).toString()

        states: State {
            name: "active"
            when: root.isActive
            PropertyChanges {
                target: wsIcon
                color: ThemeProvider.getColor("secondary").toString()
            }
        }

        transitions: Transition {
            ColorAnimation {
                duration: 300
            }
        }
    }
}
