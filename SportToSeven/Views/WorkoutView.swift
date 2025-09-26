import SwiftUI

struct WorkoutView: View {
    @StateObject private var viewModel = WorkoutViewModel()
    @Namespace private var animation
    @State private var showCongrats = false

    var body: some View {
        ZStack {
            AppBackground()
            
            VStack(spacing: 20) {
                header
                progress
                Spacer()
                exerciseCard
                Spacer()
                controls
            }
            .padding()
        }
        .onAppear { viewModel.start() }
        .onChange(of: viewModel.phase) { newPhase in
            if case .finished = newPhase { showCongrats = true }
        }
        .sheet(isPresented: $showCongrats, onDismiss: {}) {
            CongratsView()
        }
    }

    private var header: some View {
        HStack {
            WorkoutProgressRing(
                totalRemaining: viewModel.totalRemaining,
                totalDuration: 7 * 60
            )
            Spacer()
        }
    }

    private var progress: some View {
        ExercisePhaseProgress(
            phase: viewModel.phase,
            currentIndex: viewModel.currentIndex,
            totalExercises: viewModel.exercises.count
        )
    }

    private var exerciseCard: some View {
        ZStack {
            switch viewModel.phase {
            case .ready:
                Text("Ready?")
                    .font(.title.bold())
                    .frame(maxWidth: .infinity, minHeight: 220)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            case .work(let exercise, let remaining):
                ExercisePhaseView(
                    title: exercise.title, 
                    systemImage: exercise.systemImageName, 
                    remaining: remaining, 
                    color: .green,
                    total: 30
                )
                .matchedGeometryEffect(id: "phase", in: animation)
            case .rest(let remaining):
                ExercisePhaseView(
                    title: "Rest", 
                    systemImage: "pause.fill", 
                    remaining: remaining, 
                    color: .orange,
                    total: 10
                )
                .matchedGeometryEffect(id: "phase", in: animation)
            case .finished:
                Text("Done!")
                    .font(.title.bold())
                    .frame(maxWidth: .infinity, minHeight: 220)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
        }
        .animation(.easeInOut, value: viewModel.phase)
    }

    private var controls: some View {
        Button(action: { showCongrats = true }) {
            Text("Finish")
        }
        .buttonStyle(SecondaryButtonStyle(size: .medium))
        .padding(.horizontal)
    }
}

private struct ExercisePhaseView: View {
    let title: String
    let systemImage: String
    let remaining: Int
    let color: Color
    let total: Int

    var body: some View {
        AppCard {
            VStack(spacing: 20) {
                AppIcon(
                    systemName: systemImage,
                    size: 24,
                    color: color,
                    backgroundColor: color.opacity(0.1)
                )
                
                Text(title)
                    .appHeadline()
                    .multilineTextAlignment(.center)
                
                AppCircularProgress(
                    progress: 1 - Double(remaining) / Double(total),
                    size: 100,
                    lineWidth: 6,
                    showTime: true,
                    remaining: remaining,
                    total: total
                )
            }
        }
    }
}

#Preview {
    WorkoutView()
}


