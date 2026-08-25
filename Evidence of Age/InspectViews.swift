import SwiftUI

struct DetailCanvas: View {
    let kind: EvidenceKind
    let reveal: Double
    let probe: CGPoint
    let seed: UInt64

    var body: some View {
        Canvas { ctx, size in draw(&ctx, size) }
    }

    private func draw(_ ctx: inout GraphicsContext, _ size: CGSize) {
        let w = size.width, h = size.height
        var rng = Seeded(seed)
        ctx.fill(Path(roundedRect: CGRect(origin: .zero, size: size),
                      cornerSize: CGSize(width: 4, height: 4)),
                 with: .color(Age.night.opacity(0.92)))

        let board = CGRect(x: w * 0.06, y: h * 0.14, width: w * 0.88, height: h * 0.72)
        ctx.fill(Path(roundedRect: board, cornerSize: CGSize(width: 3, height: 3)),
                 with: .color(woodTone))
        ctx.drawLayer { l in
            l.clip(to: Path(roundedRect: board, cornerSize: CGSize(width: 3, height: 3)))
            for _ in 0..<260 {
                let x = board.minX + CGFloat(rng.d()) * board.width
                let y = board.minY + CGFloat(rng.d()) * board.height
                var p = Path()
                p.move(to: CGPoint(x: x, y: y))
                p.addLine(to: CGPoint(x: x + CGFloat(rng.r(20, 130)), y: y + CGFloat(rng.r(-3, 3))))
                l.stroke(p, with: .color(woodTone.opacity(rng.r(0.10, 0.34))
                    .opacity(0.6)), lineWidth: CGFloat(rng.r(0.6, 2.0)))
            }
            drawDetail(&l, board, &rng)
            if reveal < 0.995 {
                l.fill(Path(board), with: .color(Age.night.opacity(0.80 * (1 - reveal))))
            }
        }
        ctx.stroke(Path(roundedRect: board, cornerSize: CGSize(width: 3, height: 3)),
                   with: .color(Age.inkPale.opacity(0.5)), lineWidth: 1)

        if kind.lens == "lamp" || kind.lens == "torch" {
            ctx.drawLayer { l in
                l.blendMode = .plusLighter
                l.fill(Path(ellipseIn: CGRect(x: probe.x - w * 0.30, y: probe.y - h * 0.34,
                                              width: w * 0.60, height: h * 0.68)),
                       with: .radialGradient(
                        Gradient(colors: [Age.lamp.opacity(0.30), .clear]),
                        center: probe, startRadius: 2, endRadius: w * 0.30))
            }
        } else if kind.lens == "loupe" {
            ctx.stroke(Path(ellipseIn: CGRect(x: probe.x - 52, y: probe.y - 52,
                                              width: 104, height: 104)),
                       with: .color(Age.ironDark), lineWidth: 8)
            ctx.stroke(Path(ellipseIn: CGRect(x: probe.x - 46, y: probe.y - 46,
                                              width: 92, height: 92)),
                       with: .color(Age.linen.opacity(0.35)), lineWidth: 2)
        } else if kind.lens == "caliper" {
            var jaw = Path()
            jaw.move(to: CGPoint(x: probe.x - 34, y: probe.y - 46))
            jaw.addLine(to: CGPoint(x: probe.x - 34, y: probe.y + 46))
            jaw.move(to: CGPoint(x: probe.x + 34, y: probe.y - 46))
            jaw.addLine(to: CGPoint(x: probe.x + 34, y: probe.y + 46))
            jaw.move(to: CGPoint(x: probe.x - 34, y: probe.y))
            jaw.addLine(to: CGPoint(x: probe.x + 34, y: probe.y))
            ctx.stroke(jaw, with: .color(Age.steel), lineWidth: 5)
        } else if kind.lens == "rule" {
            ctx.fill(Path(roundedRect: CGRect(x: w * 0.06, y: probe.y - 14,
                                              width: w * 0.88, height: 28),
                          cornerSize: CGSize(width: 2, height: 2)),
                     with: .color(Age.pine.opacity(0.92)))
            for k in 0..<26 {
                let x = w * 0.08 + CGFloat(k) * w * 0.033
                var t = Path()
                t.move(to: CGPoint(x: x, y: probe.y - 14))
                t.addLine(to: CGPoint(x: x, y: probe.y - 14 + (k % 5 == 0 ? 16 : 9)))
                ctx.stroke(t, with: .color(Age.ink.opacity(0.7)), lineWidth: 1.4)
            }
        }
    }

