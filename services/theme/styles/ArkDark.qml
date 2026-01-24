import QtQuick
import "../"

Theme {
    id: root

    // Color scheme
    colorPalette: ColorPalette {
        // Base
        background: Qt.color("#313031")
        foreground: "#e4e5e4"

        // Muted base
        muted: "#3d3c3d"
        mutedForeground: "#7f7e7f"

        // UI elements
        card: background
        cardForeground: foreground
        floating: background
        floatingForeground: foreground

        // Primary
        primary: "#158eb5"
        primaryForeground: foreground

        // Secondary
        secondary: "#e6d090"
        secondaryForeground: foreground

        // Accent
        accent: "#564a16"
        accentForeground: foreground

        // Destructive
        destructive: "#F87171"
        destructiveForeground: foreground

        // Other
        border: "#5a5a5a"
    }

    // Spacing and layout
    radius: 0
    spacing: 8
    margin: 6

    // Typography
    titleFont: "Butler Stencil"
    iconFont: "Symbols Nerd Font Mono"
    bodyFont: "Noto Sans"
}
