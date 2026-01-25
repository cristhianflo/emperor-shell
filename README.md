# Emperor Shell

**A modular, high-performance QML shell for Linux power users.**

---

## Overview

Emperor Shell is a next-gen Wayland system shell/status bar built using strict Quickshell 0.2 paradigms:

- **Rooted in QML**: Production-ready, modular, and optimized for responsiveness.
- **Zero UI blocking**: All heavy logic is async, backgrounded, or handled by native DBus services.
- **Absolute theming**: Dynamic theme support via a singleton ThemeProvider.
- **Perfect separation**: All system logic lives in singleton services; UI receives data solely via required properties and binding.
- **Ricing-first**: For users who demand total control and minimal overhead.

## Features

- Minimalist, script-free system bars and modules
- Lightning-fast startup and runtime
- Native DBus/sockets integration for system state (audio, net, battery, etc.)
- Modular QML-based bar, tray, and card widgets
- Fully dynamic theme switching (see `services/theme/ThemeProvider.qml`)
- Extensible architecture: Add and override modules without core changes

## Structure

```
config/                # Static configuration
modules/bar/           # Bar/panel UI modules
services/theme/        # ThemeProvider & QML color palettes
shell.qml              # Entrypoint. Loads Bar, binds UI to services
AGENTS.md              # Architectural/coding standards
LICENSE                # MIT License
```

## Quick Start

1. **Prerequisites:**
   - Install `quickshell` (version 0.2.0 or higher).
   - Ensure a Wayland compositor (Hyprland, Niri, etc.) is running.

2. **Clone:**

   ```sh
   git clone https://github.com/youruser/emperor-shell.git
   cd emperor-shell
   ```

3. **Run:**
   - To start the shell:
     ```sh
     quickshell -c emperor-shell
     ```

4. **Configuration:**
   - Adjust `config/System.qml` and module settings.
   - Modules are located in `modules/bar/`.
   - Custom themes go into `services/theme/styles/`.

## Theming

To add a theme:

- Place your theme QML file in `services/theme/styles/` (e.g., `MyTheme.qml`)
- Update default in `ThemeProvider.qml` or choose dynamically

## Architecture & Coding Standards

This project enforces strict Quickshell 0.2 architecture:

- **Native DBus-first** (never script-poll unless no DBus exists)
- **Singleton services** for state, pure UI components
- **Explicit QML typing**; never use implicit typename `var` in components
- **Asynchronous only** for non-trivial system IO
- **Root-relative imports**. No relative file paths.

See `AGENTS.md` for full architectural/coding guidelines.

## License

MIT. See LICENSE for full terms.

---

**Credits:**

- (c) 2026 Cristhian Flores
- Inspired by the Archlinux, unixporn, and QML/Quickshell ricing communities.

---

**Not affiliated with official Quickshell/QML nor Hypergryph Network Technology Co., Ltd. projects.**
