import SwiftUI

struct HistoryView: View {
    @State var viewModel: HistoryViewModel

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()

    var body: some View {
        NavigationStack {
            ZStack {
                AppColor.background.ignoresSafeArea()

                if viewModel.spinSets.isEmpty {
                    emptyState
                } else {
                    content
                }
            }
            .navigationTitle("History")
            .task { await viewModel.loadSpinSets() }
        }
    }

    private var content: some View {
        ScrollView {
            VStack(spacing: 20) {
                setPicker

                if viewModel.history.isEmpty {
                    Text("Nothing here yet — spin the wheel at least once.")
                        .font(.subheadline)
                        .foregroundStyle(AppColor.text.opacity(0.7))
                        .padding(.top, 40)
                } else {
                    CurseStreakBanner(summary: viewModel.curseStreak)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Pick Frequency")
                            .font(.headline)
                            .foregroundStyle(AppColor.text)
                        PickFrequencyChartView(frequencies: viewModel.curseStreak.frequencies)
                    }
                    .padding(AppMetrics.cardPadding)
                    .background(AppColor.surface, in: RoundedRectangle(cornerRadius: AppMetrics.cornerRadius, style: .continuous))

                    VStack(alignment: .leading, spacing: 0) {
                        Text("Spin Log")
                            .font(.headline)
                            .foregroundStyle(AppColor.text)
                            .padding(.bottom, 8)

                        ForEach(viewModel.history) { entry in
                            historyRow(entry)
                        }
                    }
                }
            }
            .padding()
        }
    }

    private var setPicker: some View {
        Picker("Set", selection: Binding(
            get: { viewModel.selectedSpinSetID },
            set: { newValue in
                guard let newValue else { return }
                Task { await viewModel.selectSpinSet(id: newValue) }
            }
        )) {
            ForEach(viewModel.spinSets) { spinSet in
                Text(spinSet.name).tag(Optional(spinSet.id))
            }
        }
        .pickerStyle(.menu)
        .tint(AppColor.accent)
    }

    private func historyRow(_ entry: SpinHistoryEntry) -> some View {
        HStack {
            Text([entry.resultStickerEmoji, entry.resultLabel].compactMap { $0 }.joined(separator: " "))
                .font(.body.bold())
                .foregroundStyle(AppColor.text)
            Spacer()
            if let player = entry.playerName {
                Text(player)
                    .font(.caption.bold())
                    .foregroundStyle(AppColor.secondary)
            }
            Text(dateFormatter.string(from: entry.date))
                .font(.caption)
                .foregroundStyle(AppColor.text.opacity(0.5))
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(AppColor.surface.opacity(0.6), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 56))
                .foregroundStyle(AppColor.secondary)
            Text("The wheel is empty. Add names or dares — let's go!")
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .foregroundStyle(AppColor.text)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
}

#Preview {
    HistoryView(viewModel: HistoryViewModel(dependencies: .previewInstance))
}
