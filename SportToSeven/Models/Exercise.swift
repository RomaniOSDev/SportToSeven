import Foundation

struct Exercise: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let systemImageName: String
    let durationSeconds: Int

    init(id: UUID = UUID(), title: String, systemImageName: String, durationSeconds: Int) {
        self.id = id
        self.title = title
        self.systemImageName = systemImageName
        self.durationSeconds = durationSeconds
    }
}

enum ExerciseLibrary {
    static let all: [Exercise] = [
        Exercise(title: "Squats", systemImageName: "figure.strengthtraining.traditional", durationSeconds: 30),
        Exercise(title: "Push-ups", systemImageName: "figure.pushup", durationSeconds: 30),
        Exercise(title: "Plank", systemImageName: "figure.core.training", durationSeconds: 30),
        Exercise(title: "Crunches", systemImageName: "figure.core.training", durationSeconds: 30),
        Exercise(title: "Lunges", systemImageName: "figure.walk", durationSeconds: 30),
        Exercise(title: "Burpees", systemImageName: "flame", durationSeconds: 30),
        Exercise(title: "Jumping Jacks", systemImageName: "figure.jumprope", durationSeconds: 30),
        Exercise(title: "Mountain Climbers", systemImageName: "mountain.2", durationSeconds: 30),
        Exercise(title: "High Knees", systemImageName: "figure.run", durationSeconds: 30),
        Exercise(title: "Tricep Dips", systemImageName: "chair", durationSeconds: 30),
    ]
}



