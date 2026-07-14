import UIKit

/// Stateless haptics helper. The only intentional exception to "no singletons" —
/// `UIFeedbackGenerator` calls are inherently fire-and-forget side effects.
enum HapticsService {
    /// Soft tick used while the wheel is still spinning fast, mimicking a peg-click.
    @MainActor
    static func spinTick() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 0.5)
    }

    /// The strong "moment of outcome" haptic fired the instant the wheel settles.
    @MainActor
    static func landingClimax() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        let heavy = UIImpactFeedbackGenerator(style: .heavy)
        heavy.impactOccurred()
    }

    @MainActor
    static func selectionChanged() {
        UISelectionFeedbackGenerator().selectionChanged()
    }

    @MainActor
    static func lightTap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}
