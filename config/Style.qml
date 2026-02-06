pragma Singleton
import QtQuick
import Quickshell

Singleton {
    readonly property QtObject fontSize: QtObject {
        property real xs: 9
        property real sm: 11
        property real md: 13
        property real lg: 16
        property real xl: 18
        property real xxl: 20
        property real xxxl: 24
    }

    readonly property QtObject fontWeight: QtObject {
        property real light: Font.Light
        property real normal: Font.Normal
        property real bold: Font.Bold
        property real black: Font.Black
    }

    readonly property QtObject radius: QtObject {
        property real sm: 4
        property real md: 8
        property real lg: 12
        property real xl: 16
    }

    readonly property QtObject border: QtObject {
        property real thin: 1
        property real medium: 2
        property real thick: 4
    }

    readonly property QtObject margin: QtObject {
        property real xs: 3
        property real sm: 6
        property real md: 9
        property real lg: 12
        property real xl: 15
    }

    readonly property QtObject opacity: QtObject {
        property real none: 0.0
        property real light: 0.25
        property real medium: 0.5
        property real high: 0.75
        property real full: 1.0
    }

    readonly property real barHeight: 34
}
