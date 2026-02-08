pragma Singleton
import Quickshell
import QtQuick

ServiceBase {
    id: root
    activeIcon: () => root.iconPath + "shutdown-line.svg"
    activeLabel: () => ""
}
