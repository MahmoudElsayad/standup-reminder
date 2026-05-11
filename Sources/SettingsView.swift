import SwiftUI

struct SettingsView: View {
    @ObservedObject var reminderEngine: ReminderEngine

    var body: some View {
        TabView {
            // Intervals tab
            Form {
                Section("Reminder Interval") {
                    Picker("Remind me every", selection: $reminderEngine.intervalMinutes) {
                        Text("15 min").tag(15)
                        Text("20 min").tag(20)
                        Text("30 min").tag(30)
                        Text("45 min").tag(45)
                        Text("60 min").tag(60)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: reminderEngine.intervalMinutes) { _, _ in
                        if !reminderEngine.isPaused { reminderEngine.start() }
                    }
                    Text("Every 30 min is the BREAK2 trial efficacy benchmark.")
                        .font(.caption).foregroundColor(.secondary)
                }
                Section("Exercise Duration") {
                    Picker("Move for", selection: $reminderEngine.exerciseDurationMinutes) {
                        Text("1 min").tag(1); Text("2 min").tag(2)
                        Text("3 min").tag(3); Text("5 min").tag(5); Text("10 min").tag(10)
                    }
                    .pickerStyle(.segmented)
                    Text("3–5 min is the SBAE consensus minimum effective dose.")
                        .font(.caption).foregroundColor(.secondary)
                }
                Section("Weekly Goal") {
                    Stepper("\(reminderEngine.weeklyGoal) breaks/week", value: $reminderEngine.weeklyGoal, in: 5...100, step: 5)
                }
            }
            .formStyle(.grouped)
            .tabItem { Label("Intervals", systemImage: "timer") }
            .padding()

            // Exercises tab
            VStack(alignment: .leading, spacing: 0) {
                Text("Exercise Categories").font(.headline).padding(.bottom, 8)
                List {
                    ForEach(ExerciseCategory.allCases, id: \.self) { category in
                        HStack {
                            Image(systemName: category.icon).frame(width: 24)
                            VStack(alignment: .leading) {
                                Text(category.rawValue).font(.system(size: 13, weight: .medium))
                                Text(category.description).font(.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                            Toggle("", isOn: bindCategory(category)).toggleStyle(.switch).controlSize(.small)
                        }.padding(.vertical, 2)
                    }
                }
                .listStyle(.plain)
                Divider().padding(.vertical, 8)
                Text("I cannot do exercises involving:").font(.headline).padding(.bottom, 4)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 4) {
                    ContraToggle(label: "Knee issues", key: "knee_injury", engine: reminderEngine)
                    ContraToggle(label: "Hip issues", key: "hip_injury", engine: reminderEngine)
                    ContraToggle(label: "Back issues", key: "back_injury_acute", engine: reminderEngine)
                    ContraToggle(label: "Shoulder issues", key: "shoulder_injury", engine: reminderEngine)
                    ContraToggle(label: "Shoulder (severe)", key: "shoulder_injury_severe", engine: reminderEngine)
                    ContraToggle(label: "Wrist issues", key: "wrist_injury", engine: reminderEngine)
                    ContraToggle(label: "Ankle issues", key: "ankle_injury", engine: reminderEngine)
                    ContraToggle(label: "Neck issues", key: "neck_injury", engine: reminderEngine)
                    ContraToggle(label: "Balance concerns", key: "balance_issues", engine: reminderEngine)
                    ContraToggle(label: "Hamstring tightness", key: "hamstring_injury", engine: reminderEngine)
                }
                Text("Selected limitations auto-exclude affected exercises.").font(.caption).foregroundColor(.secondary).padding(.top, 4)
            }
            .tabItem { Label("Exercises", systemImage: "figure.strengthtraining.traditional") }
            .padding()

            // Research tab
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("What the Science Says").font(.title3).fontWeight(.bold)
                    Text(MedicalResearch.defaultRecommendation).font(.callout)
                    Divider()
                    ForEach(MedicalResearch.citations) { citation in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(citation.title).font(.subheadline).fontWeight(.semibold)
                            Text(citation.finding).font(.caption)
                            Text(citation.source).font(.caption2).foregroundColor(.secondary)
                        }.padding(.vertical, 4)
                    }
                    Text("Defaults from BREAK2 (every 30 min) and SBAE Consensus (3–5 min bouts).")
                        .font(.caption2).foregroundColor(.secondary).padding(.top, 8)
                }
            }
            .tabItem { Label("Research", systemImage: "cross.case") }
            .padding()

            // About tab
            VStack(spacing: 16) {
                Image(systemName: "figure.strengthtraining.traditional").font(.system(size: 48)).foregroundColor(.accentColor)
                Text("StandUp Reminder").font(.title2).fontWeight(.bold)
                Text("Version 2.0").font(.caption).foregroundColor(.secondary)
                Text("Research-backed movement reminders with customizable exercises for all ability levels, activity logging, and defaults from BREAK2 & SBAE Consensus (2025).")
                    .multilineTextAlignment(.center).foregroundColor(.secondary).font(.callout)
                VStack(spacing: 4) {
                    Text("Data stored locally at:").font(.caption).foregroundColor(.secondary)
                    Text("~/Library/Application Support/StandUpReminder/")
                        .font(.caption).fontWeight(.medium).textSelection(.enabled)
                }.padding(.top, 8)
                Spacer()
            }
            .tabItem { Label("About", systemImage: "info.circle") }
            .padding()
        }
        .frame(width: 520, height: 500)
    }

    private func bindCategory(_ category: ExerciseCategory) -> Binding<Bool> {
        Binding(get: { reminderEngine.enabledCategories.contains(category) },
                set: { $0 ? (_ = reminderEngine.enabledCategories.insert(category)) : (_ = reminderEngine.enabledCategories.remove(category)) })
    }
}
