import Foundation
import Combine

final class WorkoutViewModel: ObservableObject {
    enum Phase: Equatable {
        case ready
        case work(Exercise, remaining: Int)
        case rest(remaining: Int)
        case finished
    }

    @Published private(set) var phase: Phase = .ready
    @Published private(set) var exercises: [Exercise] = []
    @Published private(set) var currentIndex: Int = 0
    @Published private(set) var totalRemaining: Int = 7 * 60

    private var timerCancellable: AnyCancellable?
    private let workDuration = 30
    private let restDuration = 10
    private let totalDuration = 7 * 60
    private let store: LocalStore

    init(store: LocalStore = .shared) {
        self.store = store
        self.exercises = Array(ExerciseLibrary.all.shuffled().prefix(12))
        recalcTotalRemaining()
    }

    func start() {
        guard case .ready = phase else { return }
        currentIndex = 0
        phase = .work(exercises[currentIndex], remaining: workDuration)
        startTicking()
    }

    func stop() {
        timerCancellable?.cancel()
        timerCancellable = nil
        phase = .finished
    }

    private func startTicking() {
        timerCancellable?.cancel()
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    private func tick() {
        recalcTotalRemaining()

        switch phase {
        case .ready:
            break
        case .work(let exercise, let remaining):
            if remaining > 1 {
                phase = .work(exercise, remaining: remaining - 1)
            } else {
                phase = .rest(remaining: restDuration)
            }
        case .rest(let remaining):
            if remaining > 1 {
                phase = .rest(remaining: remaining - 1)
            } else {
                advanceExerciseOrFinish()
            }
        case .finished:
            break
        }
    }

    private func advanceExerciseOrFinish() {
        if currentIndex + 1 < exercises.count {
            currentIndex += 1
            phase = .work(exercises[currentIndex], remaining: workDuration)
        } else {
            timerCancellable?.cancel()
            timerCancellable = nil
            phase = .finished
            store.recordWorkout(totalSeconds: totalDuration)
        }
    }

    private func recalcTotalRemaining() {
        switch phase {
        case .ready:
            totalRemaining = totalDuration
        case .finished:
            totalRemaining = 0
        case .work(_, let remaining):
            let spentExercises = currentIndex
            let remainingWork = remaining
            let remainingRest = restDuration
            let leftExercises = max(0, exercises.count - spentExercises - 1)
            totalRemaining = leftExercises * (workDuration + restDuration) + remainingRest + remainingWork
        case .rest(let remaining):
            let spentExercises = currentIndex + 1
            let leftExercises = max(0, exercises.count - spentExercises)
            totalRemaining = leftExercises * (workDuration + restDuration) + remaining
        }
    }
}



