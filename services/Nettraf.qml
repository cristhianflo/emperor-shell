pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string downtraf

    Process {
        id: nettrafProc
        command: ["arklinux-nettraf"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.downtraf = this.text
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: nettrafProc.running = true
    }
}
