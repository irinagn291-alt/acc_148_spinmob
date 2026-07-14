import Foundation
import SwiftData

@Model
final class SpinSetModel {
    @Attribute(.unique) var id: UUID
    var name: String
    var segments: [SpinSegmentDTO]
    var playerNames: [String]
    var isAdultContent: Bool
    var createdAt: Date

    init(
        id: UUID,
        name: String,
        segments: [SpinSegmentDTO],
        playerNames: [String],
        isAdultContent: Bool,
        createdAt: Date
    ) {
        self.id = id
        self.name = name
        self.segments = segments
        self.playerNames = playerNames
        self.isAdultContent = isAdultContent
        self.createdAt = createdAt
    }
}

extension SpinSetModel {
    var asEntity: SpinSet {
        SpinSet(
            id: id,
            name: name,
            segments: segments.map(\.asEntity),
            playerNames: playerNames,
            isAdultContent: isAdultContent,
            createdAt: createdAt
        )
    }

    func update(from spinSet: SpinSet) {
        name = spinSet.name
        segments = spinSet.segments.map(\.asDTO)
        playerNames = spinSet.playerNames
        isAdultContent = spinSet.isAdultContent
    }
}

extension SpinSet {
    var asModel: SpinSetModel {
        SpinSetModel(
            id: id,
            name: name,
            segments: segments.map(\.asDTO),
            playerNames: playerNames,
            isAdultContent: isAdultContent,
            createdAt: createdAt
        )
    }
}
