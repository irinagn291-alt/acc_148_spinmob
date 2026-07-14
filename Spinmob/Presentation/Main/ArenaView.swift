import SwiftUI

/// The full-screen "physics arena" — the app's main screen.
struct ArenaView: View {
    @State var viewModel: ArenaViewModel

    var body: some View {
        ZStack {
            backgroundGradient

            VStack(spacing: 20) {
                header

                Spacer(minLength: 0)

                if let set = viewModel.selectedSpinSet, !set.isEmpty {
                    wheelArena(set: set)
                } else {
                    EmptyWheelView(onAddOptions: { viewModel.isShowingSetManager = true })
                }

                Spacer(minLength: 0)

                if let set = viewModel.selectedSpinSet, !set.isEmpty {
                    Button("Spin!") {
                        Task { await viewModel.spin() }
                    }
                    .buttonStyle(.neon)
                    .disabled(viewModel.isSpinning)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 28)
                }
            }
        }
        .task { await viewModel.loadInitialData() }
        .sheet(isPresented: $viewModel.isShowingSetManager) {
            SpinSetManagerView(arenaViewModel: viewModel)
        }
        .alert(
            "Oops!",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.selectedSpinSet?.name ?? "Spinmob")
                    .font(.system(.title2, design: .rounded, weight: .black))
                    .foregroundStyle(AppColor.text)
                if let player = viewModel.currentPlayerName {
                    Text("Up next: \(player)")
                        .font(.subheadline.bold())
                        .foregroundStyle(AppColor.accent)
                }
            }
            Spacer()
            Button {
                viewModel.isShowingSetManager = true
            } label: {
                Image(systemName: "square.stack.3d.up.fill")
                    .font(.title2)
                    .foregroundStyle(AppColor.secondary)
                    .padding(10)
                    .background(AppColor.surface, in: Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    private func wheelArena(set: SpinSet) -> some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height) - 24
            ZStack {
                WheelView(segments: set.segments)
                    .frame(width: size, height: size)
                    .rotationEffect(.degrees(viewModel.rotationDegrees))
                    .animation(.easeOut(duration: ArenaViewModel.spinDuration), value: viewModel.rotationDegrees)
                    .neonGlow(AppColor.secondary, radius: 18)

                WheelPointer()
                    .offset(y: -size / 2 - 6)

                if let result = viewModel.lastResult, !viewModel.isSpinning {
                    SpinResultBanner(result: result, playerName: nil)
                        .offset(y: size / 2 + 56)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .contentShape(Rectangle())
            .onTapGesture {
                Task { await viewModel.spin() }
            }
        }
        .padding(.horizontal, 24)
        .frame(maxHeight: 420)
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [AppColor.background, AppColor.surface],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

#Preview {
    ArenaView(viewModel: ArenaViewModel(dependencies: .previewInstance))
}
