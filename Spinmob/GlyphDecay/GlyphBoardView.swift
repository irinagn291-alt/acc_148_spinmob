import SwiftUI

struct GlyphBoardView: View {
    let board: GlyphBoard
    let target: [Int]
    var interactive: Bool = true
    var onTap: (Int, Int) -> Void = { _, _ in }

    var body: some View {
        GeometryReader { geo in
            let spacing = cellSpacing
            let cell = min(
                (geo.size.width - spacing * CGFloat(board.cols - 1)) / CGFloat(board.cols),
                (geo.size.height - spacing * CGFloat(board.rows - 1)) / CGFloat(board.rows)
            )
            let boardW = cell * CGFloat(board.cols) + spacing * CGFloat(board.cols - 1)
            let boardH = cell * CGFloat(board.rows) + spacing * CGFloat(board.rows - 1)

            VStack(spacing: spacing) {
                ForEach(0..<board.rows, id: \.self) { r in
                    HStack(spacing: spacing) {
                        ForEach(0..<board.cols, id: \.self) { c in
                            cellView(r: r, c: c, side: cell)
                        }
                    }
                }
            }
            .frame(width: boardW, height: boardH)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var cellSpacing: CGFloat {
        switch PuzzleSkin.boardStyle {
        case .pixel: return 4
        case .ledger: return 3
        default: return 8
        }
    }

    @ViewBuilder
    private func cellView(r: Int, c: Int, side: CGFloat) -> some View {
        let value = board.charge(r, c)
        let want = target[board.idx(r, c)]
        let atTarget = value == want

        switch PuzzleSkin.boardStyle {
        case .orb, .tide:
            orbCell(value: value, want: want, atTarget: atTarget, side: side, r: r, c: c)
        case .neon:
            neonCell(value: value, want: want, atTarget: atTarget, side: side, r: r, c: c)
        case .pixel:
            pixelCell(value: value, want: want, atTarget: atTarget, side: side, r: r, c: c)
        case .soil:
            soilCell(value: value, want: want, atTarget: atTarget, side: side, r: r, c: c)
        case .ledger:
            ledgerCell(value: value, want: want, atTarget: atTarget, side: side, r: r, c: c)
        case .nest:
            nestCell(value: value, want: want, atTarget: atTarget, side: side, r: r, c: c)
        }
    }

    private func orbCell(value: Int, want: Int, atTarget: Bool, side: CGFloat, r: Int, c: Int) -> some View {
        ZStack {
            Circle()
                .fill(GlyphTheme.chargeColor(value, maxCharge: board.maxCharge))
                .overlay(Circle().stroke(atTarget ? GlyphTheme.success : GlyphTheme.stoneEdge, lineWidth: atTarget ? 3 : 1))
            chargeLabel(value: value, want: want, side: side, circular: true)
        }
        .frame(width: side, height: side)
        .contentShape(Circle())
        .onTapGesture { if interactive { onTap(r, c) } }
    }

    private func neonCell(value: Int, want: Int, atTarget: Bool, side: CGFloat, r: Int, c: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(value > 0 ? AppColor.primary.opacity(0.22 + 0.5 * Double(value) / Double(max(1, board.maxCharge))) : AppColor.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(atTarget ? AppColor.accent : AppColor.secondary.opacity(0.45), lineWidth: atTarget ? 2.5 : 1.5)
                )
                .shadow(color: AppColor.primary.opacity(value > 0 ? 0.45 : 0), radius: 10)

            VStack(spacing: 4) {
                Text("\(value)")
                    .font(.system(size: max(18, side * 0.34), weight: .black, design: .rounded))
                    .foregroundStyle(AppColor.text)
                HStack(spacing: 3) {
                    Text("GOAL")
                        .font(.system(size: max(7, side * 0.11), weight: .bold, design: .rounded))
                    Text("\(want)")
                        .font(.system(size: max(10, side * 0.15), weight: .heavy, design: .rounded))
                }
                .foregroundStyle(AppColor.accent)
            }
        }
        .frame(width: side, height: side)
        .onTapGesture { if interactive { onTap(r, c) } }
    }

    private func pixelCell(value: Int, want: Int, atTarget: Bool, side: CGFloat, r: Int, c: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(GlyphTheme.chargeColor(value, maxCharge: board.maxCharge))
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(AppColor.text.opacity(0.2), lineWidth: 2))
                .shadow(color: .black.opacity(0.45), radius: 0, x: 3, y: 3)
            if atTarget { RoundedRectangle(cornerRadius: 6).stroke(AppColor.accent, lineWidth: 2) }
            chargeLabel(value: value, want: want, side: side, circular: false)
        }
        .frame(width: side, height: side)
        .onTapGesture { if interactive { onTap(r, c) } }
    }

    private func soilCell(value: Int, want: Int, atTarget: Bool, side: CGFloat, r: Int, c: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(GlyphTheme.chargeColor(value, maxCharge: board.maxCharge))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(atTarget ? AppColor.accent : GlyphTheme.stoneEdge, lineWidth: 2))
            if value > 0 {
                Image(systemName: "leaf.fill")
                    .font(.system(size: side * 0.22))
                    .foregroundStyle(AppColor.primary.opacity(0.7))
                    .offset(y: -side * 0.08)
            }
            chargeLabel(value: value, want: want, side: side, circular: false)
        }
        .frame(width: side, height: side)
        .onTapGesture { if interactive { onTap(r, c) } }
    }

    private func ledgerCell(value: Int, want: Int, atTarget: Bool, side: CGFloat, r: Int, c: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(GlyphTheme.chargeColor(value, maxCharge: board.maxCharge))
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(atTarget ? AppColor.accent : GlyphTheme.stoneEdge, lineWidth: 1))
            VStack(spacing: 2) {
                Text("\(value)")
                    .font(.system(size: max(11, side * 0.28), weight: .bold, design: .monospaced))
                    .foregroundStyle(GlyphTheme.textPrimary)
                Text("→\(want)")
                    .font(.system(size: max(9, side * 0.16), weight: .semibold, design: .monospaced))
                    .foregroundStyle(AppColor.accent)
            }
        }
        .frame(width: side, height: side)
        .onTapGesture { if interactive { onTap(r, c) } }
    }

    private func nestCell(value: Int, want: Int, atTarget: Bool, side: CGFloat, r: Int, c: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(GlyphTheme.chargeColor(value, maxCharge: board.maxCharge))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(atTarget ? AppColor.accent : GlyphTheme.stoneEdge, lineWidth: 2))
            VStack(spacing: 3) {
                Image(systemName: "oval.fill")
                    .font(.system(size: side * 0.18))
                    .foregroundStyle(AppColor.secondary.opacity(0.7))
                Text("\(value)")
                    .font(.caption.bold())
                    .foregroundStyle(GlyphTheme.textPrimary)
            }
            Text("\(want)")
                .font(.caption2.bold())
                .foregroundStyle(AppColor.accent)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(4)
        }
        .frame(width: side, height: side)
        .onTapGesture { if interactive { onTap(r, c) } }
    }

    @ViewBuilder
    private func chargeLabel(value: Int, want: Int, side: CGFloat, circular: Bool) -> some View {
        if PuzzleSkin.boardStyle != .ledger {
            Text("\(want)")
                .font(.system(size: max(9, side * 0.18), weight: .bold, design: PuzzleSkin.usesRoundedType ? .rounded : .default))
                .foregroundStyle(AppColor.accent.opacity(0.95))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(max(3, side * 0.08))
            if value > 0 && PuzzleSkin.boardStyle != .nest {
                Text("\(value)")
                    .font(.system(size: max(14, side * 0.32), weight: .heavy, design: PuzzleSkin.usesRoundedType ? .rounded : .default))
                    .foregroundStyle(GlyphTheme.textPrimary.opacity(0.9))
            }
        }
    }
}
