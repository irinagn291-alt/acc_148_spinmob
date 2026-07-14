import SwiftUI

struct GlyphDecayTabView: View {
    @StateObject private var store = GlyphStore()

    var body: some View {
        GlyphRootView()
            .environmentObject(store)
    }
}
