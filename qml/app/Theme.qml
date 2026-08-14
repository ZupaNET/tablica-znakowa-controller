pragma Singleton

// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

import QtQuick
import Prezenter

QtObject {

    // Background

    readonly property color appBackground: AppSettings.darkMode ? "#242424" : "#474747"
    readonly property color background: AppSettings.darkMode ? "#121212" : "#f3f5f7"
    readonly property color surface: AppSettings.darkMode ? "#1e1e1e" : "#ffffff"
    readonly property color header: AppSettings.darkMode ? "#242424" : "#474747"
    readonly property color footer: AppSettings.darkMode ? "#1b1b1b" : "#e5e7ea"
    readonly property color panel: AppSettings.darkMode ? "#242424" : "#cfcfcf"
    readonly property color popup: AppSettings.darkMode ? "#2b2b2b" : "#323232"
    readonly property color dimBackground: AppSettings.darkMode ? "#B0000000" : "#66000000"

    // Borders & separators

    readonly property color divider: AppSettings.darkMode ? "#383838" : "#d0d0d0"
    readonly property color separator: divider

    readonly property color surfaceBorder: AppSettings.darkMode ? "#3a3a3a" : "#dddddd"
    readonly property color cardBorder: surfaceBorder
    readonly property color tileBorder: AppSettings.darkMode ? "#444444" : "#d0d0d0"
    readonly property color panelBorder: AppSettings.darkMode ? "#3d3d3d" : "#cccccc"
    readonly property color editorBorder: surfaceBorder
    readonly property color listItemBorder: AppSettings.darkMode ? "#444444" : "#d0d0d0"
    readonly property color dangerBorder: AppSettings.darkMode ? "#c45a5a" : "#ef9a9a"

    // Text

    readonly property color textPrimary: AppSettings.darkMode ? "#ffffff" : "#222222"
    readonly property color text: textPrimary

    readonly property color textSecondary: AppSettings.darkMode ? "#bbbbbb" : "#666666"
    readonly property color textMuted: AppSettings.darkMode ? "#909090" : "#777777"
    readonly property color headerSecondaryText: AppSettings.darkMode ? "#aaaaaa" : "#cccccc"
    readonly property color cardText: AppSettings.darkMode ? "#eeeeee" : "#595959"

    // Accent

    readonly property color accent: AppSettings.darkMode ? "#90caf9" : "#1976d2"
    readonly property color danger: AppSettings.darkMode ? "#ff6b6b" : "#d32f2f"

    // Generic states

    readonly property color selected: AppSettings.darkMode ? "#29435c" : "#d7ecff"
    readonly property color surfaceHover: AppSettings.darkMode ? "#2f2f2f" : "#e8f3ff"
    readonly property color dangerSurface: AppSettings.darkMode ? "#3a2323" : "#fff1f1"

    // Cards & tiles

    readonly property color card: surface
    readonly property color tile: surface
    readonly property color setCard: AppSettings.darkMode ? "#1e1e1e" : "#d7d7d7"

    readonly property color cardDisabled: AppSettings.darkMode ? "#3a3a3a" : "#aaaaaa"
    readonly property color cardPressed: AppSettings.darkMode ? "#333333" : "#cacaca"
    readonly property color cardSelected: AppSettings.darkMode ? "#204a75" : "#d0e6ff"
    readonly property color cardCurrent: AppSettings.darkMode ? "#665f20" : "#ffffb3"
    readonly property color cardSelectedBorder: AppSettings.darkMode ? "#4da3ff" : "#3399ff"

    // Lists

    readonly property color item: AppSettings.darkMode ? "#252525" : "#f4f4f4"
    readonly property color inactiveItem: item

    readonly property color listItem: item
    readonly property color listItemLighter: AppSettings.darkMode ? "#5a5a5a" : "#f4f4f4"
    readonly property color listItemSelected: AppSettings.darkMode ? "#204a75" : "#d7ecff"
    readonly property color listItemDrag: AppSettings.darkMode ? "#383838" : "#e5e5e5"
    readonly property color listItemSelectedDrag: AppSettings.darkMode ? "#285d8f" : "#c4e2ff"
    readonly property color listItemReorderDisabled: AppSettings.darkMode ? "#303030" : "#ebebeb"
    readonly property color listItemSelectedReorderDisabled: AppSettings.darkMode ? "#273b4d" : "#e0eaf2"
    readonly property color listItemDropIndicator: listItemSelected

    readonly property color inactiveBorder: AppSettings.darkMode ? "#444444" : "#d0d0d0"

    // Success

    readonly property color successBackground: AppSettings.darkMode ? "#1b3320" : "#e8f5e9"
    readonly property color successBorder: AppSettings.darkMode ? "#4caf70" : "#81c784"
    readonly property color badgeActive: AppSettings.darkMode ? "#388e3c" : "#4caf50"
    readonly property color badgeInactive: AppSettings.darkMode ? "#666666" : "#9e9e9e"

    // Misc

    readonly property color scrollbar: AppSettings.darkMode ? "#666666" : "#888888"
}