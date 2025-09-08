import SwiftUI

struct CustomWorkoutsListView: View {
    @StateObject private var viewModel = CustomWorkoutViewModel()
    @State private var showingEditor = false
    @State private var editingWorkout: CustomWorkout?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppBackground()
                
                VStack(spacing: 0) {
                    if viewModel.customWorkouts.isEmpty {
                        emptyState
                    } else {
                        workoutList
                    }
                }
            }
            .navigationTitle("My Workouts")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { 
                        editingWorkout = CustomWorkout(name: "New Workout")
                        showingEditor = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .sheet(isPresented: $showingEditor) {
                if let workout = editingWorkout {
                    CustomWorkoutEditorView(workout: workout) { savedWorkout in
                        viewModel.saveWorkout(savedWorkout)
                        showingEditor = false
                        editingWorkout = nil
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadWorkouts()
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "dumbbell")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Workouts")
                .font(.title2.bold())
            
            Text("Create your first workout")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: {
                editingWorkout = CustomWorkout(name: "New Workout")
                showingEditor = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Create Workout")
                }
                .font(.headline)
                .foregroundColor(.white)
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
        }
        .padding()
    }
    
    private var workoutList: some View {
        List {
            ForEach(viewModel.customWorkouts) { workout in
                WorkoutRowView(workout: workout) {
                    editingWorkout = workout
                    showingEditor = true
                } onDelete: {
                    viewModel.deleteWorkout(workout)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct WorkoutRowView: View {
    let workout: CustomWorkout
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Workout icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "dumbbell.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                
                // Workout info
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 16) {
                        Label("\(workout.exercises.count) exercises", systemImage: "list.bullet")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Label(workout.formattedDuration, systemImage: "clock")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Arrow
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            if !workout.isDefault {
                Button("Delete", role: .destructive) {
                    onDelete()
                }
            }
        }
    }
}

#Preview {
    CustomWorkoutsListView()
}
