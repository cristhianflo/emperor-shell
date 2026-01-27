import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    required property string serviceName
    required property string serviceLabel

    property bool isActive: false
    property bool isLoading: true

    property var disabledIcon: "󰜺"
    property var disabledLabel: "Disabled"

    required property var activeIcon
    required property var activeLabel

    property string icon: !root.isActive ? root.disabledIcon : root.activeIcon()
    property string label: !root.isActive ? root.disabledLabel : root.activeLabel()

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: systemdCheck.running = true
    }

    Process {
        id: systemdCheck
        // Remove "running: true" from here, the timer handles it
        command: ["systemctl", "--user", "is-active", root.serviceName]

        stdout: SplitParser {
            onRead: data => {
                // "active" is the only output we care about for true
                root.isActive = (data.trim() === "active");
                root.isLoading = false;
            }
        }
    }
}
