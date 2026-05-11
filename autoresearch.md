# Autoresearch: StandUp Reminder App

## Objective
Build a research-backed macOS menu bar app that reminds users to move, with customizable exercise library, activity logging, and GUI preferences. Target: frictionless install, works for diverse physical abilities.

## Metrics
- **Primary**: build_time_s (seconds, lower is better) — compilation + bundle creation time
- **Secondary**: binary_size_kb (smaller is better), warning_count (fewer is better)

## How to Run
`./autoresearch.sh` — compiles the app, measures build time, checks warnings, measures binary size.

## Files in Scope
- `Sources/AppDelegate.swift` — app entry point, notification permissions
- `Sources/ReminderEngine.swift` — timer logic, exercise selection, notification delivery
- `Sources/StatusBarController.swift` — menu bar UI
- `Sources/SettingsView.swift` — preferences window
- `Sources/ExerciseLibrary.swift` — exercise definitions, medical research defaults
- `Sources/ActivityLogger.swift` — local JSON logging
- `Sources/Models.swift` — shared data models
- `Resources/Info.plist` — app bundle metadata
- `Makefile` — build system
- `README.md` — documentation

## Off Limits
- Nothing is off limits yet — full rewrite allowed

## Constraints
- Must compile with swiftc (no Xcode project dependency)
- Must run on macOS 14+
- Must be ad-hoc signable
- Zero external dependencies (Apple frameworks only)
- Build must succeed (exit 0)
- Zero warnings

## What's Been Tried
(Will be updated as experiments accumulate)
