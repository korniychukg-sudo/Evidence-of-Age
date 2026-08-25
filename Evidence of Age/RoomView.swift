import SwiftUI

struct SaleroomScene: View {
    let hour: Double
    let t: Double
    let lots: Int

    private var dayness: Double {
        if hour < 6 || hour > 20 { return 0 }
        let x = (hour - 6) / 14
        return max(0, min(1, sin(.pi * max(0, min(1, x)))))
    }

    var body: some View {
        ZStack {
            PlateView(name: "bg_room", maxDim: 1000, mode: .fill)
            Canvas { ctx, size in draw(&ctx, size) }
        }
    }

    private func draw(_ ctx: inout GraphicsContext, _ size: CGSize) {
        let w = size.width, h = size.height
        let floor = h * 0.70

        let win = CGRect(x: w * 0.60, y: h * 0.10, width: w * 0.30, height: h * 0.44)
        let sky = Color(red: 0.42 + dayness * 0.34, green: 0.46 + dayness * 0.34,
                        blue: 0.50 + dayness * 0.32)
        ctx.fill(Path(win), with: .color(sky))
        var bars = Path()
        bars.addRect(CGRect(x: win.midX - 2.5, y: win.minY, width: 5, height: win.height))
        bars.addRect(CGRect(x: win.minX, y: win.midY - 2.5, width: win.width, height: 5))
        ctx.fill(bars, with: .color(Age.inkSoft))
        ctx.stroke(Path(win), with: .color(Age.inkSoft), lineWidth: 6)

        var shaft = Path()
        shaft.move(to: CGPoint(x: win.minX, y: win.maxY))
        shaft.addLine(to: CGPoint(x: win.maxX, y: win.maxY))
        shaft.addLine(to: CGPoint(x: w * 0.26, y: h))
        shaft.addLine(to: CGPoint(x: -w * 0.10, y: h))
        shaft.closeSubpath()
        ctx.fill(shaft, with: .linearGradient(
            Gradient(colors: [Age.lamp.opacity(0.06 + dayness * 0.24), .clear]),
            startPoint: CGPoint(x: win.midX, y: win.maxY),
            endPoint: CGPoint(x: w * 0.10, y: h)))

        ctx.fill(Path(CGRect(x: 0, y: floor, width: w, height: h - floor)),
                 with: .color(Age.walnut.opacity(0.55)))
        for k in 0..<9 {
            var b = Path()
            b.move(to: CGPoint(x: CGFloat(k) * w / 8, y: floor))
            b.addLine(to: CGPoint(x: CGFloat(k) * w / 8 - w * 0.06, y: h))
            ctx.stroke(b, with: .color(Age.night.opacity(0.18)), lineWidth: 1.5)
        }

        let n = min(4, max(1, lots))
        for i in 0..<n {
            let bx = w * (0.06 + Double(i) * 0.21)
            let bw = w * 0.16
            let bh = h * (0.20 + Double((i * 5) % 3) * 0.07)
            ctx.fill(Path(CGRect(x: bx, y: floor - bh, width: bw, height: bh)),
                     with: .color(Age.oak.opacity(0.9)))
            ctx.stroke(Path(CGRect(x: bx, y: floor - bh, width: bw, height: bh)),
                       with: .color(Age.ink.opacity(0.5)), lineWidth: 1.4)
            for d in 0..<3 {
                let dy = floor - bh + h * 0.02 + CGFloat(d) * bh * 0.30
                ctx.stroke(Path(CGRect(x: bx + 6, y: dy, width: bw - 12, height: bh * 0.24)),
                           with: .color(Age.ink.opacity(0.34)), lineWidth: 1)
                ctx.fill(Path(ellipseIn: CGRect(x: bx + bw / 2 - 4, y: dy + bh * 0.10,
                                                width: 8, height: 8)),
                         with: .color(Age.brass))
            }
            ctx.fill(Path(ellipseIn: CGRect(x: bx + bw * 0.35, y: floor - 6,
                                            width: bw * 0.30, height: 12)),
                     with: .color(Age.night.opacity(0.20)))
            ctx.fill(Path(roundedRect: CGRect(x: bx + bw * 0.30, y: floor - bh - 18,
                                              width: bw * 0.40, height: 14),
                          cornerSize: CGSize(width: 2, height: 2)),
                     with: .color(Age.linen))
        }

        for i in 0..<40 {
            let seed = Double(i) * 1.618
            let px = w * CGFloat(0.02 + 0.60 * ((seed + t * 0.017).truncatingRemainder(dividingBy: 1)))
            let py = h * CGFloat(0.14 + 0.74 * ((seed * 2.7 + t * 0.011).truncatingRemainder(dividingBy: 1)))
            let s = CGFloat(1.0 + 1.6 * abs(sin(seed)))
            ctx.fill(Path(ellipseIn: CGRect(x: px, y: py, width: s, height: s)),
                     with: .color(Color.white.opacity(0.10 + dayness * 0.26)))
        }

        if dayness < 0.24 {
            let k = 1 - dayness / 0.24
            ctx.fill(Path(CGRect(origin: .zero, size: size)),
                     with: .color(Color(red: 0.08, green: 0.07, blue: 0.10).opacity(0.36 * k)))
            let lampC = CGPoint(x: w * 0.34, y: h * 0.08)
            ctx.fill(Path(ellipseIn: CGRect(x: lampC.x - 80, y: lampC.y - 80,
                                            width: 160, height: 160)),
                     with: .radialGradient(
                        Gradient(colors: [Age.lamp.opacity(0.36 * k), .clear]),
                        center: lampC, startRadius: 2, endRadius: 82))
            ctx.fill(Path(ellipseIn: CGRect(x: lampC.x - 7, y: lampC.y - 7, width: 14, height: 14)),
                     with: .color(Age.lamp.opacity(0.9)))
        }
    }
}

