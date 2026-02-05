import QtQuick
import qs.services
import qs.services.theme
import qs.services.tooltip

Rectangle {
    id: root

    property real margin: ThemeProvider.getMargin()
    property int animationDuration: 200

    property real fixedWidth: 0
    property real fixedHeight: 34 - margin * 2

    default required property Item child

    property string tooltipText: ""
    property string leftAction: ""
    property string rightAction: ""

    color: ThemeProvider.getColor("card").toString()
    border.color: ThemeProvider.getColor("border").toString()
    border.width: 1
    radius: ThemeProvider.getRadius()

    children: [mouseArea, root.child]

    implicitWidth: root.fixedWidth > 0 ? root.fixedWidth + root.margin * 2 : root.child.implicitWidth + root.margin * 2
    implicitHeight: root.fixedHeight > 0 ? root.fixedHeight + root.margin * 1.2 : root.child.implicitHeight + root.margin * 1.2

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton && root.leftAction !== null) {
                ProcessManager.runCommand(root.leftAction);
            } else if (mouse.button === Qt.RightButton && root.rightAction !== null) {
                ProcessManager.runCommand(root.rightAction);
            }
        }
        onEntered: {
            TooltipProvider.show(root, root.tooltipText);
        }
        onExited: {
            TooltipProvider.hide();
        }
    }

    states: State {
        name: "hovered"
        when: mouseArea.containsMouse
        PropertyChanges {
            root.border.color: ThemeProvider.getColor("secondary").toString()
        }
    }

    transitions: Transition {
        reversible: true
        ColorAnimation {
            duration: root.animationDuration
        }
    }

    Binding {
        root.child.x: root.margin
    }
    Binding {
        root.child.y: root.margin
    }
    Binding {
        root.child.width: root.width - root.margin * 2
    }
    Binding {
        root.child.height: root.height - root.margin * 2
    }
}
