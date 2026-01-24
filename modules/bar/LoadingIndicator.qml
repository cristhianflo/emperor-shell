import QtQuick
import QtQuick.Controls
import qs.services.theme
import qs.services

Item {
    id: root
    property bool busy: ProcessManager.busy

    implicitWidth: indicator.implicitWidth
    implicitHeight: indicator.implicitHeight

    BusyIndicator {
        id: indicator
        anchors.centerIn: parent
        running: root.busy
        visible: root.busy
        width: 34
        height: 34
    }

    // Optional idle indicator
    Text {
        anchors.centerIn: parent
        text: ""
        font.pixelSize: 22
        color: ThemeProvider.getColor("foreground").value
        visible: !root.busy
        opacity: 0.6
    }
}
