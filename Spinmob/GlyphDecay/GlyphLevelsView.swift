import SwiftUI

struct GlyphLevelsView: View {
    @EnvironmentObject var store: GlyphStore

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                header
                menuContent
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 28)
        }
        .background(GlyphTheme.bgDeep.ignoresSafeArea())
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(PuzzleSkin.title)
                .font(GlyphTheme.titleFont)
                .foregroundStyle(GlyphTheme.textPrimary)
            Text(PuzzleSkin.tagline)
                .font(GlyphTheme.bodyFont)
                .foregroundStyle(GlyphTheme.textMuted)
            Text("\(store.completedCount)/\(store.totalCount) complete")
                .font(.caption.bold())
                .foregroundStyle(GlyphTheme.teal)
        }
    }

    @ViewBuilder
    private var menuContent: some View {
        switch PuzzleSkin.menuStyle {
        case .carousel:
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(store.levels) { level in
                        levelTile(level).frame(width: 140)
                    }
                }
            }
        case .chapters:
            VStack(spacing: 10) {
                ForEach(store.levels) { level in
                    chapterRow(level)
                }
            }
        case .path:
            VStack(spacing: 0) {
                ForEach(Array(store.levels.enumerated()), id: \.element.id) { index, level in
                    HStack(alignment: .top, spacing: 12) {
                        VStack(spacing: 0) {
                            Circle()
                                .fill(store.isUnlocked(level) ? GlyphTheme.ember : GlyphTheme.lockGray)
                                .frame(width: 12, height: 12)
                            if index < store.levels.count - 1 {
                                Rectangle().fill(GlyphTheme.stoneEdge).frame(width: 2, height: 44)
                            }
                        }
                        levelTile(level)
                    }
                }
            }
        case .strip:
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(store.levels) { level in
                        stripChip(level)
                    }
                }
            }
        case .rows:
            VStack(spacing: 8) {
                ForEach(store.levels) { level in
                    rowEntry(level)
                }
            }
        case .barn:
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(store.levels) { level in
                    levelTile(level)
                }
            }
        case .softCards:
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 12)], spacing: 12) {
                ForEach(store.levels) { level in
                    levelTile(level)
                }
            }
        }
    }

    private func levelTile(_ level: GlyphLevel) -> some View {
        let unlocked = store.isUnlocked(level)
        let completed = store.progress.isCompleted(level.id)
        return Button {
            if unlocked { store.startLevel(level) }
        } label: {
            VStack(spacing: 6) {
                Text(unlocked ? (completed ? "✓" : "\(level.id)") : "🔒")
                    .font(.title2.bold())
                Text(PuzzleSkin.levelName(for: level))
                    .font(.caption.bold())
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                Text("\(level.board.rows)×\(level.board.cols)")
                    .font(.caption2)
                    .foregroundStyle(GlyphTheme.textFaint)
            }
            .foregroundStyle(unlocked ? GlyphTheme.textPrimary : GlyphTheme.textFaint)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: GlyphTheme.cellCorner)
                    .fill(GlyphTheme.bgPanel)
                    .overlay(RoundedRectangle(cornerRadius: GlyphTheme.cellCorner)
                        .stroke(completed ? GlyphTheme.success : GlyphTheme.stoneEdge, lineWidth: 1))
            )
            .opacity(unlocked ? 1 : 0.55)
        }
        .buttonStyle(.plain)
        .disabled(!unlocked)
    }

    private func chapterRow(_ level: GlyphLevel) -> some View {
        let unlocked = store.isUnlocked(level)
        return Button {
            if unlocked { store.startLevel(level) }
        } label: {
            HStack {
                Text("Ch.\(level.id)")
                    .font(.caption.bold().monospacedDigit())
                    .foregroundStyle(GlyphTheme.teal)
                    .frame(width: 44)
                VStack(alignment: .leading, spacing: 2) {
                    Text(PuzzleSkin.levelName(for: level))
                        .font(.subheadline.bold())
                    Text("\(level.board.rows)×\(level.board.cols)")
                        .font(.caption2)
                        .foregroundStyle(GlyphTheme.textFaint)
                }
                Spacer()
                if store.progress.isCompleted(level.id) {
                    Image(systemName: "checkmark.seal.fill").foregroundStyle(GlyphTheme.success)
                }
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 8).fill(GlyphTheme.bgPanel))
            .opacity(unlocked ? 1 : 0.5)
        }
        .buttonStyle(.plain)
        .disabled(!unlocked)
    }

    private func stripChip(_ level: GlyphLevel) -> some View {
        let unlocked = store.isUnlocked(level)
        return Button {
            if unlocked { store.startLevel(level) }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: "mappin.circle.fill")
                Text("\(level.id)")
                    .font(.caption.bold())
            }
            .padding(10)
            .background(Capsule().fill(unlocked ? GlyphTheme.bgPanel : GlyphTheme.stoneInset))
            .foregroundStyle(unlocked ? GlyphTheme.textPrimary : GlyphTheme.textFaint)
        }
        .buttonStyle(.plain)
        .disabled(!unlocked)
    }

    private func rowEntry(_ level: GlyphLevel) -> some View {
        let unlocked = store.isUnlocked(level)
        return Button {
            if unlocked { store.startLevel(level) }
        } label: {
            HStack {
                Text(String(format: "%02d", level.id))
                    .font(.caption.monospacedDigit().bold())
                    .foregroundStyle(GlyphTheme.teal)
                    .frame(width: 28)
                Text(PuzzleSkin.levelName(for: level))
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(level.board.rows)×\(level.board.cols)")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(GlyphTheme.textFaint)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(RoundedRectangle(cornerRadius: 4).fill(GlyphTheme.bgPanel))
            .opacity(unlocked ? 1 : 0.5)
        }
        .buttonStyle(.plain)
        .disabled(!unlocked)
    }
}
