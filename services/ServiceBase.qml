import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

Singleton {
    id: root

    property string iconPath: Constants.iconPath

    required property var activeIcon
    required property var activeLabel

    property string icon: root.activeIcon()
    property string label: root.activeLabel()
}
