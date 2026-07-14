import Charts
import SwiftUI

/// Swift Charts breakdown of how often each option got picked for the selected set.
struct PickFrequencyChartView: View {
    let frequencies: [CurseStreakSummary.Frequency]

    private let palette: [Color] = [AppColor.primary, AppColor.secondary, AppColor.accent]

    var body: some View {
        Chart(Array(frequencies.enumerated()), id: \.element.id) { index, frequency in
            BarMark(
                x: .value("Count", frequency.count),
                y: .value("Option", frequency.label)
            )
            .foregroundStyle(palette[index % palette.count])
            .cornerRadius(6)
        }
        .chartXAxis {
            AxisMarks { _ in
                AxisGridLine().foregroundStyle(AppColor.text.opacity(0.15))
                AxisValueLabel().foregroundStyle(AppColor.text.opacity(0.7))
            }
        }
        .chartYAxis {
            AxisMarks { _ in
                AxisValueLabel().foregroundStyle(AppColor.text.opacity(0.85))
            }
        }
        .frame(height: max(140, CGFloat(frequencies.count) * 36))
    }
}

#Preview {
    ZStack {
        AppColor.background.ignoresSafeArea()
        PickFrequencyChartView(frequencies: [
            .init(label: "Anna", stickerEmoji: nil, count: 7, fraction: 0.5),
            .init(label: "Bob", stickerEmoji: nil, count: 4, fraction: 0.3),
            .init(label: "Vic", stickerEmoji: nil, count: 2, fraction: 0.2)
        ])
        .padding()
    }
}
