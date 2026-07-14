import SwiftUI

struct OnboardingView: View {
    @State private var viewModel = OnboardingViewModel()
    let onFinish: () -> Void

    var body: some View {
        ZStack {
            backgroundGradient

            VStack(spacing: 36) {
                pageIndicator

                Spacer()

                Image(systemName: viewModel.currentPage.symbolName)
                    .font(.system(size: 96))
                    .foregroundStyle(AppColor.accent)
                    .neonGlow(AppColor.accent, radius: 16)
                    .symbolEffect(.bounce, value: viewModel.currentPage.id)

                VStack(spacing: 12) {
                    RetroTitleText(text: viewModel.currentPage.title)
                    Text(viewModel.currentPage.subtitle)
                        .font(.body)
                        .foregroundStyle(AppColor.text.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                Spacer()

                Button(viewModel.currentPage.ctaTitle) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        viewModel.advance(onFinished: onFinish)
                    }
                }
                .buttonStyle(.neon)
                .padding(.horizontal, 32)
                .padding(.bottom, 24)
            }
        }
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(viewModel.pages) { page in
                Capsule()
                    .fill(page.id == viewModel.currentPage.id ? AppColor.accent : AppColor.text.opacity(0.25))
                    .frame(width: page.id == viewModel.currentPage.id ? 28 : 8, height: 8)
            }
        }
        .padding(.top, 24)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: viewModel.currentPage.id)
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
    OnboardingView(onFinish: {})
}
