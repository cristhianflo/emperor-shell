//@ pragma UseQApplication
import qs.modules.bar
import QtQuick
import Quickshell

ShellRoot {
    id: root

    property bool enableBar: true

    Loader {
        active: root.enableBar

        sourceComponent: Bar {}
    }
}
