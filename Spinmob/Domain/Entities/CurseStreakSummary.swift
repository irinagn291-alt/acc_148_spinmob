import Foundation

/// "Curse streak": surfaces whichever label gets picked suspiciously often,
/// plus how many times in a row it just landed.
struct CurseStreakSummary: Equatable, Sendable {
    struct Frequency: Identifiable, Equatable, Sendable {
        var id: String { label }
        let label: String
        let stickerEmoji: String?
        let count: Int
        let fraction: Double
    }

    let totalSpins: Int
    let frequencies: [Frequency]
    let mostCursedLabel: String?
    let currentStreakLabel: String?
    let currentStreakCount: Int

    static let empty = CurseStreakSummary(
        totalSpins: 0,
        frequencies: [],
        mostCursedLabel: nil,
        currentStreakLabel: nil,
        currentStreakCount: 0
    )
}
