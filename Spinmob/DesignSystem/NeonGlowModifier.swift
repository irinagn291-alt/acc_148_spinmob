import SwiftUI

/// Layered glow used to fake the spec's "neon + chrome highlights" shadow language
/// without any custom font or image assets.
private struct NeonGlowModifier: ViewModifier {
    let color: Color
    let radius: CGFloat

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.9), radius: radius * 0.3)
            .shadow(color: color.opacity(0.6), radius: radius * 0.7)
            .shadow(color: color.opacity(0.35), radius: radius)
    }
}

extension View {
    func neonGlow(_ color: Color, radius: CGFloat = 12) -> some View {
        modifier(NeonGlowModifier(color: color, radius: radius))
    }
}

/// Retro chrome display heading: bold rounded type plus a neon glow, since the
/// spec calls for "retro chrome display" typography without a bundled custom font.
struct RetroTitleText: View {
    let text: String
    var size: CGFloat = 34
    var color: Color = AppColor.text

    var body: some View {
        Text(text)
            .font(.system(size: size, weight: .black, design: .rounded))
            .foregroundStyle(color)
            .neonGlow(AppColor.secondary)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    ZStack {
        AppColor.background.ignoresSafeArea()
        RetroTitleText(text: "Spinmob")
    }
}
