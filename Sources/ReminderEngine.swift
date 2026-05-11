import AppKit
import UserNotifications

@MainActor
final class ReminderEngine: ObservableObject {
    // MARK: - Published State
    @Published var nextReminderAt: Date?
    @Published var isPaused: Bool = false
    @Published var intervalMinutes: Int = 30
    @Published var exerciseDurationMinutes: Int = 5
    @Published var selectedExercises: [Exercise] = []
    @Published var showReminderWindow: Bool = false

    // Preferences
    @Published var enabledCategories: Set<ExerciseCategory> = Set(ExerciseCategory.allCases)
    @Published var disabledExercises: Set<String> = []
    @Published var userContraindications: Set<String> = []
    @Published var weeklyGoal: Int = 20

    // MARK: - Private
    private var timer: Timer?
    private var snoozeUntil: Date?
    private var pendingExercises: [Exercise] = []

    // MARK: - Computed

    var nextReminderText: String {
        guard !isPaused else { return "Paused" }
        if let snoozeUntil, snoozeUntil > Date() {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .abbreviated
            return "Snoozed — resuming \(formatter.localizedString(for: snoozeUntil, relativeTo: Date()))"
        }
        guard let next = nextReminderAt else { return "Not scheduled" }
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: next)
    }

    var completedThisWeek: Int {
        Task { await ActivityLogger.shared.completedThisWeek() }
        return 0  // Sync fallback
    }

    var streakDays: Int {
        Task { await ActivityLogger.shared.streakDays() }
        return 0
    }

    // MARK: - Timer Control

    func start() {
        scheduleNext()
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    func snooze(minutes: Int = 5) {
        snoozeUntil = Date().addingTimeInterval(TimeInterval(minutes * 60))
        objectWillChange.send()
    }

    func togglePause() {
        isPaused.toggle()
        if isPaused {
            timer?.invalidate()
            timer = nil
            nextReminderAt = nil
        } else {
            snoozeUntil = nil
            scheduleNext()
        }
        objectWillChange.send()
    }

    func triggerNow() {
        snoozeUntil = nil
        deliverReminder()
        scheduleNext()
    }

    // MARK: - Exercise Selection

    private func selectExercises() {
        pendingExercises = ExerciseLibrary.selectExercises(
            durationMinutes: exerciseDurationMinutes,
            enabledCategories: enabledCategories,
            disabledExercises: disabledExercises,
            userContraindications: userContraindications
        )
        selectedExercises = pendingExercises
    }

    // MARK: - Completed / Skipped

    func logCompleted() {
        for exercise in pendingExercises {
            Task {
                await ActivityLogger.shared.logCompleted(
                    exercise: exercise,
                    durationMinutes: exerciseDurationMinutes
                )
            }
        }
        pendingExercises = []
    }

    func logSkipped(reason: String? = nil) {
        Task {
            await ActivityLogger.shared.logSkipped(
                category: pendingExercises.first?.category ?? .walking,
                reason: reason
            )
        }
        pendingExercises = []
    }

    // MARK: - Schedule

    private func scheduleNext() {
        timer?.invalidate()
        let interval = TimeInterval(intervalMinutes * 60)
        nextReminderAt = Date().addingTimeInterval(interval)
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.deliverReminder()
                self?.scheduleNext()
            }
        }
    }

    // MARK: - Notification Delivery

    private func deliverReminder() {
        selectExercises()

        let exerciseList = pendingExercises.map { "• \($0.name)" }.joined(separator: "\n")

        let content = UNMutableNotificationContent()
        content.title = "💪 Time to Move!"
        content.subtitle = "Stand up and move for \(exerciseDurationMinutes) min"
        content.body = exerciseList.isEmpty
            ? "Stand up, walk around, stretch — just move!"
            : exerciseList
        content.sound = .default
        content.categoryIdentifier = "STANDUP_REMINDER"

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to deliver notification: \(error)")
            }
        }
    }
}
