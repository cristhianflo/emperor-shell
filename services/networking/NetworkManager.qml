pragma Singleton

import QtQuick
import Quickshell.Io
import ".."

ServiceBase {
    // -------------------------------------------------------------------------
    // Config
    // -------------------------------------------------------------------------
    id: root
    activeIcon: () => "\uef09"
    activeLabel: () => ""

    // -------------------------------------------------------------------------
    // Public API
    // -------------------------------------------------------------------------
    property string connectionName: "Disconnected"
    property int connectivityState: 0 // 0: unknown, 4: full
    property bool isConnected: connectivityState === 4
    property bool isWifi: false
    property int signalStrength: 0
    property string device: ""

    property NetworkTraffic traffic: NetworkTraffic {
        device: root.device
        iconPath: root.iconPath
    }

    // -------------------------------------------------------------------------
    // Event-Driven Core (nmcli monitor)
    // -------------------------------------------------------------------------

    Process {
        id: monitorProc
        command: ["nmcli", "monitor"]
        running: true

        onExited: resetTimer.start()

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.split("\n");
                for (let i = 0; i < lines.length; i++) {
                    const line = lines[i].trim();
                    if (line === "")
                        continue;

                    if (line.includes("connectivity:") || line.includes("connected") || line.includes("disconnected")) {
                        root._refreshState();
                    }
                }
            }
        }
    }

    Timer {
        id: resetTimer
        interval: 1000
        repeat: false
        onTriggered: monitorProc.running = true
    }

    // -------------------------------------------------------------------------
    // State Fetcher (One-Shot)
    // -------------------------------------------------------------------------

    Process {
        id: stateFetcher
        command: ["nmcli", "-t", "-f", "TYPE,NAME,STATE,DEVICE", "connection", "show", "--active"]

        stdout: StdioCollector {

            onStreamFinished: {
                const output = this.text.trim();

                let currentLine = "";
                for (let line of output.split("\n")) {
                    if (!line.includes(":bridge:") && !line.includes(":loopback:")) {
                        currentLine = line;
                        break;
                    }
                }

                if (!currentLine) {
                    root.connectionName = "Disconnected";
                    root.connectivityState = 0;
                    root.signalStrength = 0;
                    root.device = "";
                    return;
                }

                const parts = currentLine.split(":");
                if (parts.length >= 4) {
                    root.isWifi = parts[0] === "802-11-wireless";
                    root.connectionName = parts[1];
                    root.connectivityState = (parts[2] === "activated") ? 4 : 2;
                    root.device = parts[3];

                    if (root.isWifi) {
                        root._fetchWifiSignal();
                    } else {
                        root.signalStrength = 100;
                    }
                }
            }
        }
    }

    Process {
        id: wifiSignalFetcher
        command: ["nmcli", "-t", "-f", "IN-USE,SIGNAL", "dev", "wifi"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.trim().split("\n");
                for (let i = 0; i < lines.length; i++) {
                    if (lines[i].startsWith("*")) {
                        root.signalStrength = parseInt(lines[i].split(":")[1]) || 0;
                        break;
                    }
                }
            }
        }
    }

    function _fetchWifiSignal() {
        wifiSignalFetcher.running = false;
        wifiSignalFetcher.running = true;
    }

    function _refreshState() {
        stateFetcher.running = false;
        stateFetcher.running = true;
    }

    // -------------------------------------------------------------------------
    // Signal Poller (Lazy)
    // -------------------------------------------------------------------------

    Timer {
        interval: 5000
        running: root.isConnected && root.isWifi
        repeat: true
        onTriggered: root._refreshState()
    }

    Component.onCompleted: _refreshState()
}
