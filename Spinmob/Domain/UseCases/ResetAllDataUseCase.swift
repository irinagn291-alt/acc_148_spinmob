import Foundation

/// Wipes every spin set and history entry — used by Settings' "reset" action.
protocol ResetAllDataUseCase: Sendable {
    func execute() async throws
}

struct DefaultResetAllDataUseCase: ResetAllDataUseCase {
    let spinSetRepository: SpinSetRepository
    let spinHistoryRepository: SpinHistoryRepository

    func execute() async throws {
        try await spinHistoryRepository.deleteAll()
        let sets = try await spinSetRepository.fetchAll()
        for spinSet in sets {
            try await spinSetRepository.delete(id: spinSet.id)
        }
    }
}
