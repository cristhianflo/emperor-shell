import QtQuick
import qs.services
import qs.services.resources
import qs.services.kblayout
import qs.services.networking
import qs.services.sunsetr

QtObject {
    property list<ModuleConfig> leftModules: [
        ModuleConfig {
            icon: PowerManager.icon
            tooltip: "Open powermenu"
            leftAction: "arklinux-powermenu"
        },
        ModuleConfig {
            content: Cpu.label
            icon: Cpu.icon
            fixedWidth: 64
            tooltip: "Total: " + Cpu.label
        },
        ModuleConfig {
            content: Memory.label
            icon: Memory.icon
            fixedWidth: 64
            tooltip: Memory.formatUsedMemoryAmount() + " used"
        },
        ModuleConfig {
            content: KeyboardLayout.label
            icon: KeyboardLayout.icon
            tooltip: "Change keyboard layout"
            leftAction: KeyboardLayout.loadedCompositor.nextCommand
        },
        ModuleConfig {
            content: Sunsetr.label
            icon: Sunsetr.icon
            tooltip: "Toggle blue light filter"
            leftAction: Sunsetr.toggleCommand
        }
    ]

    property list<ModuleConfig> centerModules: []

    property list<ModuleConfig> rightModules: [
        ModuleConfig {
            content: NetworkManager.traffic.down
            icon: NetworkManager.traffic.downIcon
            fixedWidth: 96
        },
        ModuleConfig {
            content: Audio.label
            icon: Audio.icon
            tooltip: "Right click to open pavucontrol"
            rightAction: "pavucontrol"
        },
        ModuleConfig {
            content: Time.time
            icon: ""
            tooltip: "Right click to open Gnome Calendar"
            rightAction: "gnome-calendar"
        }
    ]
}
