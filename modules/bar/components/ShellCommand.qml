import Quickshell
import QtQuick
import Quickshell.Io

Scope {
    id: root

    property string command: ""

    Process {
        id: shellProc
        command: ["sh", "-c", root.command]
        running: false
    }

    function run() {
        shellProc.running = true;
    }
}
