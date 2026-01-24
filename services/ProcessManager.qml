pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property Process shell: shellProc

    Process {
        id: shellProc
        running: false
    }

    function runCommand(command) {
        shell.exec({
            command: ["sh", "-c", command]
        });
    }
}
