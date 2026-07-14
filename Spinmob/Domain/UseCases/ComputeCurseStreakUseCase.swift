import Foundation

/// Builds the pick-frequency breakdown and "curse streak" shown on the Dashboard.
protocol ComputeCurseStreakUseCase: Sendable {
    func execute(history: [SpinHistoryEntry]) -> CurseStreakSummary
}

struct DefaultComputeCurseStreakUseCase: ComputeCurseStreakUseCase {
    func execute(history: [SpinHistoryEntry]) -> CurseStreakSummary {
        guard !history.isEmpty else { return .empty }

        var counts: [String: Int] = [:]
        var stickerByLabel: [String: String?] = [:]
        for entry in history {
            counts[entry.resultLabel, default: 0] += 1
            stickerByLabel[entry.resultLabel] = entry.resultStickerEmoji
        }

        let total = history.count
        let frequencies = counts
            .map { label, count in
                CurseStreakSummary.Frequency(
                    label: label,
                    stickerEmoji: stickerByLabel[label] ?? nil,
                    count: count,
                    fraction: Double(count) / Double(total)
                )
            }
            .sorted { $0.count > $1.count }

        let sortedByDate = history.sorted { $0.date > $1.date }
        var streakCount = 0
        var streakLabel: String?
        for entry in sortedByDate {
            if streakLabel == nil {
                streakLabel = entry.resultLabel
                streakCount = 1
            } else if entry.resultLabel == streakLabel {
                streakCount += 1
            } else {
                break
            }
        }

        return CurseStreakSummary(
            totalSpins: total,
            frequencies: frequencies,
            mostCursedLabel: frequencies.first?.label,
            currentStreakLabel: streakCount > 1 ? streakLabel : nil,
            currentStreakCount: streakCount
        )
    }
}
