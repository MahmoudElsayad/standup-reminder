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

struct Exercise: Equatable, Hashable {
    let name: String
    let category: ExerciseCategory
    let instructions: String
    let durationSeconds: Int
    let difficulty: Difficulty
    let contraindications: [String]

    enum Difficulty: String, CaseIterable, Hashable {
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

// MARK: - Medical Research Summary

struct ResearchCitation: Identifiable {
    let id: String
    let title: String
    let finding: String
    let source: String
}

enum MedicalResearch {
    static let citations: [ResearchCitation] = [
        ResearchCitation(id: "break2_2025", title: "BREAK2 Dose-Finding Trial",
            finding: "Testing 25 frequency/duration combos (every 30-120 min, 1-10 min breaks). Highest dose: every 30 min for 10 min is the efficacy benchmark.",
            source: "Diaz et al., BMC Public Health, 2025"),
        ResearchCitation(id: "sbae_2025", title: "SBAE Consensus Statement",
            finding: "Short Bouts of Accumulated Exercise (≤10 min, ≥2×/day, ≥30 min between) are SUPERIOR to single continuous exercise for glycemic control.",
            source: "Yin, Li et al., J Sport Health Sci, 2025"),
        ResearchCitation(id: "standing_meta", title: "Standing vs Walking Meta-Analysis",
            finding: "Light walking significantly reduces postprandial glucose (d=-0.72) and insulin (d=-0.83). Standing also helps (d=-0.31). Walking > standing > sitting.",
            source: "Buffey et al., Sports Medicine, 2022"),
        ResearchCitation(id: "sleep_2025", title: "Sleep & Activity Breaks RCT",
            finding: "Breaking up sitting with light walking does NOT harm sleep architecture. Safe to recommend without sleep disruption concerns.",
            source: "Gupta et al., Scientific Reports, 2025"),
        ResearchCitation(id: "cognition_2025", title: "Cognitive Benefits RCT",
            finding: "Interrupting sitting every 30 min for 3.5 min of walking prevents cognitive decline and improves energy levels.",
            source: "Kuang et al., Mental Health & Physical Activity, 2025"),
    ]

