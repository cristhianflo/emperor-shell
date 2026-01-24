pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

// All the logic was copied from: https://github.com/end-4/dots-hyprland

Singleton {
    id: root
    property double memoryTotal: 0
    property double memoryFree: 0
    property double memoryUsed: memoryTotal - memoryFree
    property double memoryUsedPercentage: memoryUsed / memoryTotal
    property double swapTotal: 0
    property double swapFree: 0
    property double swapUsed: swapTotal - swapFree
    property double swapUsedPercentage: swapTotal > 0 ? (swapUsed / swapTotal) : 0
    property double cpuUsage: 0
    property var previousCpuStats

    function setMemInfo() {
        fileMeminfo.reload();
        const textMeminfo = fileMeminfo.text();
        memoryTotal = Number(textMeminfo.match(/MemTotal: *(\d+)/)?.[1] ?? 1);
        memoryFree = Number(textMeminfo.match(/MemAvailable: *(\d+)/)?.[1] ?? 0);
        swapTotal = Number(textMeminfo.match(/SwapTotal: *(\d+)/)?.[1] ?? 1);
        swapFree = Number(textMeminfo.match(/SwapFree: *(\d+)/)?.[1] ?? 0);
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

    function formatCpuUsage() {
        return parseInt(cpuUsage * 100) + "%";
    }

    function formatMemoryUsage() {
        return parseInt(memoryUsedPercentage * 100) + "%";
    }

    function formatMemoryAmount(kib) {
        const units = ["KiB", "MiB", "GiB", "TiB"];
        let size = kib;
        let unitIndex = 0;
        while (size >= 1024 && unitIndex < units.length - 1) {
            size /= 1024;
            unitIndex++;
        }
        return `${size.toFixed(1)}${units[unitIndex]}`;
    }

    function formatUsedMemoryAmount() {
        return formatMemoryAmount(memoryUsed);
    }

    function formatTotalMemoryAmount() {
        return formatMemoryAmount(memoryTotal);
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            root.setMemInfo();
            root.setCpuStats();
        }
    }

    FileView {
        id: fileMeminfo
        path: "/proc/meminfo"
    }
    FileView {
        id: fileStat
        path: "/proc/stat"
    }
}
