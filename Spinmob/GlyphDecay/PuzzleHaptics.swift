import UIKit

enum PuzzleHaptics {
    static func tap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    static func win() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
