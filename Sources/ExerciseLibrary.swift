import Foundation

/// Research-backed exercise library organized by category and ability level.
/// Based on BREAK2 (Diaz 2025), SBAE Consensus (Yin/Li 2025), and related meta-analyses.
enum ExerciseLibrary {

    // MARK: - Walking (Most evidence-backed category)

    static let walkInPlace: Exercise = Exercise(
        name: "Walk in Place",
        category: .walking,
        instructions: "March in place, lifting knees to hip height. Swing arms naturally. Land softly on the balls of your feet.",
        durationSeconds: 120,
        difficulty: .easy,
        contraindications: []
    )

    static let briskWalkAround: Exercise = Exercise(
        name: "Brisk Walk Around",
        category: .walking,
        instructions: "Walk briskly around your space. Aim for 2-3 mph pace (brisk but can hold a conversation). Swing arms.",
        durationSeconds: 180,
        difficulty: .moderate,
        contraindications: []
    )

    static let highKnees: Exercise = Exercise(
        name: "High Knees March",
        category: .walking,
        instructions: "March bringing knees up to waist level. Pump arms. Keep core engaged. Can be done at your own pace.",
        durationSeconds: 60,
        difficulty: .moderate,
        contraindications: ["knee_injury"]
    )

    // MARK: - Standing / Marching

    static let standAndStretchUp: Exercise = Exercise(
        name: "Stand & Reach Up",
        category: .standing,
        instructions: "Stand up tall, reach both arms overhead, interlace fingers, and stretch upward. Hold for 5 seconds, release, repeat.",
        durationSeconds: 60,
        difficulty: .easy,
        contraindications: []
    )

    static let marchInPlace: Exercise = Exercise(
        name: "March in Place (Gentle)",
        category: .standing,
        instructions: "Stand tall and gently march in place. Lift feet just a few inches. Focus on posture — shoulders back, core engaged.",
        durationSeconds: 120,
        difficulty: .easy,
        contraindications: []
    )

    static let weightShiftTaps: Exercise = Exercise(
        name: "Weight Shift & Side Taps",
        category: .standing,
        instructions: "Stand with feet hip-width. Shift weight to right, tap left foot out. Shift left, tap right. Add arm reaches for more movement.",
        durationSeconds: 90,
        difficulty: .easy,
        contraindications: []
    )

    // MARK: - Stretching

    static let neckRolls: Exercise = Exercise(
        name: "Neck & Shoulder Rolls",
        category: .stretching,
        instructions: "Slowly roll neck in half-circles (chin to chest, ear to shoulder). Roll shoulders forward 5×, backward 5×. Breathe deeply.",
        durationSeconds: 60,
        difficulty: .easy,
        contraindications: ["neck_injury"]
    )

    static let spineTwist: Exercise = Exercise(
        name: "Seated/Standing Spine Twist",
        category: .stretching,
        instructions: "Sit tall or stand. Place right hand on left knee, left hand behind you. Gently twist left. Hold 15 sec. Switch sides. Breathe.",
        durationSeconds: 90,
        difficulty: .easy,
        contraindications: ["spine_injury"]
    )

    static let hamstringStretch: Exercise = Exercise(
        name: "Hamstring Stretch",
        category: .stretching,
        instructions: "Stand and place one heel on a low surface (or floor). Hinge at hips, keep back straight. Feel stretch in back of thigh. Hold 20 sec each leg.",
        durationSeconds: 120,
        difficulty: .easy,
        contraindications: ["hamstring_injury"]
    )

    static let chestDoorwayStretch: Exercise = Exercise(
        name: "Chest & Doorway Stretch",
        category: .stretching,
        instructions: "Stand in a doorway. Place forearms on doorframe at shoulder height. Lean forward gently until you feel a stretch across your chest.",
        durationSeconds: 60,
        difficulty: .easy,
        contraindications: ["shoulder_injury"]
    )

    // MARK: - Bodyweight

    static let bodyweightSquats: Exercise = Exercise(
        name: "Bodyweight Squats",
        category: .bodyweight,
        instructions: "Stand feet shoulder-width. Lower hips back and down as if sitting in a chair. Keep chest up, knees tracking over toes. Go as low as comfortable, then stand back up.",
        durationSeconds: 120,
        difficulty: .moderate,
        contraindications: ["knee_injury", "hip_injury", "balance_issues"]
    )

    static let wallPushups: Exercise = Exercise(
        name: "Wall Pushups",
        category: .bodyweight,
        instructions: "Stand arm's length from wall. Place palms on wall at shoulder height. Bend elbows, lean body toward wall. Push back. The most accessible pushup variant.",
        durationSeconds: 90,
        difficulty: .easy,
        contraindications: ["wrist_injury"]
    )

    static let standingCalfRaises: Exercise = Exercise(
        name: "Standing Calf Raises",
        category: .bodyweight,
        instructions: "Stand tall, rise up on balls of feet as high as comfortable. Hold 2 seconds at top. Lower slowly. Use a wall/chair for balance if needed.",
        durationSeconds: 60,
        difficulty: .easy,
        contraindications: ["ankle_injury"]
    )

    static let lunges: Exercise = Exercise(
        name: "Alternating Lunges",
        category: .bodyweight,
        instructions: "Step forward with right leg, lower hips until both knees are at 90°. Push back to start. Alternate legs. Use wall for support if needed.",
        durationSeconds: 120,
        difficulty: .moderate,
        contraindications: ["knee_injury", "hip_injury", "balance_issues"]
    )

