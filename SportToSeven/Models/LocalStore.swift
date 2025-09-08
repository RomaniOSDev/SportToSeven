import Foundation

final class LocalStore {
    static let shared = LocalStore()

    private let userDefaults = UserDefaults.standard
    private let streakKey = "streak.days"
    private let lastWorkoutDateKey = "streak.lastDate"
    private let historyKey = "workout.history" // [String: Int] dateString -> seconds
    private let customWorkoutsKey = "custom.workouts"

    private init() {}

    var streakDays: Int {
        get { userDefaults.integer(forKey: streakKey) }
        set { userDefaults.set(newValue, forKey: streakKey) }
    }

    var lastWorkoutDate: Date? {
        get { userDefaults.object(forKey: lastWorkoutDateKey) as? Date }
        set { userDefaults.set(newValue, forKey: lastWorkoutDateKey) }
    }

    func recordWorkout(totalSeconds: Int, on date: Date = Date()) {
        updateStreakIfNeeded(finishedOn: date)

        var history = (userDefaults.dictionary(forKey: historyKey) as? [String: Int]) ?? [:]
        let key = Self.dateKey(from: date)
        history[key, default: 0] += totalSeconds
        userDefaults.set(history, forKey: historyKey)
    }

    func dailySeconds(for date: Date = Date()) -> Int {
        let history = (userDefaults.dictionary(forKey: historyKey) as? [String: Int]) ?? [:]
        return history[Self.dateKey(from: date)] ?? 0
    }

    private func updateStreakIfNeeded(finishedOn date: Date) {
        defer { lastWorkoutDate = date }

        guard let last = lastWorkoutDate else {
            streakDays = 1
            return
        }

        let calendar = Calendar.current
        if calendar.isDate(date, inSameDayAs: last) {
            return
        }

        if let yesterday = calendar.date(byAdding: .day, value: -1, to: date), calendar.isDate(last, inSameDayAs: yesterday) {
            streakDays += 1
        } else {
            streakDays = 1
        }
    }

    // MARK: - Custom Workouts
    var customWorkouts: [CustomWorkout] {
        get {
            guard let data = userDefaults.data(forKey: customWorkoutsKey),
                  let workouts = try? JSONDecoder().decode([CustomWorkout].self, from: data) else {
                return CustomWorkoutLibrary.defaultWorkouts
            }
            return workouts
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                userDefaults.set(data, forKey: customWorkoutsKey)
            }
        }
    }
    
    func saveCustomWorkout(_ workout: CustomWorkout) {
        var workouts = customWorkouts
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index] = workout
        } else {
            workouts.append(workout)
        }
        customWorkouts = workouts
    }
    
    func deleteCustomWorkout(_ workout: CustomWorkout) {
        var workouts = customWorkouts
        workouts.removeAll { $0.id == workout.id }
        customWorkouts = workouts
    }

    private static func dateKey(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}


