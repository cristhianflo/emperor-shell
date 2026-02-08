pragma Singleton

import Quickshell.Io
import QtQuick
import qs.config

import ".."

ServiceBase {
    id: root

    property string _label: "N/A"
    readonly property string _compositor: System.compositor

    readonly property var layouts: {
        "English (US)": "US",
        "Spanish (Latin American)": "ES"
    }
    activeIcon: () => root.iconPath + "keyboard-box-fill.svg"
    activeLabel: () => {
        return root._label;
    }

    readonly property list<KbCompositor> compositors: [
        NiriLayout {},
        HyprlandLayout {}
    ]

    property KbCompositor loadedCompositor

    Process {
        id: statusProc
        command: ["sh", "-c", root.loadedCompositor.statusCommand]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const output = this.text.trim();
                if (output in root.layouts) {
                    root._label = root.layouts[output];
                } else {
                    root.label = "N/A";
                }
            }
        }
    }

    IpcHandler {
        target: "kblayout"

        function updateLabel(): void {
            statusProc.running = true;
        }
    }

    Connections {
        target: Niri
        function onLayoutChange() {
            statusProc.running = true;
        }
    }

    Component.onCompleted: {
        loadedCompositor = root.compositors.find(c => c.name === root._compositor);
    }
}
