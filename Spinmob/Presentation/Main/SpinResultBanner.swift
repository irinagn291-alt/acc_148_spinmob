import SwiftUI

/// The "moment of outcome" card that appears once the wheel settles.
struct SpinResultBanner: View {
    let result: SpinSegment
    let playerName: String?

    var body: some View {
        VStack(spacing: 6) {
            if let playerName {
                Text(playerName.uppercased())
                    .font(.caption.bold())
                    .foregroundStyle(AppColor.accent)
            }
            Text([result.stickerEmoji, result.label].compactMap { $0 }.joined(separator: " "))
                .font(.system(.title2, design: .rounded, weight: .black))
                .foregroundStyle(AppColor.text)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 28)
        .background(AppColor.surface, in: RoundedRectangle(cornerRadius: AppMetrics.cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppMetrics.cornerRadius, style: .continuous)
                .stroke(AppColor.primary, lineWidth: 1.5)
        )
        .neonGlow(AppColor.primary, radius: 14)
        .transition(.scale.combined(with: .opacity))
    }
}

#Preview {
    ZStack {
        AppColor.background.ignoresSafeArea()
        SpinResultBanner(result: SpinSegment(label: "Dare", stickerEmoji: "🔥"), playerName: "Anna")
    }
}
