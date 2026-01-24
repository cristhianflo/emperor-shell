pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Widgets
import Quickshell
import qs.services.tooltip

Item {
    id: root
    required property PanelWindow panel
    required property ShellScreen screen
    required property var modelData
    required property int index
    property int menuX: index * 16

    width: 17
    height: 17

    MouseArea {
        id: trayMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onEntered: {
            var tooltipText = root.modelData.title !== "" ? root.modelData.title : root.modelData.tooltipTitle;
            TooltipProvider.show(root, tooltipText);
        }
        onExited: {
            TooltipProvider.hide();
        }
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                parent.modelData.activate();
            } else if (mouse.button === Qt.RightButton && parent.modelData.hasMenu) {
                const posX = root.screen.width - parent.menuX;
                parent.modelData.display(root.panel, posX, 10);
                // root.panel.open(parent.modelData, parent.menuX, 10);
            }
        }
    }

    IconImage {
        id: trayIcon
        anchors.fill: parent

        asynchronous: true
        backer.fillMode: Image.PreserveAspectFit
        source: {
            let icon = parent.modelData?.icon || "";
            if (!icon) {
                return "";
            }

            // Process icon path
            if (icon.includes("?path=")) {
                const chunks = icon.split("?path=");
                const name = chunks[0];
                const path = chunks[1];
                const fileName = name.substring(name.lastIndexOf("/") + 1);
                return `file://${path}/${fileName}`;
            }
            return icon;
        }
    }
}
