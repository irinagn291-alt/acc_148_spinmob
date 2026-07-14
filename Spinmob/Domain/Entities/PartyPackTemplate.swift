import Foundation

/// A ready-made, built-in catalog entry that can be imported into a fresh `SpinSet`.
/// Pure SFW content by default; any "adult" pack must set `isAdultContent` so the
/// presentation layer can hide it until the 17+ gate in Settings is confirmed.
struct PartyPackTemplate: Identifiable, Equatable, Sendable {
    let id: String
    let name: String
    let emoji: String
    let isAdultContent: Bool
    let segmentLabels: [(label: String, sticker: String?)]

    static func == (lhs: PartyPackTemplate, rhs: PartyPackTemplate) -> Bool {
        lhs.id == rhs.id
    }

    func makeSegments() -> [SpinSegment] {
        segmentLabels.map { SpinSegment(label: $0.label, stickerEmoji: $0.sticker) }
    }
}

extension PartyPackTemplate {
    /// The two free, SFW packs promised by the spec's monetization note
    /// ("Free: basic wheel + 2 packs").
    static let truthOrDare = PartyPackTemplate(
        id: "truth-or-dare",
        name: "Truth or Dare",
        emoji: "🎭",
        isAdultContent: false,
        segmentLabels: [
            ("Truth", "🤐"),
            ("Dare", "🔥"),
            ("Truth", "🤐"),
            ("Dare", "🔥"),
            ("Truth", "🤐"),
            ("Dare", "🔥")
        ]
    )

    static let whoPaysForPizza = PartyPackTemplate(
        id: "who-pays-pizza",
        name: "Who Pays for Pizza",
        emoji: "🍕",
        isAdultContent: false,
        segmentLabels: [
            ("You're paying!", "🍕"),
            ("You got lucky this time", "😌"),
            ("You're paying!", "🍕"),
            ("You got lucky this time", "😌")
        ]
    )

    /// Gated 17+ pack — alcohol-themed party prompts. Hidden unless the age gate
    /// in Settings has been explicitly confirmed. No money or stakes involved.
    static let afterHours = PartyPackTemplate(
        id: "after-hours-17",
        name: "After Midnight",
        emoji: "🥂",
        isAdultContent: true,
        segmentLabels: [
            ("Take a sip", "🥂"),
            ("Share a secret", "🤫"),
            ("Take a sip", "🥂"),
            ("10-second dance", "💃"),
            ("Take a sip", "🥂"),
            ("Compliment your neighbor", "😘")
        ]
    )

    static let all: [PartyPackTemplate] = [.truthOrDare, .whoPaysForPizza, .afterHours]
}
