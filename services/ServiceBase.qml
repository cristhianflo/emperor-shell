import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    required property string serviceName
    required property string serviceLabel

    property bool isActive: false
    property bool isLoading: true
    property bool isReady: !isLoading && isActive

    property var disabledIcon: "󰜺"
    property var disabledLabel: "Disabled"

    required property var activeIcon
    required property var activeLabel

    property string icon: root.isActive ? root.activeIcon() : root.disabledIcon
    property string label: root.isActive ? root.activeLabel() : root.disabledLabel

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
        command: ["sh", "-c", `systemctl --user is-active --quiet ${root.serviceName} || systemctl is-active --quiet ${root.serviceName} && echo active || echo inactive`]

        stdout: SplitParser {
            onRead: data => {
                // "active" is the only output we care about for true
                root.isActive = (data.trim() === "active");
                root.isLoading = false;
            }
        }
    }
}
