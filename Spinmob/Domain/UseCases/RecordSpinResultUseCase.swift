import Foundation

/// Persists the "moment of outcome" once the wheel settles.
protocol RecordSpinResultUseCase: Sendable {
    func execute(spinSetID: UUID, result: SpinSegment, playerName: String?) async throws -> SpinHistoryEntry
}

struct DefaultRecordSpinResultUseCase: RecordSpinResultUseCase {
    let spinHistoryRepository: SpinHistoryRepository

    func execute(spinSetID: UUID, result: SpinSegment, playerName: String?) async throws -> SpinHistoryEntry {
        let entry = SpinHistoryEntry(
            spinSetID: spinSetID,
            resultLabel: result.label,
            resultStickerEmoji: result.stickerEmoji,
            playerName: playerName
        )
        try await spinHistoryRepository.add(entry)
        return entry
    }
}
