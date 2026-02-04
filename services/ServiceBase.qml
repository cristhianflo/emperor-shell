import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

Singleton {
    id: parent

    required property string serviceName
    required property string serviceLabel

    property string _rawStatus: "unknown"
    property bool isActive: _rawStatus === "active"
    property bool isLoading: _rawStatus === "unknown"
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
        command: ["systemctl", "--user", "is-active", parent.serviceName]

        stdout: SplitParser {
            onRead: data => {
                parent._rawStatus = data.trim();
            }
        }
    }
}
