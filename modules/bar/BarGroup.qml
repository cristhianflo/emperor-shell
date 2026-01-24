import QtQuick
import QtQuick.Layouts
import qs.services.theme

Item {
    id: root
    property int margin: ThemeProvider.getMargin()
    default property alias items: groupRow.children

    implicitWidth: groupRow.implicitWidth + margin * 2
    implicitHeight: 32

    RowLayout {
        id: groupRow
        anchors.fill: parent
        anchors.leftMargin: root.margin
        anchors.rightMargin: root.margin
        spacing: ThemeProvider.getSpacing()
    }
}
