import SwiftUI

struct CustomWorkoutEditorView: View {
    @StateObject private var viewModel: CustomWorkoutEditorViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingExercisePicker = false
    @State private var showingDurationEditor = false
    @State private var selectedExerciseIndex: Int?
    
    let onSave: (CustomWorkout) -> Void
    
    init(workout: CustomWorkout? = nil, onSave: @escaping (CustomWorkout) -> Void) {
        self._viewModel = StateObject(wrappedValue: CustomWorkoutEditorViewModel(workout: workout))
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppBackground()
                
                VStack(spacing: 0) {
                    // Header with workout info
                    headerSection
                    
                    // Exercises list
                    exercisesList
                    
                    // Add exercise button
                    addExerciseButton
                }
            }
            .navigationTitle(viewModel.isEditing ? "Edit" : "New Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let workout = viewModel.saveWorkout()
                        onSave(workout)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(!viewModel.canSave)
                }
            }
            .sheet(isPresented: $showingExercisePicker) {
                ExercisePickerView { exercise in
                    viewModel.addExercise(exercise)
                }
            }
            .sheet(isPresented: $showingDurationEditor) {
                if let index = selectedExerciseIndex {
                    DurationEditorView(
                        exercise: viewModel.exercises[index],
                        onSave: { workDuration, restDuration in
                            viewModel.updateExerciseDuration(
                                at: index,
                                workDuration: workDuration,
                                restDuration: restDuration
                            )
                        }
                    )
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Workout name
            VStack(alignment: .leading, spacing: 8) {
                Text("Workout Name")
                    .font(.headline)
                
                TextField("Enter name", text: $viewModel.workoutName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // Workout stats
            HStack(spacing: 20) {
                StatCard(
                    title: "Exercises",
                    value: "\(viewModel.exercises.count)",
                    icon: "list.bullet",
                    color: .blue
                )
                
                StatCard(
                    title: "Duration",
                    value: viewModel.formattedDuration,
                    icon: "clock",
                    color: .green
                )
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
    }
    
    private var exercisesList: some View {
        List {
            ForEach(Array(viewModel.exercises.enumerated()), id: \.element.id) { index, exercise in
                ExerciseRowView(
                    exercise: exercise,
                    index: index + 1,
                    onTap: {
                        selectedExerciseIndex = index
                        showingDurationEditor = true
                    }
                )
            }
            .onDelete { indexSet in
                for index in indexSet {
                    viewModel.removeExercise(at: index)
                }
            }
            .onMove(perform: viewModel.moveExercise)
        }
        .listStyle(PlainListStyle())
    }
    
    private var addExerciseButton: some View {
        Button(action: { showingExercisePicker = true }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add Exercise")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2.bold())
                .monospacedDigit()
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

struct ExerciseRowView: View {
    let exercise: CustomWorkoutExercise
    let index: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Exercise number
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Text("\(index)")
                        .font(.headline.bold())
                        .foregroundColor(.blue)
                }
                
                // Exercise info
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.exercise.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 12) {
                        Label("\(exercise.workDuration)s", systemImage: "play.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                        
                        Label("\(exercise.restDuration)s", systemImage: "pause.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                
                Spacer()
                
                // Exercise icon
                Image(systemName: exercise.exercise.systemImageName)
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CustomWorkoutEditorView { _ in }
}

