import Foundation

protocol FetchSpinHistoryUseCase: Sendable {
    func execute(spinSetID: UUID) async throws -> [SpinHistoryEntry]
}

struct DefaultFetchSpinHistoryUseCase: FetchSpinHistoryUseCase {
    let spinHistoryRepository: SpinHistoryRepository

    func execute(spinSetID: UUID) async throws -> [SpinHistoryEntry] {
        try await spinHistoryRepository.fetchAll(spinSetID: spinSetID)
    }
}