struct AgeStatChip: View {
    let value: String
    let label: String
    var body: some View {
        VStack(spacing: 2) {
            Text(value).font(Age.serifBold(17)).foregroundColor(Age.ink)
            Text(label.uppercased()).font(Age.serif(9)).tracking(1.5).foregroundColor(Age.inkPale)
        }
    }
}

struct RoomRootView: View {
    @EnvironmentObject var store: LedgerStore
    let goToBench: () -> Void
    let goToTimeline: () -> Void
    @State private var t: Double = 0
    @State private var now = Date()
    private let tick = Timer.publish(every: 0.6, on: .main, in: .common).autoconnect()

    private var hour: Double {
        let c = Calendar.current.dateComponents([.hour, .minute], from: now)
        return Double(c.hour ?? 12) + Double(c.minute ?? 0) / 60
    }

    var body: some View {
        ZStack {
            PaperBack()
            ScrollView {
                VStack(spacing: 14) {
                    SaleroomScene(hour: hour, t: t, lots: max(1, store.state.datings.count))
                        .frame(height: 222)
                        .overlay(alignment: .bottomLeading) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(greeting.uppercased()).font(Age.serifBold(10)).tracking(2.2)
                                    .foregroundColor(Age.linen.opacity(0.9))
                                Text("Evidence of Age").font(Age.serifBold(22))
                                    .foregroundColor(Age.linen)
                            }
                            .padding(14).shadow(color: .black.opacity(0.6), radius: 5)
                        }
                        .overlay(Rectangle().stroke(Age.inkPale.opacity(0.4), lineWidth: 1))

                    feesCard
                    if !store.state.taken.isEmpty {
                        SectionTitle(text: "Instructed on")
                        ForEach(store.state.taken) { c in
                            NavigationLink(destination: ConsignmentPage(consignment: c, taken: true)) {
                                ConsignmentCard(consignment: c, now: now, taken: true)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    if !store.state.board.isEmpty {
                        SectionTitle(text: "Waiting in the office")
                        ForEach(store.state.board) { c in
                            NavigationLink(destination: ConsignmentPage(consignment: c, taken: false)) {
                                ConsignmentCard(consignment: c, now: now, taken: false)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    NavigationLink(destination: DeskShopView()) { benchRow }
                        .buttonStyle(.plain)
                    rankCard
                    lotCard
                    jobCard
                    timelineCard
                }
                .padding(14)
            }
            if let b = store.lastBadge {
                VStack { Spacer(); BadgeToast(badge: b).padding(.bottom, 16) }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
                            withAnimation { store.lastBadge = nil }
                        }
                    }
            }
        }
        .onReceive(tick) { _ in t += 0.6; now = Date() }
        .onAppear { store.rollDay(); store.refreshBoard(now) }
    }

    private var greeting: String {
        if hour < 7 { return "Before the porters arrive" }
        if hour < 11 { return "Viewing day" }
        if hour < 15 { return "The saleroom is quiet" }
        if hour < 19 { return "Cataloguing" }
        return "The lamp is on"
    }

    private var feesCard: some View {
        CardBox {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("FEES BANKED").font(Age.serif(10)).tracking(2.0)
                            .foregroundColor(Age.inkPale)
                        Text("\(store.state.money)").font(Age.serifBold(26)).foregroundColor(Age.ink)
                    }
                    Spacer()
                    HStack(spacing: 16) {
                        AgeStatChip(value: "\(store.state.filled)", label: "filed")
                        AgeStatChip(value: "\(store.state.missed)", label: "lost")
                        AgeStatChip(value: "\(store.state.tools.count)/\(deskTools.count)", label: "bench")
                    }
                }
                if !store.state.lastResult.isEmpty {
                    Rule()
                    Text(store.state.lastResult).font(Age.serifItalic(13))
                        .foregroundColor(Age.inkSoft)
                }
            }
        }
    }

    private var benchRow: some View {
        CardBox {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("The bench").font(Age.serifBold(16)).foregroundColor(Age.ink)
                    Text(store.state.tools.count == deskTools.count
                         ? "Nothing left in the catalogue you do not own."
                         : "\(deskTools.count - store.state.tools.count) still to buy. Instruments change what the piece will tell you.")
                        .font(Age.serif(13)).foregroundColor(Age.inkPale)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
        }
    }

    private var rankCard: some View {
        CardBox {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        SectionTitle(text: "Your standing")
                        Text(DealerRank.name(store.state.xp)).font(Age.serifBold(21))
                            .foregroundColor(Age.ink)
                    }
                    Spacer()
                    VStack(spacing: 2) {
                        Text("\(store.state.streak)").font(Age.serifBold(26))
                            .foregroundColor(Age.oxblood)
                        Text("DAY RUN").font(Age.serifBold(9)).tracking(1.4)
                            .foregroundColor(Age.sepia)
                    }
                }
                MeterBar(value: DealerRank.progress(store.state.xp), tone: Age.brass, height: 6)
                HStack {
                    Text("\(store.state.xp) experience").font(Age.serif(12))
                        .foregroundColor(Age.inkPale)
                    Spacer()
                    if let next = DealerRank.nextAt(store.state.xp) {
                        Text("\(next - store.state.xp) to the next").font(Age.serif(12))
                            .foregroundColor(Age.inkPale)
                    } else {
                        Text("they ask you now").font(Age.serifItalic(12)).foregroundColor(Age.sepia)
                    }
                }
            }
        }
    }

    private var lotCard: some View {
        let lot = store.todayLot
        return CardBox {
            VStack(alignment: .leading, spacing: 10) {
                SectionTitle(text: "In this morning")
                PlateThumb(name: lot.plate, focusY: 0.30, bandHeight: 0.44, maxDim: 620)
                    .frame(height: 130)
                    .overlay(Rectangle().stroke(Age.inkPale.opacity(0.4), lineWidth: 1))
                Text(lot.name).font(Age.serifBold(18)).foregroundColor(Age.ink)
                Text("No provenance, no label, and the vendor thinks it is older than it is. Everything you can say about it has to come off the piece.")
                    .font(Age.serif(14)).foregroundColor(Age.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                PillButton(title: "Take it to the bench", action: goToBench)
            }
        }
    }

    private var jobCard: some View {
        let job = store.todayJob
        let (a, b) = store.jobProgress()
        return CardBox {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    SectionTitle(text: "The day's job")
                    Spacer()
                    Text("\(a) / \(b)").font(Age.serifBold(13)).foregroundColor(Age.sepia)
                }
                Text(job.title).font(Age.serifBold(18)).foregroundColor(Age.ink)
                    .fixedSize(horizontal: false, vertical: true)
                Text(job.detail).font(Age.serif(14)).foregroundColor(Age.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                MeterBar(value: Double(a) / Double(max(1, b)),
                         tone: store.jobComplete ? Age.moss : Age.oxblood, height: 6)
                if store.jobComplete && !store.state.jobClaimed {
                    PillButton(title: "Take the \(job.reward) for it", tone: Age.moss) {
                        store.claimJob(); hapticSolid()
                    }
                } else if store.state.jobClaimed {
                    HStack(spacing: 8) {
                        CheckGlyph().stroke(Age.moss, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                            .frame(width: 14, height: 14)
                        Text("Signed off").font(Age.serifItalic(13)).foregroundColor(Age.moss)
                    }
                }
            }
        }
    }

    private var timelineCard: some View {
        CardBox {
            VStack(alignment: .leading, spacing: 10) {
                SectionTitle(text: "The long view")
                Text("Three hundred and seventy five years of timber, saws, screws, handles and finishes, laid end to end. Everything you need to date a piece is on one line.")
                    .font(Age.serif(14)).foregroundColor(Age.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                PillButton(title: "Walk the timeline", tone: Age.sepia, filled: false,
                           action: goToTimeline)
            }
        }
    }
}
