pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // -------------------------------------------------------------------------
    // Public API
    // -------------------------------------------------------------------------

    property string connectionName: "Disconnected"
    property int connectivityState: 0 // 0: unknown, 4: full
    property bool isConnected: connectivityState === 4
    property bool isWifi: false
    property int signalStrength: 0
    property string device: ""

    // Traffic Monitoring
    property string downTraffic: "0 B/s"
    property string upTraffic: "0 B/s"

    // -------------------------------------------------------------------------
    // Internal State
    // -------------------------------------------------------------------------

    property double _lastRecv: 0
    property double _lastSent: 0

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
    // Traffic Monitoring Logic
    // -------------------------------------------------------------------------

    FileView {
        id: netDevFile
        path: "/proc/net/dev"
    }

    function _formatSpeed(bytes) {
        if (bytes < 1024)
            return bytes + " B/s";
        const kib = bytes / 1024;
        if (kib < 1024)
            return kib.toFixed(1) + " KiB/s";
        const mib = kib / 1024;
        return mib.toFixed(1) + " MiB/s";
    }

    function updateTraffic() {
        if (!root.device) {
            return;
        }

        netDevFile.reload();
        const content = netDevFile.text();
        if (!content)
            return;

        const lines = content.split("\n");
        const devicePattern = new RegExp(`^\\s*${root.device}:\\s*(\\d+)\\s+\\d+\\s+\\d+\\s+\\d+\\s+\\d+\\s+\\d+\\s+\\d+\\s+\\d+\\s+(\\d+)`);

        for (let i = 0; i < lines.length; i++) {
            const match = lines[i].match(devicePattern);
            if (match) {
                const recv = parseInt(match[1]);
                const sent = parseInt(match[2]);

                if (root._lastRecv > 0) {
                    root.downTraffic = _formatSpeed(recv - root._lastRecv);
                    root.upTraffic = _formatSpeed(sent - root._lastSent);
                }

                root._lastRecv = recv;
                root._lastSent = sent;
                break;
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            root.updateTraffic();
        }
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
