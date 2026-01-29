pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs.config

Singleton {
    id: root

    property string icon: Constants.iconPath + "keyboard-box-fill.svg"
    property string label
    property var layouts: {
        "English (US)": "US",
        "Spanish (Latin American)": "ES"
    }

    property var compositors: {
        "hyprland": {
            "status": "hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | first(.active_keymap)'",
            "next": "hyprctl switchxkblayout main next"
        },
        "niri": {
            "status": "niri msg -j keyboard-layouts | jq -r '.names[.current_idx]'",
            "next": "niri msg action switch-layout next"
        }
    }

    readonly property var commands: {
        "status": root.compositors[System.compositor].status,
        "next": root.compositors[System.compositor].next
    }

    Process {
        id: statusProc
        command: ["sh", "-c", root.commands.status]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const output = this.text.trim();
                if (output in root.layouts) {
                    root.label = root.layouts[output];
                } else {
                    root.icon = "";
                    root.label = "N/A";
                }
            }
        }
    }

    function updateLabel(): void {
        statusProc.running = true;
    }

    IpcHandler {
        target: "kblayout"

        function updateLabel(): void {
            root.updateLabel();
        }
    }

    Connections {
        target: Niri
        function onLayoutChange() {
            root.updateLabel();
        }
    }
}
