pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.services.theme

WrapperRectangle {
    id: root

    property ShellScreen screen
    property var panel

    color: ThemeProvider.getColor("background").toString()
    border.color: ThemeProvider.getColor("border").toString()

    border.width: 1
    radius: ThemeProvider.getRadius()
    margin: ThemeProvider.getMargin()

    RowLayout {
        id: trayRow
        spacing: ThemeProvider.getSpacing()
        layoutDirection: Qt.RightToLeft

        Repeater {
            id: counter
            model: SystemTray.items
            delegate: TrayItem {
                panel: root.panel
                screen: root.screen
            }
        }
    }
}
