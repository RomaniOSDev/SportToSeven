import SwiftUI

struct ExercisePickerView: View {
    let onSelect: (Exercise) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AppBackground()
                
                List {
                    ForEach(ExerciseLibrary.all) { exercise in
                        ExercisePickerRowView(exercise: exercise) {
                            onSelect(exercise)
                        }
                    }
                }
            }
            .navigationTitle("Select Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct ExercisePickerRowView: View {
    let exercise: Exercise
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                Image(systemName: exercise.systemImageName)
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 30)
                
                Text(exercise.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "plus.circle.fill")
                    .font(.title3)
                    .foregroundColor(.blue)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DurationEditorView: View {
    let exercise: CustomWorkoutExercise
    let onSave: (Int, Int) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    @State private var workDuration: Int
    @State private var restDuration: Int
    
    init(exercise: CustomWorkoutExercise, onSave: @escaping (Int, Int) -> Void) {
        self.exercise = exercise
        self.onSave = onSave
        self._workDuration = State(initialValue: exercise.workDuration)
        self._restDuration = State(initialValue: exercise.restDuration)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppBackground()
                
                VStack(spacing: 24) {
                    // Exercise info
                    VStack(spacing: 12) {
                        Image(systemName: exercise.exercise.systemImageName)
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text(exercise.exercise.title)
                            .font(.title2.bold())
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                    )
                    
                    // Duration sliders
                    VStack(spacing: 20) {
                        DurationSlider(
                            title: "Work",
                            value: $workDuration,
                            range: 5...120,
                            color: .green,
                            icon: "play.fill"
                        )
                        
                        DurationSlider(
                            title: "Rest",
                            value: $restDuration,
                            range: 0...60,
                            color: .orange,
                            icon: "pause.fill"
                        )
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Duration Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(workDuration, restDuration)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct DurationSlider: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Text("\(value)s")
                    .font(.title2.bold())
                    .monospacedDigit()
                    .foregroundColor(color)
            }
            
            Slider(
                value: Binding(
                    get: { Double(value) },
                    set: { value = Int($0) }
                ),
                in: Double(range.lowerBound)...Double(range.upperBound),
                step: 5
            )
            .accentColor(color)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}

#Preview {
    ExercisePickerView { _ in }
}

