import Foundation

/// A named, reusable list of wheel options — a group of names, a truth/dare pack, etc.
struct SpinSet: Identifiable, Equatable, Sendable, Hashable {
    let id: UUID
    var name: String
    var segments: [SpinSegment]
    /// Names of people taking turns spinning this set on one shared device.
    /// Empty means single-player / no turn rotation.
    var playerNames: [String]
    /// Packs gated behind the 17+ confirmation in Settings (e.g. an alcohol prompt pack).
    var isAdultContent: Bool
    let createdAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        segments: [SpinSegment] = [],
        playerNames: [String] = [],
        isAdultContent: Bool = false,
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.segments = segments
        self.playerNames = playerNames
        self.isAdultContent = isAdultContent
        self.createdAt = createdAt
    }

    var isEmpty: Bool { segments.isEmpty }
    var supportsMultiplayer: Bool { playerNames.count > 1 }
}
