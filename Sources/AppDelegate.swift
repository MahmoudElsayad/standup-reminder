import AppKit
import UserNotifications

@main
final class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    private var statusBarController: StatusBarController?
    private var reminderEngine: ReminderEngine!

    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.setActivationPolicy(.accessory)
        app.run()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        UNUserNotificationCenter.current().delegate = self

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                self.setupNotificationCategories()
                self.reminderEngine.start()

                if !granted {
                    self.showNotificationDeniedAlert()
                }
            }
        }

        Task { await ActivityLogger.shared.setup() }

        reminderEngine = ReminderEngine()
        statusBarController = StatusBarController(reminderEngine: reminderEngine)
    }

    func applicationWillTerminate(_ notification: Notification) {
        reminderEngine.stop()
    }

    // MARK: - UNUserNotificationCenterDelegate

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        Task { @MainActor in
            switch response.actionIdentifier {
            case "COMPLETE": reminderEngine.logCompleted()
            case "SKIP": reminderEngine.logSkipped(reason: "Skipped via notification")
            case "SNOOZE": reminderEngine.snooze(minutes: 5)
            default: break
            }
            completionHandler()
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }

    // MARK: - Setup

    private func setupNotificationCategories() {
        let completeAction = UNNotificationAction(identifier: "COMPLETE", title: "✅ Done!", options: .foreground)
        let skipAction = UNNotificationAction(identifier: "SKIP", title: "⏭ Skip", options: .destructive)
        let snoozeAction = UNNotificationAction(identifier: "SNOOZE", title: "😴 Snooze 5 min", options: [])
        let category = UNNotificationCategory(
            identifier: "STANDUP_REMINDER",
            actions: [completeAction, snoozeAction, skipAction],
            intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }

    private func showNotificationDeniedAlert() {
        let alert = NSAlert()
        alert.messageText = "Notifications Disabled"
        alert.informativeText = """
            StandUp Reminder needs notification permission to send you movement reminders.

            Open System Settings → Notifications → StandUp Reminder
            and enable "Allow Notifications".
            """
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Open System Settings")
        alert.addButton(withTitle: "Later")
        if alert.runModal() == .alertFirstButtonReturn {
            NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.notifications")!)
        }
    }
}
