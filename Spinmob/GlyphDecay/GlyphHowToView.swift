import SwiftUI

struct GlyphHowToView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("How to Play")
                    .font(GlyphTheme.titleFont)
                    .foregroundStyle(GlyphTheme.textPrimary)

                rule("Goal", PuzzleSkin.goalLine)
                rule("Tools", "Pick a tool, then tap a cell. Each tool shifts charge in a unique pattern. New tools unlock as you progress.")
                rule("Decay", "After every move, all cells lose 1 charge. Reach every target before \(PuzzleSkin.moveLabel) hit zero.")
                rule("Stars", "Finish at or under par for 3 stars. A few extra moves still earns 2; any solve earns 1.")
                rule("Undo", "Undo your last move or reset the stage to try a different approach.")
            }
            .padding(20)
        }
    }

    private func rule(_ title: String, _ body: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline.bold())
                .foregroundStyle(GlyphTheme.ember)
            Text(body)
                .font(GlyphTheme.bodyFont)
                .foregroundStyle(GlyphTheme.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(RoundedRectangle(cornerRadius: GlyphTheme.cellCorner).fill(GlyphTheme.bgPanel))
    }
}
