import SwiftUI

enum GlyphTheme {
    static var bgDeep: Color { PuzzleSkin.isDarkGame ? AppColor.background : AppColor.background }
    static var bgPanel: Color { AppColor.surface }
    static var stone: Color { AppColor.secondary.opacity(PuzzleSkin.isDarkGame ? 0.35 : 0.18) }
    static var stoneEdge: Color { AppColor.secondary.opacity(0.45) }
    static var stoneInset: Color { AppColor.background.opacity(PuzzleSkin.isDarkGame ? 0.9 : 0.55) }
    static var ember: Color { AppColor.primary }
    static var emberDim: Color { AppColor.primary.opacity(0.45) }
    static var violet: Color { AppColor.accent }
    static var violetDim: Color { AppColor.accent.opacity(0.45) }
    static var teal: Color { AppColor.secondary }
    static var textPrimary: Color { AppColor.text }
    static var textMuted: Color { AppColor.text.opacity(0.68) }
    static var textFaint: Color { AppColor.text.opacity(0.42) }
    static var success: Color { AppColor.accent }
    static var danger: Color { Color.red.opacity(0.85) }
    static var lockGray: Color { AppColor.secondary.opacity(0.55) }

    static func chargeColor(_ value: Int, maxCharge: Int) -> Color {
        if value <= 0 { return stoneInset }
        let t = Double(value) / Double(max(1, maxCharge))
        return AppColor.primary.opacity(0.25 + 0.75 * t)
    }

    static var titleFont: Font {
        PuzzleSkin.usesRoundedType
            ? .system(.title2, design: .rounded).weight(.heavy)
            : .title2.weight(.bold)
    }

    static var bodyFont: Font {
        PuzzleSkin.usesRoundedType
            ? .system(.subheadline, design: .rounded).weight(.medium)
            : .subheadline.weight(.medium)
    }

    static var cellCorner: CGFloat {
        switch PuzzleSkin.boardStyle {
        case .orb, .tide: return 999
        case .pixel: return 6
        case .ledger: return 4
        default: return 14
        }
    }
}
