import QtQuick

QtObject {
    id: root

    // Base colors
    required property color background
    required property color foreground

    // Muted base colors
    required property color muted
    required property color mutedForeground

    // UI elements
    required property color card
    required property color cardForeground
    required property color floating
    required property color floatingForeground

    // Primary colors
    required property color primary
    required property color primaryForeground

    // Secondary colors
    required property color secondary
    required property color secondaryForeground

    // Accent colors
    required property color accent
    required property color accentForeground

    // Destructive
    required property color destructive
    required property color destructiveForeground

    // Other
    required property color border
}
