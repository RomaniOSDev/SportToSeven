import Foundation
import Combine

final class CustomWorkoutViewModel: ObservableObject {
    @Published private(set) var customWorkouts: [CustomWorkout] = []
    @Published var selectedWorkout: CustomWorkout?
    @Published var isEditing = false
    
    private let store: LocalStore
    private var cancellables: Set<AnyCancellable> = []
    
    init(store: LocalStore = .shared) {
        self.store = store
        loadWorkouts()
    }
    
    func loadWorkouts() {
        customWorkouts = store.customWorkouts
    }
    
    func saveWorkout(_ workout: CustomWorkout) {
        store.saveCustomWorkout(workout)
        loadWorkouts()
    }
    
    func deleteWorkout(_ workout: CustomWorkout) {
        store.deleteCustomWorkout(workout)
        loadWorkouts()
    }
    
    func startEditing(_ workout: CustomWorkout) {
        selectedWorkout = workout
        isEditing = true
    }
    
    func createNewWorkout() {
        selectedWorkout = CustomWorkout(name: "New Workout")
        isEditing = true
    }
    
    func cancelEditing() {
        selectedWorkout = nil
        isEditing = false
    }
}

// MARK: - Custom Workout Editor ViewModel
final class CustomWorkoutEditorViewModel: ObservableObject {
    @Published var workoutName: String = ""
    @Published var exercises: [CustomWorkoutExercise] = []
    @Published var selectedExercise: Exercise?
    @Published var showingExercisePicker = false
    
    private let store: LocalStore
    private let originalWorkout: CustomWorkout?
    
    init(workout: CustomWorkout? = nil, store: LocalStore = .shared) {
        self.store = store
        self.originalWorkout = workout
        
        if let workout = workout {
            self.workoutName = workout.name
            self.exercises = workout.exercises
        }
    }
    
    var isEditing: Bool {
        originalWorkout != nil
    }
    
    var canSave: Bool {
        !workoutName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !exercises.isEmpty
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
    
    func addExercise(_ exercise: Exercise) {
        let customExercise = CustomWorkoutExercise(exercise: exercise)
        exercises.append(customExercise)
        selectedExercise = nil
        showingExercisePicker = false
    }
    
    func removeExercise(at index: Int) {
        guard index < exercises.count else { return }
        exercises.remove(at: index)
    }
    
    func moveExercise(from source: IndexSet, to destination: Int) {
        exercises.move(fromOffsets: source, toOffset: destination)
    }
    
    func updateExerciseDuration(at index: Int, workDuration: Int, restDuration: Int) {
        guard index < exercises.count else { return }
        exercises[index].workDuration = workDuration
        exercises[index].restDuration = restDuration
    }
    
    func saveWorkout() -> CustomWorkout {
        let workout: CustomWorkout
        if let original = originalWorkout {
            workout = CustomWorkout(
                id: original.id,
                name: workoutName.trimmingCharacters(in: .whitespacesAndNewlines),
                exercises: exercises,
                isDefault: original.isDefault
            )
        } else {
            workout = CustomWorkout(
                name: workoutName.trimmingCharacters(in: .whitespacesAndNewlines),
                exercises: exercises
            )
        }
        
        store.saveCustomWorkout(workout)
        return workout
    }
}

