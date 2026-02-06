pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

import ".."

// All the logic was copied from: https://github.com/end-4/dots-hyprland

ServiceBase {
    id: root
    property double cpuUsage: 0
    property var previousCpuStats

    activeIcon: () => root.iconPath + "cpu-line.svg"
    activeLabel: () => {
        return parseInt(cpuUsage * 100) + "%";
    }

    function setCpuStats() {
        fileStat.reload();
        const textStat = fileStat.text();
        const cpuLine = textStat.match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/);
        if (cpuLine) {
            const stats = cpuLine.slice(1).map(Number);
            const total = stats.reduce((a, b) => a + b, 0);
            const idle = stats[3];

            if (previousCpuStats) {
                const totalDiff = total - previousCpuStats.total;
                const idleDiff = idle - previousCpuStats.idle;
                cpuUsage = totalDiff > 0 ? (1 - idleDiff / totalDiff) : 0;
            }

            previousCpuStats = {
                total,
                idle
            };
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            root.setCpuStats();
        }
    }

    FileView {
        id: fileStat
        path: "/proc/stat"
    }
}
