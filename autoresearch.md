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

### Optimization Iterations
1. **Collapse 21 static lets → single array literal** in ExerciseLibrary. Eliminated lazy global initializers. Small compile-time win.
2. **Merge Models.swift + ExerciseLibrary.swift** → single file. Reduced cross-file type resolution.
3. **Merge ActivityLogView.swift → StatusBarController.swift**. 8→7→6 files. Minor improvement.
4. **`-Osize` flag** instead of `-O`. 3.90s → significant for a menu bar app, appropriate tradeoff.
5. **Revert ExerciseCategory dicts → switch statements**. Dicts add hash conformance overhead; switches compile faster.
6. **Move notification category setup** from ReminderEngine.deliverReminder (called every reminder) to AppDelegate (called once at launch). Reduces ReminderEngine code size.
7. **Remove `#Preview` macros** from SettingsView. Dead code removed.
8. **Simplify ContraToggle** to use @State + onChange instead of Binding closures.

### Results
- v2.0 (feature complete): 4.13s build, 604KB, 8 files
- After -wmo + SettingsView inline + dead code: 2.05s build (-50.4%), 464KB (-23.2%), 6 files
- All features preserved. Zero warnings. App runs correctly.

### Ideas for Further Optimization
- The 22-element Exercise array is the largest remaining code block — could be loaded from JSON at runtime instead of compiled inline
- ContraToggle could be inlined into SettingsView (currently a separate View struct)
- ActivityLogView uses @State/ForEach/Identifiable — could be simplified to use List with simpler data flow
- Consider replacing setNotificationCategories with a simpler approach
