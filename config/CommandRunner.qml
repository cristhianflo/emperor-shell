pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property Process _proc: Process {
        id: globalProc
        running: false
    }

    function exec(cmd) {
        if (globalProc.running) {
            // Optional: Queue commands or use multiple executors if high frequency
            return;
        }
        globalProc.command = (typeof cmd === 'string') ? cmd.split(" ") : cmd;
        globalProc.running = true;
    }
}
