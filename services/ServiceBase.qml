import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

Singleton {
    id: parent

    required property string serviceName
    required property string serviceLabel

    property bool isActive: false
    property bool isLoading: true
    property bool isReady: !isLoading && isActive

    property string iconPath: Constants.iconPath

    property var disabledIcon: iconPath + "prohibited-line.svg"
    property var disabledLabel: "Disabled"

    required property var activeIcon
    required property var activeLabel

    property string icon: parent.isActive ? parent.activeIcon() : parent.disabledIcon
    property string label: parent.isActive ? parent.activeLabel() : parent.disabledLabel

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
        command: ["systemctl", "--user", "is-active", parent.serviceName]

        stdout: SplitParser {
            onRead: data => {
                // "active" is the only output we care about for true
                parent.isActive = (data.trim() === "active");
                parent.isLoading = false;
            }
        }
    }

    Process {
        id: serviceProcess
    }
}