    static let gluteBridges: Exercise = Exercise(
        name: "Glute Bridges",
        category: .bodyweight,
        instructions: "Lie on back, knees bent, feet flat on floor. Squeeze glutes and lift hips toward ceiling. Hold 2 sec at top. Lower with control. Do this on a mat or carpet.",
        durationSeconds: 90,
        difficulty: .easy,
        contraindications: ["back_injury_acute"]
    )

    static let standingSideLegLifts: Exercise = Exercise(
        name: "Standing Side Leg Lifts",
        category: .bodyweight,
        instructions: "Stand holding a wall/chair. Lift one leg out to the side, keeping it straight. Lower with control. Switch sides halfway through. Works hip abductors.",
        durationSeconds: 90,
        difficulty: .easy,
        contraindications: ["hip_injury", "balance_issues"]
    )

    // MARK: - Chair Exercises (Accessible for mobility limitations)

    static let seatedMarching: Exercise = Exercise(
        name: "Seated Marching",
        category: .chair,
        instructions: "Sit tall in chair. Lift one knee toward chest, lower, switch. Like marching while seated. Keep back straight, engage core. Can increase pace for intensity.",
        durationSeconds: 120,
        difficulty: .easy,
        contraindications: []
    )

    static let seatedLegExtensions: Exercise = Exercise(
        name: "Seated Leg Extensions",
        category: .chair,
        instructions: "Sit tall, extend one leg straight out, hold 3 sec, lower slowly. Alternate legs. Squeeze quadriceps at the top. Works thigh muscles without standing.",
        durationSeconds: 90,
        difficulty: .easy,
        contraindications: ["knee_injury"]
    )

    static let seatedArmCircles: Exercise = Exercise(
        name: "Seated Arm Circles",
        category: .chair,
        instructions: "Extend arms out to sides at shoulder height. Make small circles forward for 30 sec, then backward for 30 sec. Keep shoulders relaxed, breathe steadily.",
        durationSeconds: 60,
        difficulty: .easy,
        contraindications: ["shoulder_injury_severe"]
    )

    static let seatedTorsoTwist: Exercise = Exercise(
        name: "Seated Torso Twist",
        category: .chair,
        instructions: "Sit sideways on chair (or twist torso). Place right hand on chair back, left on thigh. Gently twist right. Hold 15 sec. Switch sides. Engages core gently.",
        durationSeconds: 60,
        difficulty: .easy,
        contraindications: ["spine_injury"]
    )

    // MARK: - Breathing / Mindfulness

    static let boxBreathing: Exercise = Exercise(
        name: "Box Breathing (4-4-4-4)",
        category: .breathing,
        instructions: "Inhale for 4 counts, hold for 4, exhale for 4, hold for 4. Repeat. Used by Navy SEALs for stress control. Lowers heart rate and blood pressure.",
        durationSeconds: 120,
        difficulty: .easy,
        contraindications: []
    )

    static let standingDeepBreaths: Exercise = Exercise(
        name: "Standing Deep Breaths",
        category: .breathing,
        instructions: "Stand tall. Inhale deeply through nose while raising arms overhead. Exhale slowly through mouth while lowering arms. Feel ribcage expand. 5-6 breaths per minute pace.",
        durationSeconds: 90,
        difficulty: .easy,
        contraindications: []
    )

    // MARK: - Full Library

    static let allExercises: [Exercise] = [
        // Walking
        walkInPlace, briskWalkAround, highKnees,
        // Standing
        standAndStretchUp, marchInPlace, weightShiftTaps,
        // Stretching
        neckRolls, spineTwist, hamstringStretch, chestDoorwayStretch,
        // Bodyweight
        bodyweightSquats, wallPushups, standingCalfRaises, lunges, gluteBridges, standingSideLegLifts,
        // Chair
        seatedMarching, seatedLegExtensions, seatedArmCircles, seatedTorsoTwist,
        // Breathing
        boxBreathing, standingDeepBreaths,
    ]

    static func exercises(in category: ExerciseCategory) -> [Exercise] {
        allExercises.filter { $0.category == category }
    }

    static func exercises(for contraindication: String) -> [Exercise] {
        allExercises.filter { !$0.contraindications.contains(contraindication) }
    }

    /// Get a randomized set of exercises based on user preferences and duration
    static func selectExercises(
        durationMinutes: Int,
        enabledCategories: Set<ExerciseCategory>,
        disabledExercises: Set<String>,
        userContraindications: Set<String>
    ) -> [Exercise] {
        let available = allExercises.filter { exercise in
            enabledCategories.contains(exercise.category) &&
            !disabledExercises.contains(exercise.name) &&
            !exercise.contraindications.contains(where: { userContraindications.contains($0) })
        }

        guard !available.isEmpty else {
            // Fallback: just stand up and move
            return [marchInPlace, standAndStretchUp]
        }

        let targetSeconds = durationMinutes * 60
        var selected: [Exercise] = []
        var totalSeconds = 0
        let shuffled = available.shuffled()
        var usedNames = Set<String>()

        for exercise in shuffled {
            if totalSeconds + exercise.durationSeconds > targetSeconds + 30 { break }
            if usedNames.contains(exercise.name) { continue }
            selected.append(exercise)
            totalSeconds += exercise.durationSeconds
            usedNames.insert(exercise.name)
        }

        if selected.isEmpty {
            selected = [available.first!]
        }

        return selected
    }
}
