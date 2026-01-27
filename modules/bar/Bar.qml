pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import qs.services
import qs.services.theme
import qs.services.sunsetr

Scope {
    id: bar

    property int height: 34

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: barPanel
            required property ShellScreen modelData
            screen: modelData
            color: ThemeProvider.getColor("background").alpha(0.6)
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
                        icon: ""
                    }
                    tooltipText: "Open powermenu"
                    leftAction: "arklinux-powermenu"
                }
                Card {
                    TextIcon {
                        content: ResourceUsage.formatCpuUsage()
                        icon: ""
                    }
                    fixedWidth: 58
                    tooltipText: "Total: " + ResourceUsage.formatCpuUsage()
                }
                Card {
                    TextIcon {
                        content: ResourceUsage.formatMemoryUsage()
                        icon: ""
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
                        content: NetworkManager.downTraffic
                        icon: "\uef09"
                    }
                    fixedWidth: 96
                }
                Card {
                    TextIcon {
                        content: Audio.volume + "%"
                        icon: "\uf028"
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
