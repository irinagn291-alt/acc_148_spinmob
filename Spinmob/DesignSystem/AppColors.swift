import SwiftUI

extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&rgb)
        let r = Double((rgb & 0xFF0000) >> 16) / 255
        let g = Double((rgb & 0x00FF00) >> 8) / 255
        let b = Double(rgb & 0x0000FF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

/// Design tokens for Spinmob, sourced from the concept's Visual Direction spec.
enum AppColor {
    static let primary = Color(hex: "#FF4D8D")
    static let secondary = Color(hex: "#21D4FD")
    static let accent = Color(hex: "#FFE53B")
    static let background = Color(hex: "#1A0033")
    static let surface = Color(hex: "#2B0A4A")
    static let text = Color(hex: "#FFFFFF")
}
