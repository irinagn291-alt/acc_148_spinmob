import SwiftUI

/// Draws the wheel itself — equal-sized neon wedges, one per segment. The fixed
/// pointer lives outside this view; only the wedges rotate.
struct WheelView: View {
    let segments: [SpinSegment]

    private let palette: [Color] = [
        AppColor.primary, AppColor.secondary, AppColor.accent,
        AppColor.primary.opacity(0.65), AppColor.secondary.opacity(0.65), AppColor.accent.opacity(0.65)
    ]

    var body: some View {
        Canvas { context, size in
            guard !segments.isEmpty else { return }
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2 - 4
            let degreesPerSegment = 360.0 / Double(segments.count)

            for (index, segment) in segments.enumerated() {
                let startDegrees = -90 + Double(index) * degreesPerSegment - degreesPerSegment / 2
                let endDegrees = startDegrees + degreesPerSegment

                var wedge = Path()
                wedge.move(to: center)
                wedge.addArc(
                    center: center,
                    radius: radius,
                    startAngle: .degrees(startDegrees),
                    endAngle: .degrees(endDegrees),
                    clockwise: false
                )
                wedge.closeSubpath()

                context.fill(wedge, with: .color(palette[index % palette.count]))
                context.stroke(wedge, with: .color(AppColor.background), lineWidth: 2)

                let midDegrees = startDegrees + degreesPerSegment / 2
                let midRadians = midDegrees * .pi / 180
                let labelRadius = radius * 0.62
                let labelPoint = CGPoint(
                    x: center.x + labelRadius * cos(midRadians),
                    y: center.y + labelRadius * sin(midRadians)
                )

                let labelText = [segment.stickerEmoji, segment.label]
                    .compactMap { $0 }
                    .joined(separator: " ")
                context.draw(
                    Text(labelText)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white),
                    at: labelPoint,
                    anchor: .center
                )
            }

            var hub = Path()
            hub.addEllipse(in: CGRect(x: center.x - 14, y: center.y - 14, width: 28, height: 28))
            context.fill(hub, with: .color(AppColor.background))
            context.stroke(hub, with: .color(AppColor.accent), lineWidth: 2)
        }
    }
}

/// Fixed downward-pointing chrome arrow that marks the winning segment.
struct WheelPointer: View {
    var body: some View {
        Triangle()
            .fill(AppColor.accent)
            .frame(width: 28, height: 24)
            .neonGlow(AppColor.accent, radius: 8)
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ZStack {
        AppColor.background.ignoresSafeArea()
        WheelView(segments: PartyPackTemplate.truthOrDare.makeSegments())
            .padding(32)
    }
}