    private var woodTone: Color {
        switch kind {
        case .dovetails: return Age.oakPale
        case .saw, .backboards: return Age.pine
        case .screws: return Age.walnut
        case .shrinkage: return Age.mahogany
        case .handles: return Age.mahogany
        case .patina: return Age.walnut
        case .timber: return Age.walnut
        }
    }

    private func drawDetail(_ l: inout GraphicsContext, _ board: CGRect, _ rng: inout Seeded) {
        switch kind {
        case .dovetails:
            let n = 4
            for k in 0...n {
                let cx = board.minX + CGFloat(k) * board.width / CGFloat(n)
                let pinW = board.width / CGFloat(n) * 0.14
                var tail = Path()
                tail.move(to: CGPoint(x: cx - pinW, y: board.minY))
                tail.addLine(to: CGPoint(x: cx + pinW, y: board.minY))
                tail.addLine(to: CGPoint(x: cx + pinW * 3.4, y: board.midY))
                tail.addLine(to: CGPoint(x: cx - pinW * 3.4, y: board.midY))
                tail.closeSubpath()
                l.fill(tail, with: .color(Age.oak.opacity(0.9)))
                l.stroke(tail, with: .color(Age.ink.opacity(0.6)), lineWidth: 1.6)
            }
            var gauge = Path()
            gauge.move(to: CGPoint(x: board.minX, y: board.midY))
            gauge.addLine(to: CGPoint(x: board.maxX, y: board.midY))
            l.stroke(gauge, with: .color(Age.oxblood.opacity(0.7)), lineWidth: 1.4)
        case .saw, .backboards:
            var cx = board.minX - board.width * 0.2
            while cx < board.maxX + board.width {
                var r = board.width * 0.28
                while r < board.width * 1.1 {
                    var arc = Path()
                    for i in 0...20 {
                        let a = -0.9 + CGFloat(i) / 20 * 1.8
                        let p = CGPoint(x: cx + sin(a) * r, y: board.midY - cos(a) * r + r)
                        if i == 0 { arc.move(to: p) } else { arc.addLine(to: p) }
                    }
                    l.stroke(arc, with: .color(Age.sepia.opacity(0.30)), lineWidth: 1.6)
                    r += board.width * 0.045
                }
                cx += board.width * 0.9
            }
        case .screws:
            let c = CGPoint(x: board.midX, y: board.midY)
            l.fill(Path(ellipseIn: CGRect(x: c.x - 60, y: c.y - 60, width: 120, height: 120)),
                   with: .color(Age.steel))
            l.stroke(Path(ellipseIn: CGRect(x: c.x - 60, y: c.y - 60, width: 120, height: 120)),
                     with: .color(Age.ironDark), lineWidth: 3)
            var slot = Path()
            slot.move(to: CGPoint(x: c.x - 52, y: c.y + 6))
            slot.addLine(to: CGPoint(x: c.x + 50, y: c.y - 8))
            l.stroke(slot, with: .color(Age.ironDark), lineWidth: 11)
            var shank = Path()
            shank.move(to: CGPoint(x: c.x + 60, y: c.y - 26))
            shank.addLine(to: CGPoint(x: board.maxX - 30, y: c.y - 18))
            shank.addLine(to: CGPoint(x: board.maxX - 30, y: c.y + 18))
            shank.addLine(to: CGPoint(x: c.x + 60, y: c.y + 26))
            shank.closeSubpath()
            l.fill(shank, with: .color(Age.steel.opacity(0.9)))
            var tx = c.x + 76
            while tx < board.maxX - 40 {
                var th = Path()
                th.move(to: CGPoint(x: tx, y: c.y - 22))
                th.addLine(to: CGPoint(x: tx + 12, y: c.y + 22))
                l.stroke(th, with: .color(Age.ironDark.opacity(0.6)), lineWidth: 2.4)
                tx += CGFloat(rng.r(24, 38))
            }
        case .shrinkage:
            let r = min(board.width, board.height) * 0.40
            l.fill(Path(ellipseIn: CGRect(x: board.midX - r, y: board.midY - r * 0.92,
                                          width: r * 2, height: r * 1.84)),
                   with: .color(Age.mahogany.opacity(0.95)))
            l.stroke(Path(ellipseIn: CGRect(x: board.midX - r, y: board.midY - r,
                                            width: r * 2, height: r * 2)),
                     with: .color(Age.oxblood.opacity(0.7)),
                     style: StrokeStyle(lineWidth: 2, dash: [6, 6]))
        case .handles:
            for k in 0..<5 {
                let x = board.minX + board.width * (0.18 + CGFloat(k) * 0.16)
                let y = board.midY + (k % 2 == 0 ? -18 : 22)
                l.fill(Path(ellipseIn: CGRect(x: x - 9, y: y - 9, width: 18, height: 18)),
                       with: .color(Age.night.opacity(0.85)))
                l.stroke(Path(ellipseIn: CGRect(x: x - 9, y: y - 9, width: 18, height: 18)),
                         with: .color(Age.ink.opacity(0.6)), lineWidth: 1.4)
            }
        case .patina:
            l.fill(Path(board), with: .radialGradient(
                Gradient(colors: [Age.bareWood.opacity(0.62), .clear]),
                center: CGPoint(x: board.midX + board.width * 0.14, y: board.midY),
                startRadius: 4, endRadius: board.width * 0.34))
            for _ in 0..<420 {
                let x = board.minX + CGFloat(rng.d()) * board.width
                let y = board.minY + CGFloat(rng.d()) * board.height
                let d = abs(x - (board.midX + board.width * 0.14)) / (board.width * 0.5)
                l.fill(Path(ellipseIn: CGRect(x: x, y: y, width: 4, height: 4)),
                       with: .color(Age.patina.opacity(Double(d) * rng.r(0.06, 0.30))))
            }
        case .timber:
            l.fill(Path(CGRect(x: board.minX, y: board.minY, width: board.width, height: 26)),
                   with: .color(Age.walnut.opacity(0.95)))
            l.fill(Path(CGRect(x: board.minX, y: board.minY + 26,
                               width: board.width, height: board.height - 26)),
                   with: .color(Age.pine.opacity(0.9)))
            var line = Path()
            line.move(to: CGPoint(x: board.minX, y: board.minY + 26))
            line.addLine(to: CGPoint(x: board.maxX, y: board.minY + 26))
            l.stroke(line, with: .color(Age.ink.opacity(0.5)), lineWidth: 1.4)
        }
    }
}

