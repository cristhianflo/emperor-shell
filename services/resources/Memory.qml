pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

import ".."

// All the logic was copied from: https://github.com/end-4/dots-hyprland

ServiceBase {
    id: root
    property double memoryTotal: 0
    property double memoryFree: 0
    property double memoryUsed: memoryTotal - memoryFree
    property double memoryUsedPercentage: memoryUsed / memoryTotal
    property double swapTotal: 0
    property double swapFree: 0
    property double swapUsed: swapTotal - swapFree
    property double swapUsedPercentage: swapTotal > 0 ? (swapUsed / swapTotal) : 0

    activeIcon: () => root.iconPath + "ram-2-fill.svg"
    activeLabel: () => {
        return parseInt(memoryUsedPercentage * 100) + "%";
    }

    function setMemInfo() {
        fileMeminfo.reload();
        const textMeminfo = fileMeminfo.text();
        memoryTotal = Number(textMeminfo.match(/MemTotal: *(\d+)/)?.[1] ?? 1);
        memoryFree = Number(textMeminfo.match(/MemAvailable: *(\d+)/)?.[1] ?? 0);
        swapTotal = Number(textMeminfo.match(/SwapTotal: *(\d+)/)?.[1] ?? 1);
        swapFree = Number(textMeminfo.match(/SwapFree: *(\d+)/)?.[1] ?? 0);
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
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            root.setMemInfo();
        }
    }

    FileView {
        id: fileMeminfo
        path: "/proc/meminfo"
    }

    Component.onCompleted: {
        root.setMemInfo();
    }
}
