pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root

    property list<string> _themes
    property Theme theme
    property string _defaultTheme: "ArkDark"

    function getColor(name) {
        const baseColor = theme.colorPalette[name];

        return {
            value: Qt.color(baseColor),
            alpha(a){
                const c = this.value;
                return Qt.rgba(c.r, c.g, c.b, a);
            },
            lighten(amount){
                const c = this.value;
                return Qt.lighter(c, amount);
            },
            darken(amount){
                const c = this.value;
                return Qt.darker(c, amount);
            },
            toString(){
                return this.value;
            }
        };
    }

    function getMargin() {
        return theme.margin;
    }

    function getTitleFont() {
        return theme.titleFont;
    }

    function getBodyFont() {
        return theme.bodyFont;
    }

    function getIconFont() {
        return theme.iconFont;
    }

    function getRadius() {
        return theme.radius;
    }

    function getSpacing() {
        return theme.spacing
    }

    // Load theme dynamically
    function loadTheme(name) {
        let path = Qt.resolvedUrl(`./styles/${name}.qml`);
        let component = Qt.createComponent(path);

        if (component.status === Component.Error) {
            console.error(`Theme load failed: ${component.errorString()}`);
            return;
        }

        let instance = component.createObject(root);
        if (!instance) {
            console.error(`Failed to instantiate theme: ${name}`);
            return;
        }

        // Destroy previous theme if any
        if (root.theme)
            root.theme.destroy();

        root.theme = instance;
        console.log(`Theme loaded: ${name}`);
    }

    Component.onCompleted: {
        loadTheme(_defaultTheme);
    }
}
