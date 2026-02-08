pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import ".."

ServiceBase {
    // -------------------------------------------------------------------------
    // Config
    // -------------------------------------------------------------------------
    id: root
    activeIcon: () => root.periodIcons[body.period] || root.periodIcons["static"]
    activeLabel: () => body.current_temp + "K"
    property int _dayTemp: 6500
    property int _nightTemp: 3300

    // -------------------------------------------------------------------------
    // Public API
    // -------------------------------------------------------------------------
    property SunsetrSocketBody body: SunsetrSocketBody {}

    // Toggle command
    property string toggleCommand: `sunsetr set static_temp=${body.current_temp == root._nightTemp ? root._dayTemp : root._nightTemp}`

    readonly property var periodIcons: {
        "day": root.iconPath + "sun-fill.svg",
        "night": root.iconPath + "moon-fill.svg",
        "sunset": root.iconPath + "sun-foggy-fill.svg",
        "sunrise": root.iconPath + "haze-fill.svg",
        "static": root.iconPath + "temp-hot-line.svg"
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
                        root.body.period = event.period;
                        root.body.current_temp = event.current_temp;
                        root.body.current_gamma = event.current_gamma / 100.0;
                        root.body.active_preset = event.active_preset;
                        root.body.state = event.state;
                        root.body.progress = event.progress ?? 0;
                    } else if (event.event_type === "period_changed") {
                        root.body.period = event.to_period || event.period;
                    } else if (event.event_type === "preset_changed") {
                        root.body.active_preset = event.to_preset || "default";
                        root.body.period = event.target_period;
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
        if (!root.isReady)
            return;

        CommandRunner.exec(["sunsetr", "set", `static_temp=${root.body.current_temp == root._nightTemp ? root._dayTemp : root._nightTemp}`]);
    }
}
