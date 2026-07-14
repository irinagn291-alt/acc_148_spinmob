import SwiftUI

/// "Curse streak" callout — surfaces whoever the wheel seems to love picking.
struct CurseStreakBanner: View {
    let summary: CurseStreakSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let cursed = summary.mostCursedLabel {
                Text("🔮 Party curse: «\(cursed)» got picked the most")
                    .font(.subheadline.bold())
                    .foregroundStyle(AppColor.text)
            }
            if let streakLabel = summary.currentStreakLabel, summary.currentStreakCount > 1 {
                Text("«\(streakLabel)» has landed \(summary.currentStreakCount) times in a row!")
                    .font(.caption)
                    .foregroundStyle(AppColor.accent)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppMetrics.cardPadding)
        .background(AppColor.surface, in: RoundedRectangle(cornerRadius: AppMetrics.cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppMetrics.cornerRadius, style: .continuous)
                .stroke(AppColor.primary.opacity(0.5), lineWidth: 1)
        )
    }
}

#Preview {
    ZStack {
        AppColor.background.ignoresSafeArea()
        CurseStreakBanner(summary: CurseStreakSummary(
            totalSpins: 12,
            frequencies: [],
            mostCursedLabel: "Anna",
            currentStreakLabel: "Anna",
            currentStreakCount: 3
        ))
        .padding()
    }
}
