import "."

KbCompositor {
    name: "niri"
    statusCommand: "niri msg -j keyboard-layouts | jq -r '.names[.current_idx]'"
    nextCommand: "niri msg action switch-layout next"
}
