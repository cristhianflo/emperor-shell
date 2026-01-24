pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string icon
    property string label
    property real defaultTemp: 6500
    property real dayTemp: 6500
    property real nightTemp: 3300
    property string sunEmoji: ""
    property string moonEmoji: ""

    Process {
        id: statusProc
        command: ["bash", "-c", "sunsetr get static_temp"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const output = this.text.trim();
                if (output === "" || output.length < 1) {
                    root.icon = "";
                    root.label = "N/A";
                    return;
                }
                root.icon = parseInt(output) <= (root.defaultTemp + root.nightTemp) / 2 ? root.moonEmoji : root.sunEmoji;
                root.label = root.icon == root.sunEmoji ? "Off" : "On";
            }
        }
    }

    Process {
        id: toggleProc
        command: ["arklinux-bluelight-toggle"]

        onExited: (exitCode, exitStatus) => {
            statusProc.running = true;
        }
    }

    function toggle() {
        toggleProc.exec(toggleProc.command);
    }
}
