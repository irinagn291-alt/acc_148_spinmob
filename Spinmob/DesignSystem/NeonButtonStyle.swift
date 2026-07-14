import SwiftUI

/// Glossy 80s CTA button — chrome gradient fill, neon edge, pressed scale-down.
struct NeonButtonStyle: ButtonStyle {
    var fill: Color = AppColor.primary

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.headline, design: .rounded, weight: .bold))
            .foregroundStyle(AppColor.text)
            .padding(.vertical, 16)
            .padding(.horizontal, 28)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [fill, fill.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: AppMetrics.cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppMetrics.cornerRadius, style: .continuous)
                    .stroke(AppColor.text.opacity(0.25), lineWidth: 1)
            )
            .neonGlow(fill, radius: 10)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == NeonButtonStyle {
    static var neon: NeonButtonStyle { NeonButtonStyle() }
    static func neon(_ fill: Color) -> NeonButtonStyle { NeonButtonStyle(fill: fill) }
}

#Preview {
    ZStack {
        AppColor.background.ignoresSafeArea()
        VStack(spacing: 16) {
            Button("Spin!") {}
                .buttonStyle(.neon)
            Button("Let's Go") {}
                .buttonStyle(.neon(AppColor.secondary))
        }
        .padding()
    }
}
