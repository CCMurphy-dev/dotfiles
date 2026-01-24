# Aegis Configuration Options

Edit `config.json` in this directory. Changes are applied automatically.

Only include settings you want to change - defaults are used for anything not specified.

---

## App Switcher

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `appSwitcherEnabled` | bool | `true` | Enable custom Cmd+Tab app switcher |
| `appSwitcherCmdScrollEnabled` | bool | `false` | Enable Cmd+scroll to open/cycle app switcher |
| `appSwitcherShowMinimized` | bool | `true` | Show minimized windows in switcher |
| `appSwitcherShowHidden` | bool | `false` | Show hidden windows in switcher |

---

## Notch HUD - Bluetooth Devices

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `showDeviceHUD` | bool | `true` | Show HUD when Bluetooth devices connect/disconnect |
| `deviceHUDAutoHideDelay` | number | `3.0` | Seconds before HUD auto-hides |
| `excludedBluetoothDevices` | [string] | `["watch"]` | Device names to ignore (case-insensitive substring match) |

---

## Notch HUD - Now Playing

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `showMusicHUD` | bool | `true` | Show Now Playing HUD when music plays |
| `musicHUDRightPanelMode` | string | `"visualizer"` | Right panel content: `"visualizer"` or `"trackInfo"` |
| `musicHUDAutoHide` | bool | `false` | Auto-hide after showing track info |
| `musicHUDAutoHideDelay` | number | `5.0` | Seconds before auto-hide (if enabled) |

---

## Notch HUD - Focus Mode

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `showFocusHUD` | bool | `true` | Show HUD when Focus mode changes |
| `focusHUDAutoHideDelay` | number | `2.0` | Seconds before HUD auto-hides |

---

## Notch HUD - Notifications

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `showNotificationHUD` | bool | `true` | Show system notifications in notch HUD |
| `notificationHUDAutoHide` | bool | `true` | Auto-hide notification HUD after delay |
| `notificationHUDAutoHideDelay` | number | `8.0` | Seconds before HUD auto-hides |
| `notificationExcludedApps` | [string] | See below | Bundle IDs or app names to exclude |

**Default notificationExcludedApps:**
```json
["com.apple.controlcenter", "com.apple.donotdisturbd", "com.apple.FocusSettings"]
```

Notifications from these apps are silently ignored. Use bundle IDs (e.g., `"com.apple.mail"`) or partial app name matches (e.g., `"Slack"`).

---

## Menu Bar

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `maxAppIconsPerSpace` | int | `3` | Max window icons per space before overflow menu |
| `excludedApps` | [string] | `["Finder", "Aegis"]` | Apps to hide from space indicators |
| `showAppNameInExpansion` | bool | `false` | Show app name below window title when expanded |
| `useSwipeToDestroySpace` | bool | `true` | Enable swipe-up gesture to destroy spaces |

---

## Behavior

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `launchAtLogin` | bool | `true` | Start Aegis when macOS starts |
| `enableLayoutActionHaptics` | bool | `true` | Haptic feedback on layout actions |
| `windowIconExpansionAutoCollapseDelay` | number | `2.0` | Seconds before expanded window collapses |

---

## Interaction Thresholds

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `dragDistanceThreshold` | number | `3` | Pixels before drag starts |
| `swipeDestroyThreshold` | number | `-120` | Swipe distance to destroy space |
| `scrollActionThreshold` | number | `3` | Scroll amount for action selection |

---

## Animation Timings

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `stateTransitionDuration` | number | `0.25` | Duration for state changes |
| `notchHUDFadeInDuration` | number | `0.2` | HUD fade-in duration |
| `notchHUDFadeOutDuration` | number | `0.3` | HUD fade-out duration |

---

## Visual Customization

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `activeSpaceBgOpacity` | number | `0.18` | Background opacity for active space |
| `hoveredSpaceBgOpacity` | number | `0.15` | Background opacity for hovered space |
| `inactiveSpaceBgOpacity` | number | `0.12` | Background opacity for inactive space |

---

## System Status

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `dateFormat` | string | `"long"` | Date format: `"long"` (Mon Jan 13) or `"short"` (13/01/26) |
| `showFocusName` | bool | `false` | Show Focus mode name alongside symbol |

---

## Export Full Config

To see all current values, you can export the full config by adding this to a Swift file or running in Xcode console:

```swift
AegisConfig.shared.saveToJSONFile()
```

This will overwrite `config.json` with all settings and their current values.