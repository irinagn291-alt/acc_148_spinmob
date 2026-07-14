import Foundation

/// A single recorded outcome of a spin — the "moment of outcome" journal entry.
struct SpinHistoryEntry: Identifiable, Equatable, Sendable, Hashable {
    let id: UUID
    let spinSetID: UUID
    let resultLabel: String
    let resultStickerEmoji: String?
    /// Whose turn it was when this result landed, if the set has multiple players.
    let playerName: String?
    let date: Date

    init(
        id: UUID = UUID(),
        spinSetID: UUID,
        resultLabel: String,
        resultStickerEmoji: String? = nil,
        playerName: String? = nil,
        date: Date = .now
    ) {
        self.id = id
        self.spinSetID = spinSetID
        self.resultLabel = resultLabel
        self.resultStickerEmoji = resultStickerEmoji
        self.playerName = playerName
        self.date = date
    }
}
