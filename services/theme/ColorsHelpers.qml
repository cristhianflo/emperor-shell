pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    function rgba(r: int, g: int, b: int, a = 1) {
        return Qt.rgba(r / 255, g / 255, b / 255, a);
    }

    function transparency(hexcode: string, a = 1) {
        const color = Qt.color(hexcode);

        return Qt.rgba(color.r, color.g, color.b, a);
    }
}
