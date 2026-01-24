pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    // Detect compositor/WM
    readonly property string compositor: {
        if (Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") != null)
            return "hyprland";
        if (Quickshell.env("NIRI_SOCKET") != null)
            return "niri";
        if (Quickshell.env("XDG_CURRENT_DESKTOP") != null)
            return Quickshell.env("XDG_CURRENT_DESKTOP").toLowerCase();
        if (Quickshell.env("XDG_SESSION_DESKTOP") != null)
            return Quickshell.env("XDG_SESSION_DESKTOP").toLowerCase();
        return "unknown";
    }

    readonly property string niriSocket: {
        if (root.isNiri()) {
            return Quickshell.env("NIRI_SOCKET");
        } else {
            return null;
        }
    }

    function isHyprland() {
        return compositor === "hyprland";
    }
    function isNiri() {
        return compositor === "niri";
    }
}
