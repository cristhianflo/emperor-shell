import Quickshell
import QtQuick
import Quickshell.Io
import qs.config

Scope {
    // -------------------------------------------------------------------------
    // Traffic Monitoring
    // -------------------------------------------------------------------------
    id: root
    required property string device

    // -------------------------------------------------------------------------
    // Traffic Monitoring
    // -------------------------------------------------------------------------
    property string downIcon: Constants.iconPath + "download-cloud-fill.svg"
    property string down: "0 B/s"
    property string upIcon: Constants.iconPath + "upload-cloud-fill.svg"
    property string up: "0 B/s"

    // -------------------------------------------------------------------------
    // Internal State
    // -------------------------------------------------------------------------
    property double _lastRecv: 0
    property double _lastSent: 0
    property var _units: ["B/s", "KiB/s", "MiB/s", "GiB/s"]

    FileView {
        id: netDevFile
        path: "/proc/net/dev"
    }

    function _formatSpeed(bytes) {
        let unitIndex = 0;

        // Keep dividing by 1024 until the number is small enough
        // or we run out of units
        while (bytes >= 1024 && unitIndex < _units.length - 1) {
            bytes /= 1024;
            unitIndex++;
        }

        // Use .toFixed(1) to keep the UI clean, or | 0 for a whole integer
        return Math.floor(bytes) + " " + _units[unitIndex];
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
                    root.down = _formatSpeed(recv - root._lastRecv);
                    root.up = _formatSpeed(sent - root._lastSent);
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
}
