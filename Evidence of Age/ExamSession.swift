import SwiftUI
import Combine

final class ExamSession: ObservableObject {
    let piece: PieceEntry
    @Published var found: Set<String> = []
    @Published var openSpot: Spot?
    @Published var from: Int = 1700
    @Published var to: Int = 1800
    @Published var committed = false
    @Published var result: Dating?

    init(piece: PieceEntry) {
        self.piece = piece
    }

    var foundSpots: [Spot] { piece.spots.filter { found.contains($0.title) } }

    var suggested: (Int, Int) {
        guard !foundSpots.isEmpty else { return (1600, 1975) }
        let lo = foundSpots.map { $0.from }.max() ?? 1600
        let hi = foundSpots.map { $0.to }.min() ?? 1975
        return (min(lo, hi - 10), max(hi, lo + 10))
    }

    func commit() -> Dating {
        let truth = piece.year
        let inside = truth >= from && truth <= to
        let span = Double(max(5, to - from))
        let coverage = Double(found.count) / Double(max(1, piece.spots.count))
        let tightness = max(0, 1 - (span - 20) / 220)
        var score = coverage * 0.34
        if inside {
            score += 0.34 + tightness * 0.32
        } else {
            let miss = Double(min(abs(truth - from), abs(truth - to)))
            score += max(0, 0.22 - miss / 400)
        }
        let d = Dating(pieceID: piece.id, date: Date(), from: from, to: to,
                       found: found.count, score: max(0.05, min(1, score)), inside: inside)
        result = d
        committed = true
        return d
    }
}

struct RangeBar: View {
    @Binding var from: Int
    @Binding var to: Int
    let bands: [(Int, Int)]
    var truth: Int? = nil

    private let lo = 1600.0
    private let hi = 1975.0

    private func xOf(_ y: Int, _ w: CGFloat) -> CGFloat {
        CGFloat((Double(y) - lo) / (hi - lo)) * w
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2).fill(Age.inkPale.opacity(0.18))
                    .frame(height: 40)
                ForEach(Array(bands.enumerated()), id: \.offset) { _, b in
                    RoundedRectangle(cornerRadius: 2).fill(Age.moss.opacity(0.22))
                        .frame(width: max(4, xOf(b.1, w) - xOf(b.0, w)), height: 40)
                        .offset(x: xOf(b.0, w))
                }
                RoundedRectangle(cornerRadius: 2).fill(Age.oxblood.opacity(0.32))
                    .frame(width: max(6, xOf(to, w) - xOf(from, w)), height: 40)
                    .offset(x: xOf(from, w))
                if let t = truth {
                    Rectangle().fill(Age.ink).frame(width: 2, height: 52)
                        .offset(x: xOf(t, w) - 1, y: -6)
                }
                ForEach([0, 1], id: \.self) { i in
                    Circle().fill(Age.card)
                        .overlay(Circle().stroke(Age.oxblood, lineWidth: 2))
                        .frame(width: 26, height: 26)
                        .offset(x: xOf(i == 0 ? from : to, w) - 13)
                        .gesture(DragGesture(minimumDistance: 0).onChanged { g in
                            let year = Int(lo + Double(g.location.x / w) * (hi - lo))
                            let clamped = max(1600, min(1975, year))
                            if i == 0 { from = min(clamped, to - 5) } else { to = max(clamped, from + 5) }
                        })
                }
            }
            .frame(height: 52)
        }
        .frame(height: 52)
    }
}

struct ExamShell<Content: View>: View {
    let title: String
    let instruction: String
    var readout: [(String, String)] = []
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                SectionTitle(text: title)
                Text(instruction).font(Age.serif(15)).foregroundColor(Age.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 18).padding(.top, 8).padding(.bottom, 12)
            content().frame(maxWidth: .infinity, maxHeight: .infinity)
            if !readout.isEmpty {
                HStack(spacing: 0) {
                    ForEach(Array(readout.enumerated()), id: \.offset) { _, item in
                        VStack(spacing: 3) {
                            Text(item.0.uppercased()).font(Age.serifBold(9)).tracking(1.5)
                                .foregroundColor(Age.sepia)
                            Text(item.1).font(Age.serifBold(17)).foregroundColor(Age.ink)
                                .lineLimit(1).minimumScaleFactor(0.7)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical, 12).background(Age.card.opacity(0.94))
                .overlay(Rule(), alignment: .top)
            }
        }
    }
}
