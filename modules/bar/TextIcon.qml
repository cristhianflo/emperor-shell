import QtQuick.Layouts
import QtQuick
import qs.services.theme

RowLayout {
    id: root
    property string content: ""
    property string icon: ""
    readonly property string textColor: ThemeProvider.getColor("foreground").value
    spacing: ThemeProvider.getSpacing()

    Item {
        visible: content == ""
    }

    Text {
        id: icon
        visible: root.icon !== ""
        text: root.icon
        font.family: ThemeProvider.getIconFont()
        font.pixelSize: 16
        color: root.textColor
        verticalAlignment: Text.AlignVCenter
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
