import Foundation
import Observation

@Observable
@MainActor
final class HistoryViewModel {
    private let dependencies: AppDependencies

    private(set) var spinSets: [SpinSet] = []
    var selectedSpinSetID: UUID?
    private(set) var history: [SpinHistoryEntry] = []
    private(set) var curseStreak: CurseStreakSummary = .empty
    private(set) var isLoading = false
    var errorMessage: String?

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    var selectedSpinSet: SpinSet? {
        spinSets.first { $0.id == selectedSpinSetID }
    }

    func loadSpinSets() async {
        do {
            spinSets = try await dependencies.fetchSpinSetsUseCase.execute()
            if selectedSpinSetID == nil || !spinSets.contains(where: { $0.id == selectedSpinSetID }) {
                selectedSpinSetID = spinSets.first?.id
            }
            await loadHistory()
        } catch {
            errorMessage = "Couldn't load sets."
        }
    }

    func selectSpinSet(id: UUID) async {
        selectedSpinSetID = id
        await loadHistory()
    }

    func loadHistory() async {
        guard let id = selectedSpinSetID else {
            history = []
            curseStreak = .empty
            return
        }
        isLoading = true
        defer { isLoading = false }
        do {
            history = try await dependencies.fetchSpinHistoryUseCase.execute(spinSetID: id)
            curseStreak = dependencies.computeCurseStreakUseCase.execute(history: history)
        } catch {
            errorMessage = "Couldn't load history."
        }
    }
}
