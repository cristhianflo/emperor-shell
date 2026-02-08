pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import qs.services
import qs.services.theme
import qs.services.sunsetr
import qs.services.networking
import qs.services.resources
import qs.services.kblayout
import qs.config
import "./components/"

Scope {
    id: bar

    property int height: Style.barHeight

    property BarConfig config: BarConfig {}

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

            implicitHeight: bar.height + Style.margin.sm

            BarGroup {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                Repeater {
                    model: bar.config.leftModules
                    delegate: Card {
                        required property var modelData
                        TextIcon {
                            icon: modelData.icon ?? ""
                            content: modelData.content ?? ""
                        }
                        fixedWidth: modelData.fixedWidth ?? 0
                        tooltipText: modelData.tooltip ?? ""
                        leftAction: modelData.leftAction ?? ""
                        rightAction: modelData.rightAction ?? ""
                    }
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
                Repeater {
                    model: bar.config.rightModules
                    delegate: Card {
                        required property var modelData
                        TextIcon {
                            icon: modelData.icon ?? ""
                            content: modelData.content ?? ""
                        }
                        fixedWidth: modelData.fixedWidth ?? 0
                        tooltipText: modelData.tooltip ?? ""
                        leftAction: modelData.leftAction ?? ""
                        rightAction: modelData.rightAction ?? ""
                    }
                }
                SystemTray {
                    screen: barPanel.modelData
                    panel: barPanel
                }
            }
        }
    }
}
