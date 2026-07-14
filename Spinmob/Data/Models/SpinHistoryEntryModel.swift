import Foundation
import SwiftData

@Model
final class SpinHistoryEntryModel {
    @Attribute(.unique) var id: UUID
    var spinSetID: UUID
    var resultLabel: String
    var resultStickerEmoji: String?
    var playerName: String?
    var date: Date

    init(
        id: UUID,
        spinSetID: UUID,
        resultLabel: String,
        resultStickerEmoji: String?,
        playerName: String?,
        date: Date
    ) {
        self.id = id
        self.spinSetID = spinSetID
        self.resultLabel = resultLabel
        self.resultStickerEmoji = resultStickerEmoji
        self.playerName = playerName
        self.date = date
    }
}

extension SpinHistoryEntryModel {
    var asEntity: SpinHistoryEntry {
        SpinHistoryEntry(
            id: id,
            spinSetID: spinSetID,
            resultLabel: resultLabel,
            resultStickerEmoji: resultStickerEmoji,
            playerName: playerName,
            date: date
        )
    }
}

extension SpinHistoryEntry {
    var asModel: SpinHistoryEntryModel {
        SpinHistoryEntryModel(
            id: id,
            spinSetID: spinSetID,
            resultLabel: resultLabel,
            resultStickerEmoji: resultStickerEmoji,
            playerName: playerName,
            date: date
        )
    }
}
