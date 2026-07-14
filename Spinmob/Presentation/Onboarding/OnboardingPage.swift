import Foundation

/// One screen of the "countdown-hype" onboarding flow. Copy is sourced verbatim from the spec.
struct OnboardingPage: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let symbolName: String
    let ctaTitle: String
}

extension OnboardingPage {
    static let all: [OnboardingPage] = [
        OnboardingPage(
            id: 0,
            title: "Ready for the party?",
            subtitle: "The neon wheel is waiting for its first spin.",
            symbolName: "circle.hexagongrid.fill",
            ctaTitle: "Yes!"
        ),
        OnboardingPage(
            id: 1,
            title: "Add options or packs",
            subtitle: "Friend names, bold dares, or ready-made party packs — your call.",
            symbolName: "square.stack.3d.up.fill",
            ctaTitle: "Choose"
        ),
        OnboardingPage(
            id: 2,
            title: "Spin!",
            subtitle: "Drumroll, climax — and the wheel decides for you.",
            symbolName: "arrow.triangle.2.circlepath",
            ctaTitle: "Let's Go"
        )
    ]
}
