pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    // an expression can be broken across multiple lines using {}
    readonly property string time: {
        // The passed format string matches the default output of
        // the `date` command.
        // Qt.formatDateTime(clock.date, "hh:mm:ss ap. | dd/mm/yyyy (ddd.)");
        Qt.locale("es_ES.UTF-8").toString(clock.date, "hh:mm ap | dd/MM/yyyy (ddd.)");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
