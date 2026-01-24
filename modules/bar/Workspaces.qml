pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.services.theme
RowLayout {
    id: root

    property var iconMap: {
        "browser": "",
        "terminal": "",
        "default": ""
    }

    spacing: ThemeProvider.getSpacing()

    Repeater {
        id: counter
        model: Niri.workspaces
        delegate: WorkspaceItem {
            id: wsItem
            icon: root.iconMap[modelData.name ?? "default"]
            index: modelData.idx
        }
    }
}
