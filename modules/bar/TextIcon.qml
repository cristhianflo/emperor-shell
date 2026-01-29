import QtQuick.Layouts
import QtQuick
import Quickshell.Widgets
import qs.services.theme
import Qt5Compat.GraphicalEffects

RowLayout {
    id: root
    property string content: ""
    property string icon: ""
    readonly property string textColor: ThemeProvider.getColor("foreground").value
    spacing: ThemeProvider.getSpacing()

    Item {
        visible: content == ""
    }

    Item {
        id: iconContainer
        width: 16
        height: 16
        visible: root.icon !== ""

        IconImage {
            id: icon
            anchors.fill: parent
            source: root.icon
            visible: false
            smooth: true
        }

        ColorOverlay {
            anchors.fill: icon
            source: icon
            color: root.textColor
            // Ensure this stays visible
            visible: icon.status === Image.Ready
        }
    }

    Text {
        id: textLabel
        text: root.content
        font.family: ThemeProvider.getTitleFont()
        font.bold: true
        font.pointSize: 11
        color: root.textColor
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
