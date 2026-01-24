import QtQuick

QtObject {
    id: root

    // Color scheme
    required property ColorPalette colorPalette

    // Spacing and layout
    required property int radius
    required property int spacing
    required property int margin

    // Typography
    required property string titleFont
    required property string iconFont
    required property string bodyFont
}
