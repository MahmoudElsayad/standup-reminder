import AppKit
import SwiftUI

@MainActor
final class StatusBarController: NSObject, NSMenuDelegate {
    private var statusItem: NSStatusItem!
    private let reminderEngine: ReminderEngine

    // Menu items needing updates
    private var nextReminderItem: NSMenuItem!
    private var exercisesItem: NSMenuItem!
    private var statsItem: NSMenuItem!
    private var pauseItem: NSMenuItem!

    init(reminderEngine: ReminderEngine) {
        self.reminderEngine = reminderEngine
        super.init()
        setupStatusItem()
        setupMenu()
        observeChanges()
    }

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(
                systemSymbolName: "figure.strengthtraining.traditional",
                accessibilityDescription: "StandUp Reminder"
            )
            button.image?.isTemplate = true
        }
    }

    private func setupMenu() {
        let menu = NSMenu()
        menu.delegate = self
        menu.minimumWidth = 280

        // Stats header
        statsItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        statsItem.isEnabled = false
        statsItem.attributedTitle = makeStatsString()
        menu.addItem(statsItem)

        menu.addItem(.separator())

        // Next reminder
        nextReminderItem = NSMenuItem(
            title: "Next: \(reminderEngine.nextReminderText)",
            action: nil,
            keyEquivalent: ""
        )
        nextReminderItem.isEnabled = false
        menu.addItem(nextReminderItem)

        // Current exercises
        exercisesItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        exercisesItem.isEnabled = false
        updateExercisesItem()
        menu.addItem(exercisesItem)

        menu.addItem(.separator())

        // Actions
        let remindNowItem = NSMenuItem(
            title: "⚠️ Remind Me Now",
            action: #selector(remindNowClicked),
            keyEquivalent: "r"
        )
        remindNowItem.keyEquivalentModifierMask = [.command, .shift]
        remindNowItem.target = self
        menu.addItem(remindNowItem)

        pauseItem = NSMenuItem(
            title: reminderEngine.isPaused ? "▶ Resume" : "⏸ Pause",
            action: #selector(togglePauseClicked),
            keyEquivalent: "p"
        )
        pauseItem.keyEquivalentModifierMask = [.command, .shift]
        pauseItem.target = self
        menu.addItem(pauseItem)

        let snooze5 = NSMenuItem(
            title: "😴 Snooze 5 min",
            action: #selector(snooze5Clicked),
            keyEquivalent: ""
        )
        snooze5.target = self
        menu.addItem(snooze5)

        let snooze15 = NSMenuItem(
            title: "😴 Snooze 15 min",
            action: #selector(snooze15Clicked),
            keyEquivalent: ""
        )
        snooze15.target = self
        menu.addItem(snooze15)

        menu.addItem(.separator())

        // Log action
        let logItem = NSMenuItem(
            title: "📊 View Activity Log",
            action: #selector(openLogClicked),
            keyEquivalent: "l"
        )
        logItem.keyEquivalentModifierMask = [.command, .shift]
        logItem.target = self
        menu.addItem(logItem)

        let settingsItem = NSMenuItem(
            title: "⚙ Settings",
            action: #selector(settingsClicked),
            keyEquivalent: ","
        )
        settingsItem.target = self
        menu.addItem(settingsItem)

        menu.addItem(.separator())

        let quitItem = NSMenuItem(
            title: "Quit",
            action: #selector(quitClicked),
            keyEquivalent: "q"
        )
        quitItem.keyEquivalentModifierMask = [.command]
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    private func observeChanges() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateMenuItems()
            }
        }
    }

    private func updateMenuItems() {
        nextReminderItem.title = "Next: \(reminderEngine.nextReminderText)"
        statsItem.attributedTitle = makeStatsString()
        pauseItem.title = reminderEngine.isPaused ? "▶ Resume" : "⏸ Pause"
        updateExercisesItem()
    }

    private func updateExercisesItem() {
        let exercises = reminderEngine.selectedExercises
        if exercises.isEmpty {
            exercisesItem.title = "No exercises selected"
            exercisesItem.isHidden = true
        } else {
            let names = exercises.map { "  \($0.category.icon) \($0.name)" }.joined(separator: "\n")
            exercisesItem.title = "Suggested:\n\(names)"
            exercisesItem.isHidden = false
        }
    }

    private func makeStatsString() -> NSAttributedString {
        // Fetch stats asynchronously
        var completed = 0
        var streak = 0
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            completed = await ActivityLogger.shared.completedThisWeek()
            streak = await ActivityLogger.shared.streakDays()
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .now() + 0.3)

        let text = "🏃 StandUp Reminder"
        let detail: String
        if completed > 0 || streak > 0 {
            detail = "\(completed) done this week · \(streak)-day streak"
        } else {
            detail = "Ready to help you move more!"
        }

        let attr = NSMutableAttributedString(string: "\(text)\n\(detail)")
        attr.addAttribute(.font, value: NSFont.boldSystemFont(ofSize: 13), range: NSRange(location: 0, length: text.count))
        attr.addAttribute(.font, value: NSFont.systemFont(ofSize: 11), range: NSRange(location: text.count + 1, length: detail.count))
        attr.addAttribute(.foregroundColor, value: NSColor.secondaryLabelColor, range: NSRange(location: text.count + 1, length: detail.count))
        return attr
    }

    // MARK: - Actions

    @objc private func remindNowClicked() {
        reminderEngine.triggerNow()
    }

    @objc private func togglePauseClicked() {
        reminderEngine.togglePause()
    }

    @objc private func snooze5Clicked() {
        reminderEngine.snooze(minutes: 5)
    }

    @objc private func snooze15Clicked() {
        reminderEngine.snooze(minutes: 15)
    }

    @objc private func openLogClicked() {
        let logView = ActivityLogView()
        let hostingController = NSHostingController(rootView: logView)
        let window = NSWindow(contentViewController: hostingController)
        window.title = "Activity Log — StandUp Reminder"
        window.setContentSize(NSSize(width: 500, height: 450))
        window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        window.center()
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func settingsClicked() {
        let settingsView = SettingsView(reminderEngine: reminderEngine)
        let hostingController = NSHostingController(rootView: settingsView)
        let window = NSWindow(contentViewController: hostingController)
        window.title = "StandUp Reminder — Settings"
        window.setContentSize(NSSize(width: 520, height: 500))
        window.styleMask = [.titled, .closable, .miniaturizable]
        window.center()
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func quitClicked() {
        NSApplication.shared.terminate(nil)
    }

    // NSMenuDelegate
    func menuWillOpen(_ menu: NSMenu) {
        updateMenuItems()
    }
}
import SwiftUI

struct ActivityLogView: View {
    @State private var entries: [ActivityLogEntry] = []
    @State private var streak: Int = 0
    @State private var completedThisWeek: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 32) {
                StatItem(value: "\(completedThisWeek)", label: "This Week")
                StatItem(value: "\(streak)", label: "Day Streak")
            }
            .padding()
            .background(Color.accentColor.opacity(0.1))

            if entries.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "tray").font(.system(size: 36)).foregroundColor(.secondary)
                    Text("No activity logged yet").font(.headline).foregroundColor(.secondary)
                    Text("Complete your first exercise break!").font(.caption).foregroundColor(.secondary)
                }
                .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(entries.sorted(by: { $0.timestamp > $1.timestamp })) { entry in
                            HStack(spacing: 10) {
                                Image(systemName: entry.completed ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(entry.completed ? .green : .red).font(.system(size: 14))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(entry.exerciseName).font(.system(size: 13))
                                    Text(entry.timestamp, style: .date).font(.caption).foregroundColor(.secondary)
                                    + Text(" at ").font(.caption).foregroundColor(.secondary)
                                    + Text(entry.timestamp, style: .time).font(.caption).foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.horizontal).padding(.vertical, 4)
                            .opacity(entry.completed ? 1.0 : 0.5)
                            Divider()
                        }
                    }
                }
            }
        }
        .task { await loadData() }
    }

    private func loadData() async {
        entries = await ActivityLogger.shared.allEntries()
        streak = await ActivityLogger.shared.streakDays()
        completedThisWeek = await ActivityLogger.shared.completedThisWeek()
    }
}

struct ContraToggle: View {
    let label: String
    let key: String
    @ObservedObject var engine: ReminderEngine
    @State private var isOn: Bool = false
    var body: some View {
        Toggle(label, isOn: $isOn).font(.caption)
            .onAppear { isOn = engine.userContraindications.contains(key) }
            .onChange(of: isOn) { _, new in
                if new { engine.userContraindications.insert(key) }
                else { engine.userContraindications.remove(key) }
            }
    }
}

struct StatItem: View {
    let value: String
    let label: String
    var body: some View {
        VStack(spacing: 2) {
            Text(value).font(.title2).fontWeight(.bold)
            Text(label).font(.caption).foregroundColor(.secondary)
        }
    }
}
