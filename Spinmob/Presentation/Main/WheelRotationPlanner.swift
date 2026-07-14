import Foundation

/// Pure geometry helper: computes the next clockwise rotation (in degrees) that lands
/// the wheel's fixed top pointer on the centre of `targetIndex`, always spinning
/// further forward than `currentDegrees` so the wheel never visually jumps backward.
struct WheelRotationPlanner {
    func nextRotation(
        segmentCount: Int,
        targetIndex: Int,
        currentDegrees: Double,
        minimumFullSpins: Int = 6
    ) -> Double {
        guard segmentCount > 0 else { return currentDegrees }

        let degreesPerSegment = 360.0 / Double(segmentCount)
        let targetRestingAngle = normalize(-Double(targetIndex) * degreesPerSegment)
        let currentRestingAngle = normalize(currentDegrees)

        var delta = targetRestingAngle - currentRestingAngle
        if delta <= 0 { delta += 360 }

        return currentDegrees + Double(minimumFullSpins) * 360 + delta
    }

    private func normalize(_ degrees: Double) -> Double {
        let remainder = degrees.truncatingRemainder(dividingBy: 360)
        return remainder < 0 ? remainder + 360 : remainder
    }
}
