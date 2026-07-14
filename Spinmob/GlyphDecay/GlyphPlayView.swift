import SwiftUI

struct GlyphPlayView: View {
    @EnvironmentObject var store: GlyphStore
    @State private var selected: GlyphKind = .boost

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppColor.background, Color(hex: "#120028"), AppColor.background],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            if let session = store.session {
                VStack(spacing: 16) {
                    topBar(session)
                    goalBanner
                    Spacer(minLength: 0)
                    boardSection(session)
                    Spacer(minLength: 0)
                    glyphDock(session)
                    actionBar(session)
                }
                .padding(.bottom, 12)

                if session.won { winOverlay(session) }
                else if session.failed { failOverlay(session) }
            }
        }
        .onAppear {
            if let s = store.session { selected = s.level.allowedGlyphs.first ?? .boost }
        }
    }

    private var goalBanner: some View {
        Text(PuzzleSkin.goalLine)
            .font(.system(.footnote, design: .rounded).weight(.semibold))
            .foregroundStyle(AppColor.text.opacity(0.75))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 28)
    }

    private func boardSection(_ session: GlyphSession) -> some View {
        GlyphBoardView(
            board: session.board,
            target: session.level.target,
            interactive: !session.won && !session.failed
        ) { r, c in
            store.place(selected, at: r, c)
            PuzzleHaptics.tap()
            if let s = store.session, s.won { PuzzleHaptics.win() }
        }
        .frame(maxWidth: 340, maxHeight: 340)
        .padding(.horizontal, 20)
    }

    private func topBar(_ session: GlyphSession) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Button { store.session = nil } label: {
                Image(systemName: "xmark")
                    .font(.headline.bold())
                    .foregroundStyle(AppColor.text)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(AppColor.surface))
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(PuzzleSkin.levelName(for: session.level))
                    .font(.system(.title3, design: .rounded, weight: .black))
                    .foregroundStyle(AppColor.text)
                Text("Stage \(session.level.id)")
                    .font(.caption.bold())
                    .foregroundStyle(AppColor.secondary)
            }

            Spacer()

            VStack(spacing: 2) {
                Text("\(session.movesLeft)")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundStyle(session.movesLeft <= 2 ? Color.red : AppColor.secondary)
                    .neonGlow(AppColor.secondary, radius: session.movesLeft <= 2 ? 0 : 10)
                Text(PuzzleSkin.moveLabel)
                    .font(.caption2.bold())
                    .foregroundStyle(AppColor.text.opacity(0.55))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppColor.surface.opacity(0.9))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppColor.secondary.opacity(0.35), lineWidth: 1))
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    private func glyphDock(_ session: GlyphSession) -> some View {
        VStack(spacing: 10) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(session.level.allowedGlyphs) { kind in
                        Button { selected = kind } label: {
                            VStack(spacing: 6) {
                                Image(systemName: PuzzleSkin.glyphSymbol(kind))
                                    .font(.title2.bold())
                                Text(PuzzleSkin.glyphTitle(kind))
                                    .font(.caption.bold())
                            }
                            .foregroundStyle(selected == kind ? AppColor.background : AppColor.text)
                            .frame(width: 76, height: 76)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(selected == kind ? AppColor.primary : AppColor.surface)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(selected == kind ? AppColor.accent : AppColor.text.opacity(0.15), lineWidth: selected == kind ? 2 : 1)
                            )
                            .neonGlow(selected == kind ? AppColor.primary : .clear, radius: 12)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }

            Text(PuzzleSkin.glyphHint(selected))
                .font(.caption)
                .foregroundStyle(AppColor.text.opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
        }
    }

    private func actionBar(_ session: GlyphSession) -> some View {
        HStack(spacing: 12) {
            Button { store.undo() } label: {
                Label("Undo", systemImage: "arrow.uturn.backward")
            }
            .buttonStyle(.neon(AppColor.surface))
            .disabled(!session.canUndo)
            .opacity(session.canUndo ? 1 : 0.45)

            Button { store.resetLevel() } label: {
                Label("Reset", systemImage: "arrow.counterclockwise")
            }
            .buttonStyle(.neon(AppColor.secondary))
        }
        .padding(.horizontal, 20)
    }

    private func winOverlay(_ session: GlyphSession) -> some View {
        resultOverlay(
            tint: AppColor.accent,
            title: PuzzleSkin.winTitle,
            stars: session.stars,
            detail: PuzzleSkin.winDetail + " · \(session.moves) moves",
            primary: "Next Stage",
            primaryAction: {
                if let next = store.nextLevel(after: session.level), store.isUnlocked(next) {
                    store.startLevel(next)
                    selected = next.allowedGlyphs.first ?? .boost
                } else {
                    store.session = nil
                }
            },
            secondary: "Exit",
            secondaryAction: { store.session = nil }
        )
    }

    private func failOverlay(_ session: GlyphSession) -> some View {
        resultOverlay(
            tint: Color.red,
            title: PuzzleSkin.loseTitle,
            stars: nil,
            detail: PuzzleSkin.loseDetail,
            primary: "Retry",
            primaryAction: { store.resetLevel() },
            secondary: "Exit",
            secondaryAction: { store.session = nil }
        )
    }

    private func resultOverlay(
        tint: Color,
        title: String,
        stars: Int?,
        detail: String,
        primary: String,
        primaryAction: @escaping () -> Void,
        secondary: String,
        secondaryAction: @escaping () -> Void
    ) -> some View {
        ZStack {
            Color.black.opacity(0.72).ignoresSafeArea()
            VStack(spacing: 18) {
                RetroTitleText(text: title, size: 30, color: tint)
                if let stars {
                    HStack(spacing: 6) {
                        ForEach(0..<3, id: \.self) { i in
                            Image(systemName: i < stars ? "star.fill" : "star")
                                .foregroundStyle(AppColor.accent)
                                .font(.title3)
                        }
                    }
                }
                Text(detail)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(AppColor.text.opacity(0.8))
                    .multilineTextAlignment(.center)
                Button(primary, action: primaryAction)
                    .buttonStyle(.neon(tint))
                Button(secondary, action: secondaryAction)
                    .font(.subheadline.bold())
                    .foregroundStyle(AppColor.text.opacity(0.65))
            }
            .padding(28)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(AppColor.surface)
                    .overlay(RoundedRectangle(cornerRadius: 24).stroke(tint.opacity(0.45), lineWidth: 1))
            )
            .padding(24)
        }
    }
}
