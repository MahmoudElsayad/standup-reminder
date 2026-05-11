import SwiftUI

struct ActivityLogView: View {
    @State private var entries: [ActivityLogEntry] = []
    @State private var completionRate: Double = 0
    @State private var streak: Int = 0
    @State private var completedThisWeek: Int = 0
    @State private var favorites: [(name: String, count: Int)] = []

    var body: some View {
        VStack(spacing: 0) {
            // Stats header
            statsHeader
                .padding()
                .background(Color.accentColor.opacity(0.1))

            Divider()

            // Entry list
            if entries.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .font(.system(size: 36))
                        .foregroundColor(.secondary)
                    Text("No activity logged yet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Complete your first exercise break to see it here!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(groupedEntries, id: \.0) { date, dayEntries in
                            dateHeader(date)
                            ForEach(dayEntries) { entry in
                                entryRow(entry)
                            }
                        }
                    }
                }
            }
        }
        .task {
            await loadData()
        }
    }

    private var groupedEntries: [(Date, [ActivityLogEntry])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: entries) { entry in
            calendar.startOfDay(for: entry.timestamp)
        }
        return grouped.sorted { $0.key > $1.key }
    }

    private var statsHeader: some View {
        VStack(spacing: 8) {
            HStack(spacing: 32) {
                statItem(value: "\(completedThisWeek)", label: "This Week")
                statItem(value: "\(streak)", label: "Day Streak")
                statItem(value: String(format: "%.0f%%", completionRate * 100), label: "Completion")
            }

            if !favorites.isEmpty {
                HStack(spacing: 4) {
                    Text("Favorites:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(favorites.prefix(3).map(\.name).joined(separator: ", "))
                        .font(.caption)
                        .lineLimit(1)
                }
            }
        }
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private func dateHeader(_ date: Date) -> some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"

        let dayEntries = entries.filter {
            Calendar.current.isDate($0.timestamp, inSameDayAs: date)
        }
        let completed = dayEntries.filter(\.completed).count
        let total = dayEntries.count

        return HStack {
            Text(formatter.string(from: date))
                .font(.subheadline)
                .fontWeight(.semibold)
            Spacer()
            Text("\(completed)/\(total) done")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .background(Color.primary.opacity(0.03))
    }

    private func entryRow(_ entry: ActivityLogEntry) -> some View {
        HStack(spacing: 10) {
            Image(systemName: entry.completed ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(entry.completed ? .green : .red)
                .font(.system(size: 14))

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.exerciseName)
                    .font(.system(size: 13))
                Text(entry.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(timeFormatter.string(from: entry.timestamp))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
        .opacity(entry.completed ? 1.0 : 0.5)
    }

    private var timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f
    }()

    private func loadData() async {
        entries = await ActivityLogger.shared.allEntries()
        completionRate = await ActivityLogger.shared.completionRate()
        streak = await ActivityLogger.shared.streakDays()
        completedThisWeek = await ActivityLogger.shared.completedThisWeek()
        favorites = await ActivityLogger.shared.favoriteExercises()
    }
}

#Preview {
    ActivityLogView()
}
