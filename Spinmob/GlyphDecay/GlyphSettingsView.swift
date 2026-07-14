import SwiftUI

struct GlyphSettingsView: View {
    @EnvironmentObject var store: GlyphStore
    @State private var showReset = false

    var body: some View {
        VStack(spacing: 16) {
            Text(PuzzleSkin.title)
                .font(GlyphTheme.titleFont)
            Text("\(store.completedCount)/\(store.totalCount) stages complete")
                .foregroundStyle(GlyphTheme.textMuted)
            Button("Reset Progress", role: .destructive) { showReset = true }
        }
        .padding()
        .alert("Reset all progress?", isPresented: $showReset) {
            Button("Reset", role: .destructive) { store.resetProgress() }
            Button("Cancel", role: .cancel) {}
        }
    }
}
