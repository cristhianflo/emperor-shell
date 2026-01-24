pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Pipewire

Singleton {
    id: root

    property bool ready: Pipewire.defaultAudioSink?.ready ?? false
    property PwNode sink: Pipewire.defaultAudioSink
    property PwNode source: Pipewire.defaultAudioSource
    property int volume

    PwObjectTracker {
        objects: [root.sink, root.source]
    }

    Connections {
        target: root.sink?.audio ?? null
        function onVolumeChanged() {
            root.volume = Math.floor(root.sink.audio.volume * 100);
        }
    }

    Component.onCompleted: {
        if (root.sink?.ready) {
            root.volume = Math.floor(root.sink.audio.volume * 100);
        }
    }
}
