# StandUp Reminder 🏃💪

**A research-backed macOS menu bar app that reminds you to move, with customizable exercises for all ability levels.**

[![platform](https://img.shields.io/badge/platform-macOS%2014%2B-blue)](https://www.apple.com/macos/)
[![swift](https://img.shields.io/badge/swift-6.1-orange)](https://swift.org)
[![license](https://img.shields.io/badge/license-MIT-green)](LICENSE)

Prolonged sitting is deadly — US adults spend **11–12 hours/day sedentary**. The latest 2025 research shows that **regular movement breaks** are *more effective than a single gym session* at controlling blood sugar, blood pressure, and overall cardiometabolic health.

**StandUp Reminder** helps you implement the evidence-backed "sedentary break" protocol endorsed by the BREAK2 trial and SBAE Consensus Statement (2025).

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🔔 **Dose-calibrated reminders** | Defaults to every 30 min — the BREAK2 trial's efficacy benchmark |
| 🏋️ **21 exercises, 6 categories** | Walking, Standing, Stretching, Bodyweight, Chair, Breathing/Mindfulness |
| ♿ **Accessibility-first** | Exercises filterable by contraindications (knee, hip, back issues, etc.) |
| 📊 **Activity logging** | All completions/skips stored locally as JSON |
| 🔥 **Streak tracking** | See your daily streak and weekly stats |
| 🎛 **Full GUI preferences** | Interval, duration, categories, contraindications, weekly goals |
| 🏥 **Research citations** | Built-in tab with links to the 2025 studies this app is based on |
| 📦 **Zero dependencies** | Apple frameworks only — no npm, no pods, no brew |
| 🚀 **One-command install** | `make launchd-install` for auto-start on login |

## 🏥 Medical Research Behind This App

### BREAK2 Dose-Finding Trial *(Diaz et al., BMC Public Health, 2025)*
The largest-ever dose-finding study (N=324) testing 25 combinations of break frequency (every 30–120 min) and duration (1–10 min). **Every 30 min for 10 min** is the efficacy benchmark. Light walking at 2 mph used as the standard activity.

### SBAE Consensus Statement *(Yin, Li et al., J Sport Health Sci, 2025)*
Short Bouts of Accumulated Exercise (≤10 min, ≥2×/day, ≥30 min between bouts) are **superior to a single continuous exercise session** for glycemic control. 95% completion rates, 85% unsupervised adherence.

### Standing vs Walking Meta-Analysis *(Buffey et al., Sports Medicine, 2022)*
Light-intensity walking breaks significantly reduce postprandial glucose (d=−0.72) and insulin (d=−0.83). Standing also helps (d=−0.31 glucose). **Walking > standing > sitting.**

### Sleep Safety *(Gupta et al., Scientific Reports, 2025)*
Breaking up sitting with light walking **does not harm sleep architecture**. Safe for day and night shift workers.

### Cognitive Benefits *(Kuang et al., Mental Health & Physical Activity, 2025)*
Interrupting sitting every 30 min for 3.5 min of moderate walking **prevents cognitive decline** and improves inhibitory control and energy levels.

## 🚀 Quick Start

```bash
# Clone
git clone https://github.com/YOUR_USERNAME/standup-reminder.git
cd standup-reminder

# Build and launch (requires Xcode for swiftc)
make run

# Install to /Applications and auto-start on login
make launchd-install
```

> **Requirements:** macOS 14+, Xcode Command Line Tools (`xcode-select --install`)

## 🎮 Menu Bar Controls

Click the 💪 icon in your menu bar:

| Action | Shortcut |
|--------|----------|
| Remind Me Now | ⌘⇧R |
| Pause / Resume | ⌘⇧P |
| Snooze 5 min | — |
| Snooze 15 min | — |
| View Activity Log | ⌘⇧L |
| Settings | ⌘, |
| Quit | ⌘Q |

When a reminder fires, you can **Complete**, **Snooze (5 min)**, or **Skip** directly from the notification.

## ⚙️ Settings

### Intervals
- **Reminder Interval:** 15, 20, 30 (default), 45, or 60 minutes
- **Exercise Duration:** 1, 2, 3, 5 (default), or 10 minutes
- **Weekly Goal:** 5–100 completed breaks

### Exercises
Toggle entire categories on/off:
- 🚶 **Walking** — The most evidence-backed activity
- 🧍 **Standing/Marching** — Better than sitting
- 🤸 **Stretching** — Neck, shoulders, back, legs
- 💪 **Bodyweight** — Pushups, squats, lunges, bridges
- 🪑 **Chair Exercises** — For mobility limitations
- 🫁 **Breathing/Mindfulness** — Stress reduction

Mark contraindications (knee issues, back problems, balance concerns) and affected exercises are automatically excluded.

### Research
Built-in summary of the 5 key studies this app's defaults are based on.

## 📊 Activity Logging

All completions and skips are stored as JSON at:
```
~/Library/Application Support/StandUpReminder/activity_log.json
```

The app tracks:
- Daily/weekly completion counts
- **Streak** (consecutive days with at least 1 completed break)
- Completion rate (%)
- Most-used exercises

View the log via **⌘⇧L** from the menu bar or open the JSON file directly.

## 🏗️ Build from Source

```bash
make build          # Build StandUpReminder.app
make run            # Build and launch
make install        # Copy to /Applications
make clean          # Remove build artifacts
make launchd-install    # Install LaunchAgent for auto-start
make launchd-uninstall  # Remove LaunchAgent
```

### Architecture

```
Sources/
├── AppDelegate.swift          # @main entry, notification permissions, action handlers
├── ReminderEngine.swift       # Timer, exercise selection, notification delivery
├── StatusBarController.swift  # Menu bar icon + dropdown menu
├── SettingsView.swift         # 4-tab preferences (Intervals, Exercises, Research, About)
├── ActivityLogView.swift      # SwiftUI log viewer with stats
├── ExerciseLibrary.swift      # 21 exercises across 6 categories with contraindications
├── Models.swift               # Shared types + MedicalResearch citations
└── ActivityLogger.swift       # Actor-based local JSON persistence
```

## 🔒 Privacy

- **100% local.** No network requests, no analytics, no telemetry.
- Activity logs are stored in your local `~/Library/Application Support/` folder.
- The app does not require internet access.

## 📄 License

MIT — do whatever you want with it.

---

*"Sit less, move more — but specifically, move every 30 minutes for at least 3–5 minutes."* — BREAK2 / SBAE Consensus, 2025
