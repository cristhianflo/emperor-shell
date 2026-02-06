pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import qs.services
import qs.services.theme
import qs.services.sunsetr
import qs.services.networking
import qs.config
import "./components/"

Scope {
    id: bar

    property int height: 34

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: barPanel
            required property ShellScreen modelData
            screen: modelData
            color: ThemeProvider.getColor("muted").toString()
            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: bar.height + 6

            BarGroup {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                Card {
                    TextIcon {
                        icon: Constants.iconPath + "shutdown-line.svg"
                    }
                    tooltipText: "Open powermenu"
                    leftAction: "arklinux-powermenu"
                }
                Card {
                    TextIcon {
                        content: Cpu.activeLabel()
                        icon: Cpu.activeIcon()
                    }
                    fixedWidth: 58
                    tooltipText: "Total: " + ResourceUsage.formatCpuUsage()
                }
                Card {
                    TextIcon {
                        content: Memory.activeLabel()
                        icon: Memory.activeIcon()
                    }
                    fixedWidth: 58
                    tooltipText: ResourceUsage.formatUsedMemoryAmount() + " used"
                }
                Card {
                    TextIcon {
                        content: KeyboardLayout.label
                        icon: KeyboardLayout.icon
                    }
                    leftAction: KeyboardLayout.commands.next
                    tooltipText: "Change keyboard language"
                }
                Card {
                    TextIcon {
                        icon: Sunsetr.icon
                        content: Sunsetr.label
                    }
                    tooltipText: "Toggle blue light filter"
                    leftAction: Sunsetr.toggleCommand
                }
            }

            BarGroup {
                anchors.centerIn: parent
                Workspaces {}
            }

            BarGroup {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                Card {
                    TextIcon {
                        content: NetworkManager.traffic.down
                        icon: NetworkManager.traffic.downIcon
                    }
                    fixedWidth: 96
                }
                Card {
                    TextIcon {
                        content: Audio.label
                        icon: Audio.icon
                    }
                    tooltipText: "Right click to open pavucontrol"
                    rightAction: "pavucontrol"
                }
                Card {
                    TextIcon {
                        content: Time.time
                    }
                    tooltipText: "Right click to open Gnome Calendar"
                    rightAction: "gnome-calendar"
                }
                SystemTray {
                    screen: barPanel.modelData
                    panel: barPanel
                }
            }
        }
    }
}
