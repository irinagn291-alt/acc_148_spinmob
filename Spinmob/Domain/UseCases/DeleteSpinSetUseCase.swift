import Foundation

protocol DeleteSpinSetUseCase: Sendable {
    func execute(id: UUID) async throws
}

/// Deleting a set also clears its history so the dashboard never shows orphaned spins.
struct DefaultDeleteSpinSetUseCase: DeleteSpinSetUseCase {
    let spinSetRepository: SpinSetRepository
    let spinHistoryRepository: SpinHistoryRepository

    func execute(id: UUID) async throws {
        try await spinHistoryRepository.deleteAll(spinSetID: id)
        try await spinSetRepository.delete(id: id)
    }
}