struct InspectView: View {
    let spot: Spot
    let onFound: () -> Void
    let onClose: () -> Void

    @State private var reveal: Double = 0
    @State private var probe: CGPoint = CGPoint(x: 120, y: 120)
    @State private var taps: Int = 0
    @State private var done = false

    var body: some View {
        ZStack {
            PaperBack(name: "bg_card")
            VStack(spacing: 0) {
                SheetHeader(title: spot.kind.title, subtitle: spot.title, onClose: onClose)
                Rule()
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        Text(spot.kind.instruction).font(Age.serif(15))
                            .foregroundColor(Age.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                        GeometryReader { geo in
                            DetailCanvas(kind: spot.kind, reveal: reveal, probe: probe,
                                         seed: hashString(spot.title))
                                .contentShape(Rectangle())
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { g in
                                            probe = g.location
                                            reveal = min(1, reveal + 0.022)
                                        }
                                        .onEnded { _ in
                                            if spot.kind.lens == "count" { taps += 1 }
                                            if reveal >= 0.92 && !done { finish() }
                                        }
                                )
                                .onAppear { probe = CGPoint(x: geo.size.width * 0.3,
                                                            y: geo.size.height * 0.5) }
                        }
                        .frame(height: 250)
                        .overlay(Rectangle().stroke(Age.inkPale.opacity(0.4), lineWidth: 1))

                        MeterBar(value: reveal, tone: reveal > 0.92 ? Age.moss : Age.brass, height: 9)
                        Text(reveal > 0.92 ? "There it is." : "Keep working across it.")
                            .font(Age.serifItalic(13))
                            .foregroundColor(reveal > 0.92 ? Age.moss : Age.inkPale)

                        if done {
                            Rule()
                            VStack(alignment: .leading, spacing: 6) {
                                SectionTitle(text: "What it tells you")
                                Text(spot.finding).font(Age.serif(15)).foregroundColor(Age.inkSoft)
                                    .fixedSize(horizontal: false, vertical: true)
                                Text("Narrows it to \(spot.from) — \(spot.to)")
                                    .font(Age.serifBold(15)).foregroundColor(Age.oxblood)
                            }
                            PillButton(title: "Write it down", action: onClose)
                        }
                        Spacer(minLength: 20)
                    }
                    .padding(18)
                }
            }
        }
    }

    private func finish() {
        done = true
        reveal = 1
        onFound()
        hapticSolid()
    }
}
