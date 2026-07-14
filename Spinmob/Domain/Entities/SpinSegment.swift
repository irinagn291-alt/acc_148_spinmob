import Foundation

/// One slice of a `SpinSet` — a single name, dare, or party prompt the wheel can land on.
struct SpinSegment: Identifiable, Equatable, Sendable, Hashable {
    let id: UUID
    var label: String
    var stickerEmoji: String?
    /// Relative pick weight used by `SpinUseCase`. Equal weights (1) give equal odds;
    /// the wheel is always drawn with equal-sized slices regardless of weight.
    var weight: Double

    init(id: UUID = UUID(), label: String, stickerEmoji: String? = nil, weight: Double = 1) {
        self.id = id
        self.label = label
        self.stickerEmoji = stickerEmoji
        self.weight = max(weight, 0.1)
    }
}
