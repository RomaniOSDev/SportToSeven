import Foundation

struct CustomWorkout: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var exercises: [CustomWorkoutExercise]
    var createdAt: Date
    var isDefault: Bool
    
    init(id: UUID = UUID(), name: String, exercises: [CustomWorkoutExercise] = [], isDefault: Bool = false) {
        self.id = id
        self.name = name
        self.exercises = exercises
        self.createdAt = Date()
        self.isDefault = isDefault
    }
    
    var totalDuration: Int {
        exercises.reduce(0) { total, exercise in
            total + exercise.workDuration + exercise.restDuration
        }
    }
    
    var formattedDuration: String {
        let minutes = totalDuration / 60
        let seconds = totalDuration % 60
        return "\(minutes):\(String(format: "%02d", seconds))"
    }
}

struct CustomWorkoutExercise: Identifiable, Codable, Equatable {
    let id: UUID
    var exercise: Exercise
    var workDuration: Int
    var restDuration: Int
    
    init(id: UUID = UUID(), exercise: Exercise, workDuration: Int = 30, restDuration: Int = 10) {
        self.id = id
        self.exercise = exercise
        self.workDuration = workDuration
        self.restDuration = restDuration
    }
}

// MARK: - Custom Workout Library
enum CustomWorkoutLibrary {
    static let defaultWorkouts: [CustomWorkout] = [
        CustomWorkout(
            name: "Quick Warm-up",
            exercises: [
                CustomWorkoutExercise(exercise: ExerciseLibrary.all[0], workDuration: 20, restDuration: 5),
                CustomWorkoutExercise(exercise: ExerciseLibrary.all[1], workDuration: 20, restDuration: 5),
                CustomWorkoutExercise(exercise: ExerciseLibrary.all[2], workDuration: 20, restDuration: 5)
            ],
            isDefault: true
        ),
        CustomWorkout(
            name: "Intensive Workout",
            exercises: [
                CustomWorkoutExercise(exercise: ExerciseLibrary.all[3], workDuration: 45, restDuration: 15),
                CustomWorkoutExercise(exercise: ExerciseLibrary.all[4], workDuration: 45, restDuration: 15),
                CustomWorkoutExercise(exercise: ExerciseLibrary.all[5], workDuration: 45, restDuration: 15),
                CustomWorkoutExercise(exercise: ExerciseLibrary.all[6], workDuration: 45, restDuration: 15)
            ],
            isDefault: true
        )
    ]
}