    static let defaultRecommendation = """
        Based on 2025 research (BREAK2 trial, SBAE statement):
        • Break up sitting every 30 minutes
        • Move for at least 3–5 minutes
        • Light walking is the most evidence-backed activity
        • Standing alone is better than sitting, walking is superior
        • Even 1-minute breaks provide measurable benefit
        • Every 30 min for 10 min is the efficacy benchmark
        """
}

// MARK: - Exercise Library

enum ExerciseLibrary {
    static let allExercises: [Exercise] = [
        // Walking
        Exercise(name: "Walk in Place", category: .walking, instructions: "March in place, lifting knees to hip height. Swing arms naturally.",
                 durationSeconds: 120, difficulty: .easy, contraindications: []),
        Exercise(name: "Brisk Walk Around", category: .walking, instructions: "Walk briskly around your space. Aim for 2-3 mph — brisk but conversational.",
                 durationSeconds: 180, difficulty: .moderate, contraindications: []),
        Exercise(name: "High Knees March", category: .walking, instructions: "March bringing knees to waist level. Pump arms, engage core.",
                 durationSeconds: 60, difficulty: .moderate, contraindications: ["knee_injury"]),
        // Standing
        Exercise(name: "Stand & Reach Up", category: .standing, instructions: "Stand tall, reach arms overhead, stretch upward. Hold 5 sec, repeat.",
                 durationSeconds: 60, difficulty: .easy, contraindications: []),
        Exercise(name: "March in Place (Gentle)", category: .standing, instructions: "Stand tall, gently march. Focus on posture — shoulders back, core engaged.",
                 durationSeconds: 120, difficulty: .easy, contraindications: []),
        Exercise(name: "Weight Shift & Side Taps", category: .standing, instructions: "Shift weight side to side, tap opposite foot out. Add arm reaches.",
                 durationSeconds: 90, difficulty: .easy, contraindications: []),
        // Stretching
        Exercise(name: "Neck & Shoulder Rolls", category: .stretching, instructions: "Slowly roll neck half-circles. Roll shoulders forward 5×, backward 5×.",
                 durationSeconds: 60, difficulty: .easy, contraindications: ["neck_injury"]),
        Exercise(name: "Spine Twist", category: .stretching, instructions: "Sit tall or stand. Gently twist torso left, hold 15 sec. Switch sides.",
                 durationSeconds: 90, difficulty: .easy, contraindications: ["spine_injury"]),
        Exercise(name: "Hamstring Stretch", category: .stretching, instructions: "Hinge at hips with straight back, stretch back of thigh. 20 sec per leg.",
                 durationSeconds: 120, difficulty: .easy, contraindications: ["hamstring_injury"]),
        Exercise(name: "Chest & Doorway Stretch", category: .stretching, instructions: "Place forearms on doorframe at shoulder height. Lean forward gently.",
                 durationSeconds: 60, difficulty: .easy, contraindications: ["shoulder_injury"]),
        // Bodyweight
        Exercise(name: "Bodyweight Squats", category: .bodyweight, instructions: "Lower hips back and down like sitting in a chair. Keep chest up, stand back up.",
                 durationSeconds: 120, difficulty: .moderate, contraindications: ["knee_injury", "hip_injury", "balance_issues"]),
        Exercise(name: "Wall Pushups", category: .bodyweight, instructions: "Stand arm's length from wall. Palms at shoulder height. Lean in, push back.",
                 durationSeconds: 90, difficulty: .easy, contraindications: ["wrist_injury"]),
        Exercise(name: "Standing Calf Raises", category: .bodyweight, instructions: "Rise up on balls of feet, hold 2 sec, lower slowly. Use wall for balance.",
                 durationSeconds: 60, difficulty: .easy, contraindications: ["ankle_injury"]),
        Exercise(name: "Alternating Lunges", category: .bodyweight, instructions: "Step forward, lower until both knees at 90°. Push back. Alternate legs.",
                 durationSeconds: 120, difficulty: .moderate, contraindications: ["knee_injury", "hip_injury", "balance_issues"]),
        Exercise(name: "Glute Bridges", category: .bodyweight, instructions: "Lie on back, knees bent, feet flat. Squeeze glutes, lift hips. Hold 2 sec.",
                 durationSeconds: 90, difficulty: .easy, contraindications: ["back_injury_acute"]),
        Exercise(name: "Standing Side Leg Lifts", category: .bodyweight, instructions: "Hold wall/chair. Lift one leg to side, keep straight. Lower with control.",
                 durationSeconds: 90, difficulty: .easy, contraindications: ["hip_injury", "balance_issues"]),
        // Chair
        Exercise(name: "Seated Marching", category: .chair, instructions: "Sit tall. Lift one knee toward chest, lower, switch. Like marching seated.",
                 durationSeconds: 120, difficulty: .easy, contraindications: []),
        Exercise(name: "Seated Leg Extensions", category: .chair, instructions: "Sit tall, extend one leg straight out, hold 3 sec, lower slowly. Alternate.",
                 durationSeconds: 90, difficulty: .easy, contraindications: ["knee_injury"]),
        Exercise(name: "Seated Arm Circles", category: .chair, instructions: "Arms out to sides. Small circles forward 30 sec, backward 30 sec.",
                 durationSeconds: 60, difficulty: .easy, contraindications: ["shoulder_injury_severe"]),
        Exercise(name: "Seated Torso Twist", category: .chair, instructions: "Sit sideways on chair. Gently twist right, hold 15 sec. Switch sides.",
                 durationSeconds: 60, difficulty: .easy, contraindications: ["spine_injury"]),
        // Breathing
        Exercise(name: "Box Breathing", category: .breathing, instructions: "Inhale 4 counts, hold 4, exhale 4, hold 4. Repeat. Lowers heart rate and BP.",
                 durationSeconds: 120, difficulty: .easy, contraindications: []),
        Exercise(name: "Standing Deep Breaths", category: .breathing, instructions: "Inhale deeply through nose raising arms overhead, exhale slowly lowering arms.",
                 durationSeconds: 90, difficulty: .easy, contraindications: []),
    ]

    static func exercise(named name: String) -> Exercise? { allExercises.first { $0.name == name } }

    static func selectExercises(durationMinutes: Int, enabledCategories: Set<ExerciseCategory>,
                                userContraindications: Set<String>) -> [Exercise] {
        let available = allExercises.filter { ex in
            guard enabledCategories.contains(ex.category) else { return false }
            for c in ex.contraindications { if userContraindications.contains(c) { return false } }
            return true
        }
        guard !available.isEmpty else {
            return [exercise(named: "March in Place (Gentle)")!, exercise(named: "Stand & Reach Up")!]
        }
        let target = durationMinutes * 60
        var selected: [Exercise] = []
        var total = 0
        var seen = Set<String>()
        for ex in available.shuffled() {
            if total + ex.durationSeconds > target + 30 { break }
            if seen.contains(ex.name) { continue }
            selected.append(ex)
            total += ex.durationSeconds
            seen.insert(ex.name)
        }
        return selected.isEmpty ? [available[0]] : selected
    }
}
