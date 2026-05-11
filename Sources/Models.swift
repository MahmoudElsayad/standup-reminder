import Foundation

// MARK: - Exercise Definition

enum ExerciseCategory: String, Codable, CaseIterable {
    case walking = "Walking"
    case standing = "Standing / Marching"
    case stretching = "Stretching"
    case bodyweight = "Bodyweight"
    case chair = "Chair Exercises"
    case breathing = "Breathing / Mindfulness"

    var icon: String {
        switch self {
        case .walking: return "figure.walk"
        case .standing: return "figure.stand"
        case .stretching: return "figure.flexibility"
        case .bodyweight: return "figure.strengthtraining.traditional"
        case .chair: return "chair.lounge"
        case .breathing: return "lungs"
        }
    }

    var description: String {
        switch self {
        case .walking: return "Light walking — the most studied and accessible break activity"
        case .standing: return "Stand up, march in place, shift weight between legs"
        case .stretching: return "Gentle stretches for neck, shoulders, back, and legs"
        case .bodyweight: return "Pushups, squats, lunges, calf raises, wall sits"
        case .chair: return "Seated exercises for those with mobility limitations"
        case .breathing: return "Deep breathing and mindfulness to reduce stress"
        }
    }
}

struct Exercise: Identifiable, Codable, Equatable {
    var id: String { name }
    let name: String
    let category: ExerciseCategory
    let instructions: String
    let durationSeconds: Int
    let difficulty: Difficulty
    let contraindications: [String]

    enum Difficulty: String, Codable, CaseIterable {
        case easy = "Easy"
        case moderate = "Moderate"
        case challenging = "Challenging"
    }
}

// MARK: - Activity Log Entry

struct ActivityLogEntry: Codable, Identifiable {
    var id: String { "\(timestamp.timeIntervalSince1970)-\(exerciseName)" }
    let timestamp: Date
    let exerciseName: String
    let category: ExerciseCategory
    let durationMinutes: Int
    let completed: Bool
    let skipped: Bool
    let notes: String?
}

// MARK: - App Preferences

struct AppPreferences: Codable {
    var reminderIntervalMinutes: Int = 30
    var exerciseDurationMinutes: Int = 5
    var enabledCategories: Set<ExerciseCategory> = Set(ExerciseCategory.allCases)
    var enabledExercises: Set<String> = []
    var weeklyGoal: Int = 20  // target breaks per week
    var notificationSound: NotificationSound = .default
    var launchAtLogin: Bool = false
    var showMedicalInfo: Bool = true

    enum NotificationSound: String, Codable, CaseIterable {
        case `default` = "Default"
        case gentle = "Gentle"
        case firm = "Firm"
    }
}

// MARK: - Medical Research Summary

struct ResearchCitation: Identifiable {
    let id: String
    let title: String
    let finding: String
    let source: String
}

/// Evidence-based recommendations from 2025 research
enum MedicalResearch {
    static let citations: [ResearchCitation] = [
        ResearchCitation(
            id: "break2_2025",
            title: "BREAK2 Dose-Finding Trial",
            finding: "Testing 25 frequency/duration combos (every 30-120 min, 1-10 min breaks). Highest dose: every 30 min for 10 min is the efficacy benchmark. Light walking at 2 mph used as the standard activity.",
            source: "Diaz et al., BMC Public Health, 2025"
        ),
        ResearchCitation(
            id: "sbae_2025",
            title: "SBAE Consensus Statement",
            finding: "Short Bouts of Accumulated Exercise (≤10 min, ≥2×/day, ≥30 min between) are SUPERIOR to single continuous exercise for glycemic control. 95% completion rates, 85% unsupervised adherence.",
            source: "Yin, Li et al., J Sport Health Sci, 2025"
        ),
        ResearchCitation(
            id: "standing_meta_2022",
            title: "Standing vs Walking Meta-Analysis",
            finding: "Light walking breaks significantly reduce postprandial glucose (d=-0.72) and insulin (d=-0.83) vs prolonged sitting. Standing also helps (d=-0.31 glucose). Walking > standing > sitting.",
            source: "Buffey et al., Sports Medicine, 2022"
        ),
        ResearchCitation(
            id: "sleep_2025",
            title: "Sleep & Activity Breaks RCT",
            finding: "Breaking up sitting with light walking does NOT harm sleep architecture. Safe to recommend activity breaks without sleep disruption concerns.",
            source: "Gupta et al., Scientific Reports, 2025"
        ),
        ResearchCitation(
            id: "cognition_2025",
            title: "Cognitive Benefits RCT",
            finding: "Interrupting sitting with moderate-intensity walking every 30 min for 3.5 min prevents cognitive decline and improves inhibitory control and energy levels.",
            source: "Kuang et al., Mental Health & Physical Activity, 2025"
        ),
    ]

    /// Default recommendation based on the BREAK2/SBAE consensus
    static let defaultRecommendation = """
        Based on 2025 research consensus (BREAK2 trial, SBAE statement):
        • Break up sitting every 30 minutes
        • Move for at least 3–5 minutes
        • Light walking is the most evidence-backed activity
        • Standing alone is better than sitting but walking is superior
        • Even 1-minute breaks provide measurable benefit
        • The highest tested dose (every 30 min for 10 min) is the efficacy benchmark
        """
}
