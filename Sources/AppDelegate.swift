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
            if let error = error {
                print("Notification permission error: \(error)")
            }
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied — reminders will still show in the menu bar")
            }
        }

        Task { await ActivityLogger.shared.setup() }

        setupNotificationCategories()

        reminderEngine = ReminderEngine()
        statusBarController = StatusBarController(reminderEngine: reminderEngine)
        reminderEngine.start()
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
            case "COMPLETE":
                reminderEngine.logCompleted()
            case "SKIP":
                reminderEngine.logSkipped(reason: "Skipped via notification")
            case "SNOOZE":
                reminderEngine.snooze(minutes: 5)
            default:
                break
            }
            completionHandler()
        }
    }

    // Show notification even when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }

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
}
