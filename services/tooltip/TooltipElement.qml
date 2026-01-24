pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Widgets
import QtQuick.Effects
import qs.services.theme

PopupWindow {
    id: root
    color: "transparent"
    required property var parentItem
    property string text: ""

    anchor.item: root.parentItem
    anchor.rect.x: root.parentItem.width / 2 - width / 2
    anchor.rect.y: root.parentItem.height

    RectangularShadow {
        anchors.centerIn: parent
        width: root.width - tooltipWrapper.margin * 3
        height: root.height - tooltipWrapper.margin * 2
        blur: 20
        spread: 4
        z: 0
    }

    WrapperRectangle {
        id: tooltipWrapper

        anchors.centerIn: parent
        margin: ThemeProvider.getMargin()
        radius: ThemeProvider.getRadius()

        color: ThemeProvider.getColor("floating").value
        z: 1

        Text {
            id: tooltipText
            text: root.text
            color: ThemeProvider.getColor("floatingForeground").value
            font.family: ThemeProvider.getBodyFont()
            font.bold: true
            font.pixelSize: 14
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    implicitWidth: tooltipWrapper.implicitWidth + tooltipWrapper.margin * 1
    implicitHeight: tooltipWrapper.implicitHeight + tooltipWrapper.margin * 0.5
}
