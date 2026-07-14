import SwiftUI

enum PuzzleSkin {
    static let title = "Neon Circuit"
    static let tabTitle = "Circuit"
    static let tagline = "Light the grid before the blackout hits."
    static let goalLine = "Charge every tile to its target voltage before turns run out."
    static let moveLabel = "turns left"
    static let winTitle = "JACKPOT"
    static let loseTitle = "BLACKOUT"
    static let winDetail = "The circuit is fully lit."
    static let loseDetail = "Power died before stabilization."
    static let boardStyle: PuzzleBoardStyle = .neon
    static let menuStyle: PuzzleMenuStyle = .carousel
    static let usesRoundedType = true
    static let isDarkGame = true

    static let levelNames: [String] = [
        "Boot Sector",
        "Twin Nodes",
        "Quiet Loop",
        "Cross Wire",
        "Hollow Port",
        "Drift Bus",
        "Ember Mesh",
        "Cinder Link",
        "Violet Gate",
        "Stone Array",
        "Petal Port",
        "Corner Arc",
        "Thorn Loop",
        "Lattice Bus",
        "Glass Meridian",
        "Silent Hex",
        "Fading Choir",
        "Neon Cathedral",
        "Withered Crown",
        "Ashfall Grid",
        "Obsidian Weave",
        "Breaker",
        "Last Constellation",
        "Final Blackout",
    ]

    static func levelName(for level: GlyphLevel) -> String {
        let idx = level.id - 1
        guard idx >= 0, idx < levelNames.count else { return level.name }
        return levelNames[idx]
    }

    static func glyphTitle(_ kind: GlyphKind) -> String {
        switch kind {
        case .boost: return "Amp"
        case .pulse: return "Surge"
        case .siphon: return "Drain"
        case .bloom: return "Arc"
        case .quell: return "Kill"
        }
    }

    static func glyphSymbol(_ kind: GlyphKind) -> String {
        switch kind {
        case .boost: return "plus.circle.fill"
        case .pulse: return "bolt.circle.fill"
        case .siphon: return "minus.circle.fill"
        case .bloom: return "arrow.up.left.and.arrow.down.right"
        case .quell: return "xmark.circle.fill"
        }
    }

    static func glyphHint(_ kind: GlyphKind) -> String {
        switch kind {
        case .boost: return "+1 charge to tile and cross neighbors."
        case .pulse: return "+2 charge to one tile."
        case .siphon: return "-1 from tile and cross neighbors."
        case .bloom: return "+1 to diagonal tiles."
        case .quell: return "-2 from one tile."
        }
    }
}

enum PuzzleBoardStyle { case orb, neon, pixel, soil, tide, ledger, nest }
enum PuzzleMenuStyle { case softCards, carousel, chapters, path, strip, rows, barn }
