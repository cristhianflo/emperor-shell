pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
    id: root

    property var parentItem: null
    property string text: ""
    property int delay: 300

    LazyLoader {
        id: tooltipLoader

        loading: true

        TooltipElement {
            id: tooltip
            parentItem: root.parentItem
            text: root.text
        }
    }

    Timer {
        id: showTimer
        interval: root.delay
        repeat: false
        onTriggered: tooltipLoader.item.visible = true
    }

    Timer {
        id: hideTimer
        interval: 0
        repeat: false
        onTriggered: tooltipLoader.item.visible = false
    }

    function show(parentItem, text) {
        if (!text || !parentItem)
            return;
        root.text = text;
        root.parentItem = parentItem;
        showTimer.restart();
    }

    function hide() {
        showTimer.stop();
        hideTimer.restart();
    }
}
