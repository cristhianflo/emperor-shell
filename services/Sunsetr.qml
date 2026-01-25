pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // -------------------------------------------------------------------------
    // Public API
    // -------------------------------------------------------------------------

    property string period: "static"
    property int currentTemp: 6500
    property real currentGamma: 1.0
    property string activePreset: "default"
    property string state: "static"
    property real progress: 0.0

    // Preset Defaults
    property int dayTemp: 6500
    property int nightTemp: 3300

    // UI Helpers
    property string icon: root.periodIcons[root.period] || "󰋙"
    property string label: root.currentTemp + "K"

    // Toggle command
    property string toggleCommand: `sunsetr set static_temp=${root.currentTemp == root.nightTemp ? root.dayTemp : root.nightTemp}`

    readonly property var periodIcons: {
        "day": "󰖨",
        "night": "",
        "sunset": "󰖛",
        "sunrise": "󰖜",
        "static": "󰋙"
    }

    // -------------------------------------------------------------------------
    // IPC Integration
    // -------------------------------------------------------------------------

    Socket {
        id: sunsetrSocket
        // $XDG_RUNTIME_DIR/sunsetr-events.sock
        path: Quickshell.env("XDG_RUNTIME_DIR") + "/sunsetr-events.sock"
        connected: true

        parser: SplitParser {
            onRead: data => {
                try {
                    const event = JSON.parse(data);

                    if (event.event_type === "state_applied") {
                        root.period = event.period;
                        root.currentTemp = event.current_temp;
                        root.currentGamma = event.current_gamma / 100.0;
                        root.activePreset = event.active_preset;
                        root.state = event.state;
                        root.progress = event.progress;
                    } else if (event.event_type === "period_changed") {
                        root.period = event.to_period || event.period;
                    } else if (event.event_type === "preset_changed") {
                        root.activePreset = event.to_preset || "default";
                        root.period = event.target_period;
                    }
                } catch (e) {
                    console.warn("Sunsetr IPC Error:", e, "Data:", data);
                }
            }
        }

        onConnectionStateChanged: {
            if (connected) {
                console.log("Sunsetr IPC Connected");
            }
        }
    }

    function toggle(): void {
        _sunsetrProc.exec({
            command: ["sunsetr", "set", `static_temp=${root.currentTemp == root.nightTemp ? root.dayTemp : root.nightTemp}`]
        });
    }

    Process {
        id: _sunsetrProc
    }
}
