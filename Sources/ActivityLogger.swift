import Foundation

/// Logs activity completions, skips, and notes to a local JSON file.
/// Stored in ~/Library/Application Support/StandUpReminder/activity_log.json
actor ActivityLogger {
    static let shared = ActivityLogger()

    private var entries: [ActivityLogEntry] = []
    private let fileURL: URL
    private let maxEntries = 10_000  // Keep last 10k entries

    private init() {
        let appSupport = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first!

        let folder = appSupport.appendingPathComponent("StandUpReminder")
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)

        fileURL = folder.appendingPathComponent("activity_log.json")
        // load() called after init via setup()
    }

    func setup() {
        load()
    }

    // MARK: - Logging

    func logCompleted(exercise: Exercise, durationMinutes: Int, notes: String? = nil) {
        let entry = ActivityLogEntry(
            timestamp: Date(),
            exerciseName: exercise.name,
            category: exercise.category,
            durationMinutes: durationMinutes,
            completed: true,
            skipped: false,
            notes: notes
        )
        entries.append(entry)
        prune()
        save()
    }

    func logSkipped(category: ExerciseCategory = .walking, reason: String? = nil) {
        let entry = ActivityLogEntry(
            timestamp: Date(),
            exerciseName: "Skipped",
            category: category,
            durationMinutes: 0,
            completed: false,
            skipped: true,
            notes: reason
        )
        entries.append(entry)
        prune()
        save()
    }

    // MARK: - Querying

    func entriesForToday() -> [ActivityLogEntry] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return entries.filter { calendar.isDate($0.timestamp, inSameDayAs: today) }
    }

    func entriesForWeek() -> [ActivityLogEntry] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let weekAgo = calendar.date(byAdding: .day, value: -7, to: today) else {
            return []
        }
        return entries.filter { $0.timestamp >= weekAgo }
    }

    func completedThisWeek() -> Int {
        entriesForWeek().filter(\.completed).count
    }

    func completionRate(days: Int = 7) -> Double {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let startDate = calendar.date(byAdding: .day, value: -days, to: today) else {
            return 0
        }
        let periodEntries = entries.filter { $0.timestamp >= startDate }
        let total = periodEntries.count
        guard total > 0 else { return 0 }
        return Double(periodEntries.filter(\.completed).count) / Double(total)
    }

    func favoriteExercises(limit: Int = 5) -> [(name: String, count: Int)] {
        let completed = entries.filter(\.completed)
        let grouped = Dictionary(grouping: completed, by: \.exerciseName)
        return grouped
            .map { ($0.key, $0.value.count) }
            .sorted { $0.1 > $1.1 }
            .prefix(limit)
            .map { ($0.0, $0.1) }
    }

    func streakDays() -> Int {
        let calendar = Calendar.current
        var streak = 0
        var date = calendar.startOfDay(for: Date())

        while true {
            let dayEntries = entries.filter {
                calendar.isDate($0.timestamp, inSameDayAs: date) && $0.completed
            }
            if dayEntries.isEmpty { break }
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: date) else { break }
            date = previous
        }
        return streak
    }

    func allEntries() -> [ActivityLogEntry] {
        entries.sorted { $0.timestamp > $1.timestamp }
    }

    // MARK: - Persistence

    private func save() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(entries)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("ActivityLogger: Failed to save log: \(error)")
        }
    }

    private func load() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            entries = try decoder.decode([ActivityLogEntry].self, from: data)
        } catch {
            print("ActivityLogger: Failed to load log: \(error)")
            entries = []
        }
    }

    private func prune() {
        if entries.count > maxEntries {
            entries = Array(entries.suffix(maxEntries))
        }
    }
}
