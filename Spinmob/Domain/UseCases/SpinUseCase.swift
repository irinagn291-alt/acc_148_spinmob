import Foundation

/// Pure weighted-random pick from a `SpinSet`'s segments. Given the same segments and
/// seed it always returns the same result, which keeps it trivially unit-testable —
/// the only non-determinism in a real spin is the seed itself.
protocol SpinUseCase: Sendable {
    func execute(segments: [SpinSegment], seed: UInt64) -> SpinSegment?
}

struct WeightedRandomSpinUseCase: SpinUseCase {
    func execute(segments: [SpinSegment], seed: UInt64) -> SpinSegment? {
        guard !segments.isEmpty else { return nil }

        let totalWeight = segments.reduce(0) { $0 + max($1.weight, 0) }
        guard totalWeight > 0 else { return segments[0] }

        var generator = SeededRandomNumberGenerator(seed: seed)
        let target = Double.random(in: 0..<totalWeight, using: &generator)

        var cumulative = 0.0
        for segment in segments {
            cumulative += max(segment.weight, 0)
            if target < cumulative {
                return segment
            }
        }
        return segments.last
    }
}
