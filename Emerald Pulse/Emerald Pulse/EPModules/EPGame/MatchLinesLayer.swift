//
//  MatchLinesLayer.swift
//  Emerald Pulse
//
//


import SwiftUI

// Рисуем линии между центром "числа" и центром "слова"
struct MatchLinesLayer: View {
    let matches: [MatchPair]
    let numberAnchors: [UUID: Anchor<CGRect>]
    let wordAnchors: [UUID: Anchor<CGRect>]

    var body: some View {
        GeometryReader { proxy in
            Canvas { context, _ in
                for m in matches {
                    guard let na = numberAnchors[m.numberID],
                          let wa = wordAnchors[m.wordID] else { continue }

                    let nr = proxy[na]
                    let wr = proxy[wa]

                    let start = CGPoint(x: nr.midX, y: nr.maxY) // снизу флажка
                    let end   = CGPoint(x: wr.midX, y: wr.minY) // сверху корзины

                    var path = Path()
                    path.move(to: start)

                    // Немного кривизны, чтобы было “живее”
                    let ctrl1 = CGPoint(x: start.x, y: start.y + 40)
                    let ctrl2 = CGPoint(x: end.x, y: end.y - 40)
                    path.addCurve(to: end, control1: ctrl1, control2: ctrl2)

                    context.stroke(path,
                                   with: .color(.lineYellow),
                                   lineWidth: 6)
                }
            }
            .allowsHitTesting(false)
        }
    }
}

// PreferenceKeys, чтобы собрать anchors элементов
struct NumberAnchorKey: PreferenceKey {
    static var defaultValue: [UUID: Anchor<CGRect>] = [:]
    static func reduce(value: inout [UUID: Anchor<CGRect>], nextValue: () -> [UUID: Anchor<CGRect>]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct WordAnchorKey: PreferenceKey {
    static var defaultValue: [UUID: Anchor<CGRect>] = [:]
    static func reduce(value: inout [UUID: Anchor<CGRect>], nextValue: () -> [UUID: Anchor<CGRect>]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
