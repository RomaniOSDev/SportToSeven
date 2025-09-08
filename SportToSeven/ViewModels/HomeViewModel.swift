import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published private(set) var streakDays: Int = 0
    @Published private(set) var todaySeconds: Int = 0

    private var cancellables: Set<AnyCancellable> = []
    private let store: LocalStore

    init(store: LocalStore = .shared) {
        self.store = store
        refresh()
    }

    func refresh() {
        streakDays = store.streakDays
        todaySeconds = store.dailySeconds()
    }
}



