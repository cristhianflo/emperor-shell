import "."

KbCompositor {
    name: "hyprland"
    statusCommand: "hyprctl -j getoption keyboard.layout | jq -r '.value'"
    nextCommand: "hyprctl dispatch workspace nextlayout"
}
