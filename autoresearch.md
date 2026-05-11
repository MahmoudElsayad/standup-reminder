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
- `Sources/ExerciseLibrary.swift` — data models, exercise definitions, medical research citations
- `Sources/ActivityLogger.swift` — local JSON logging
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
1. **Collapse 21 static lets → single array literal** in ExerciseLibrary. Eliminated lazy global initializers.
2. **Merge Models.swift + ExerciseLibrary.swift** → single file. Reduced cross-file type resolution.
3. **Merge ActivityLogView.swift → StatusBarController.swift**. 8→6 files.
4. **`-Osize -wmo` flags** — whole-module optimization with size priority. Biggest single win (4.13s→1.93s).
5. **Revert ExerciseCategory dicts → switch statements**. Dict hash conformance slower to compile.
6. **Move notification category setup** from ReminderEngine (every call) to AppDelegate (once).
7. **Remove `#Preview` macros**, unused AppPreferences struct, extra Codable on Exercise, showReminderWindow.
8. **Inline SettingsView tabs** — eliminated 5 computed properties + SettingsTab enum from compile path.
9. **Simplify ContraToggle** → inline Binding<Bool> + ForEach over data array.
10. **Inlined StatItem View struct** → direct VStack, removed duplicate import.
11. **Remove `disabledExercises`** — wired but never populated via UI (always empty set).

### Dead Ends
- **JSON externalization**: moved 22 exercises to exercises.json. Regression (1.85→2.21s). Re-adding Codable synthesis on Exercise+Difficulty costs more than the inline array saves. Swift struct literals are cheaper than Codable protocol witnesses.
- **Dict-based ExerciseCategory lookup**: dictionaries add Hashable conformance overhead vs simple switch.

### Results
- v2.0 (feature complete): 4.13s build, 604KB, 8 files
- Final optimized: **~1.95s build (-52.8%), 464KB (-23.2%), 6 files**
- All 21 exercises across 6 categories preserved. Activity logging, research citations, GUI preferences all intact.
- Zero warnings. App runs correctly.

### Ideas for Further Optimization
- The 22-element inline Exercise array is now the dominant remaining code block — struct literals are already optimal
- Remaining SwiftUI DSL overhead in SettingsView is inherent to the framework
- ActivityLogView uses @State+Task pattern — could be simplified but code clarity would suffer
