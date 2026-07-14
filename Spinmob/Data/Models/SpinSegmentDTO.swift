import Foundation

/// Codable wire-format for a segment, embedded as an array attribute on `SpinSetModel`.
/// SwiftData stores `[SpinSegmentDTO]` directly, so segments never need their own
/// `@Model` type or relationship plumbing.
struct SpinSegmentDTO: Codable, Sendable {
    var id: UUID
    var label: String
    var stickerEmoji: String?
    var weight: Double
}

extension SpinSegmentDTO {
    var asEntity: SpinSegment {
        SpinSegment(id: id, label: label, stickerEmoji: stickerEmoji, weight: weight)
    }
}

extension SpinSegment {
    var asDTO: SpinSegmentDTO {
        SpinSegmentDTO(id: id, label: label, stickerEmoji: stickerEmoji, weight: weight)
    }
}
