import SwiftUI

struct GlyphRootView: View {
    @EnvironmentObject var store: GlyphStore
    @State private var section = 0

    var body: some View {
        ZStack {
            circuitBackground

            VStack(spacing: 0) {
                Picker("Section", selection: $section) {
                    Text("Play").tag(0)
                    Text("Guide").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                .padding(.top, 8)

                Group {
                    if section == 0 {
                        GlyphLevelsView()
                    } else {
                        GlyphHowToView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .fullScreenCover(isPresented: isPlaying) {
            GlyphPlayView()
                .environmentObject(store)
        }
    }

    private var isPlaying: Binding<Bool> {
        Binding(
            get: { store.session != nil },
            set: { if !$0 { store.session = nil } }
        )
    }

    private var circuitBackground: some View {
        LinearGradient(
            colors: [AppColor.background, AppColor.surface, AppColor.background],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
