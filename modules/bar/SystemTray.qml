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

    color: ThemeProvider.getColor("card").alpha(0.6)
    border.color: ThemeProvider.getColor("border").alpha(0.6)
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
