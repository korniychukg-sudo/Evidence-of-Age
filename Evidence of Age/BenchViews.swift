import SwiftUI

struct BenchRootView: View {
    @EnvironmentObject var store: LedgerStore
    @State private var chosen: PieceEntry?
    @State private var session: ExamSession?

    var body: some View {
        ZStack {
            PaperBack(name: "bg_bench")
            if let s = session {
                ExamView(session: s, onQuit: { session = nil }).environmentObject(store)
            } else {
                VStack(spacing: 0) {
                    AgeNavBar(title: "The Viewing",
                              subtitle: "Thirty two lots, and none of them labelled")
                    Rule()
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(Pieces.all) { p in
                                Button(action: { if store.unlocked(p) { chosen = p } }) {
                                    pieceRow(p)
                                }
                                .buttonStyle(GlyphButtonStyle())
                                .disabled(!store.unlocked(p))
                            }
                        }
                        .padding(.horizontal, 14).padding(.vertical, 14)
                    }
                }
            }
        }
        .sheet(item: $chosen) { p in
            PieceBriefing(piece: p, unlocked: store.unlocked(p), best: store.bestFor(p.id)) {
                chosen = nil
                session = ExamSession(piece: p)
            } onClose: { chosen = nil }
        }
    }

    private func pieceRow(_ p: PieceEntry) -> some View {
        HStack(spacing: 12) {
            ZStack {
                PlateThumb(name: p.plate, focusY: 0.30, bandHeight: 0.40, maxDim: 420)
                    .frame(width: 92, height: 78)
                    .opacity(store.unlocked(p) ? 1 : 0.34)
                if !store.unlocked(p) {
                    LockGlyph().stroke(Age.ink.opacity(0.7), lineWidth: 1.6)
                        .frame(width: 22, height: 22)
                }
            }
            .overlay(Rectangle().stroke(Age.inkPale.opacity(0.4), lineWidth: 1))
            VStack(alignment: .leading, spacing: 3) {
                Text(p.name).font(Age.serifBold(16)).foregroundColor(Age.ink)
                    .lineLimit(1).minimumScaleFactor(0.75)
                Text(p.region + "  ·  " + p.timber).font(Age.serif(12))
                    .foregroundColor(Age.inkPale).lineLimit(1)
                HStack(spacing: 6) {
                    if store.bestFor(p.id) > 0 {
                        SmallTag(text: "Catalogued", tone: Age.moss)
                    }
                    if !store.unlocked(p) {
                        SmallTag(text: DealerRank.names[min(p.unlockLevel, DealerRank.names.count - 1)],
                                 tone: Age.oxblood)
                    }
                }
            }
            Spacer(minLength: 0)
            VStack(spacing: 4) {
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { i in
                        Circle().fill(i < p.difficulty ? Age.oxblood : Age.inkPale.opacity(0.25))
                            .frame(width: 5, height: 5)
                    }
                }
                ChevronGlyph().stroke(Age.inkPale, lineWidth: 1.6).frame(width: 8, height: 13)
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 3).fill(Age.card.opacity(store.unlocked(p) ? 0.96 : 0.6)))
        .overlay(RoundedRectangle(cornerRadius: 3).stroke(Age.inkPale.opacity(0.34), lineWidth: 1))
    }
}

struct PieceBriefing: View {
    let piece: PieceEntry
    let unlocked: Bool
    let best: Double
    let onStart: () -> Void
    let onClose: () -> Void

    var body: some View {
        ZStack {
            PaperBack()
            VStack(spacing: 0) {
                SheetHeader(title: piece.name, subtitle: "Lot from " + piece.region, onClose: onClose)
                Rule()
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        PlateCard(plate: piece.plate, height: 300)
                        Text("It arrives with no history and no label. Everything you are going to say about it has to come off the piece itself.")
                            .font(Age.serifItalic(16)).foregroundColor(Age.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                        Rule()
                        VStack(alignment: .leading, spacing: 8) {
                            SectionTitle(text: "What to look at")
                            ForEach(piece.spots) { s in
                                HStack(alignment: .top, spacing: 10) {
                                    Circle().fill(Age.sepia).frame(width: 5, height: 5)
                                        .padding(.top, 7)
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text(s.kind.title).font(Age.serifBold(14))
                                            .foregroundColor(Age.ink)
                                        Text(s.kind.instruction).font(Age.serif(12))
                                            .foregroundColor(Age.inkPale)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                            }
                        }
                        if best > 0 {
                            Text("Your best on this lot: \(Int(best * 100)) out of 100.")
                                .font(Age.serifItalic(14)).foregroundColor(Age.sepia)
                        }
                        PillButton(title: unlocked ? "Take it to the bench" : "Locked",
                                   enabled: unlocked, action: onStart)
                        if !unlocked {
                            Text("Reach \(DealerRank.names[min(piece.unlockLevel, DealerRank.names.count - 1)]) before the saleroom lets you near this one.")
                                .font(Age.serifItalic(13)).foregroundColor(Age.oxblood)
                        }
                        Spacer(minLength: 16)
                    }
                    .padding(18)
                }
            }
        }
    }
}

struct ExamView: View {
    @ObservedObject var session: ExamSession
    let onQuit: () -> Void
    @EnvironmentObject var store: LedgerStore
    @State private var showBracket = false
    @State private var filed = false

    var body: some View {
        VStack(spacing: 0) {
            AgeNavBar(title: session.piece.name,
                      subtitle: session.committed ? "Catalogued"
                        : (showBracket ? "Commit to a bracket" : "Find the evidence"),
                      onBack: onQuit)
            Rule()
            if session.committed, let r = session.result {
                verdict(r)
            } else if showBracket {
                bracketView
            } else {
                lookView
            }
        }
        .sheet(item: $session.openSpot) { s in
            InspectView(spot: s, onFound: {
                session.found.insert(s.title)
                if s.kind == .dovetails { store.award("dovetail") }
                if s.kind == .saw { store.award("saw") }
                if s.kind == .screws { store.award("screw") }
                store.addXP(14)
            }, onClose: { session.openSpot = nil })
        }
    }

    private var lookView: some View {
        ExamShell(title: "The piece",
                  instruction: "Tap where you want to look. Four places will tell you something, and each one narrows the date from one end or the other.",
                  readout: [("Found", "\(session.found.count) of \(session.piece.spots.count)"),
                            ("Timber", session.piece.timber.components(separatedBy: " ").first ?? ""),
                            ("Region", session.piece.region)]) {
            VStack(spacing: 10) {
                GeometryReader { geo in
                    ZStack {
                        PlateTop(name: session.piece.plate, band: 0.56)
                            .frame(width: geo.size.width, height: geo.size.height)
                        ForEach(session.piece.spots) { s in
                            let done = session.found.contains(s.title)
                            Button(action: { session.openSpot = s }) {
                                ZStack {
                                    Circle().fill(done ? Age.moss.opacity(0.30) : Age.card.opacity(0.22))
                                    Circle().stroke(done ? Age.moss : Age.oxblood, lineWidth: 2.2)
                                    if done {
                                        CheckGlyph().stroke(Age.moss,
                                                            style: StrokeStyle(lineWidth: 2.4, lineCap: .round))
                                            .frame(width: 16, height: 16)
                                    }
                                }
                                .frame(width: 40, height: 40)
                            }
                            .buttonStyle(GlyphButtonStyle())
                            .position(x: CGFloat(s.x) * geo.size.width,
                                      y: CGFloat(s.y) * geo.size.height)
                        }
                    }
                    .overlay(Rectangle().stroke(Age.inkPale.opacity(0.4), lineWidth: 1))
                }
                .aspectRatio(1.489, contentMode: .fit)
                .padding(.horizontal, 14)

                if !session.foundSpots.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(session.foundSpots) { s in
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(s.kind.title.uppercased()).font(Age.serifBold(9))
                                        .tracking(1.4).foregroundColor(Age.sepia)
                                    Text("\(s.from) — \(s.to)").font(Age.serifBold(14))
                                        .foregroundColor(Age.ink)
                                }
                                .padding(8)
                                .background(RoundedRectangle(cornerRadius: 2).fill(Age.card))
                                .overlay(RoundedRectangle(cornerRadius: 2)
                                    .stroke(Age.inkPale.opacity(0.4), lineWidth: 1))
                            }
                        }
                        .padding(.horizontal, 14)
                    }
                }

                PillButton(title: session.found.isEmpty ? "Nothing found yet" : "Take it to the register",
                           enabled: !session.found.isEmpty) {
                    let s = session.suggested
                    session.from = s.0
                    session.to = s.1
                    showBracket = true
                }
                .padding(.horizontal, 26).padding(.bottom, 8)
            }
        }
    }

    private var bracketView: some View {
        ExamShell(title: "The register",
                  instruction: "Every finding is a band on the timeline. Set your bracket where they overlap, and make it no wider than you can defend.",
                  readout: [("From", "\(session.from)"), ("To", "\(session.to)"),
                            ("Span", "\(session.to - session.from) yrs")]) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    RangeBar(from: $session.from, to: $session.to,
                             bands: session.foundSpots.map { ($0.from, $0.to) })
                        .padding(.horizontal, 6)
                    HStack {
                        Text("1600").font(Age.serif(12)).foregroundColor(Age.inkPale)
                        Spacer()
                        Text("1800").font(Age.serif(12)).foregroundColor(Age.inkPale)
                        Spacer()
                        Text("1975").font(Age.serif(12)).foregroundColor(Age.inkPale)
                    }
                    Rule()
                    VStack(alignment: .leading, spacing: 10) {
                        SectionTitle(text: "Your findings")
                        if session.foundSpots.isEmpty {
                            Text("Nothing. You are guessing.").font(Age.serifItalic(14))
                                .foregroundColor(Age.oxblood)
                        }
                        ForEach(session.foundSpots) { s in
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(s.title).font(Age.serifBold(14)).foregroundColor(Age.ink)
                                    Spacer()
                                    Text("\(s.from) — \(s.to)").font(Age.serifBold(13))
                                        .foregroundColor(Age.sepia)
                                }
                                Text(s.finding).font(Age.serif(13)).foregroundColor(Age.inkSoft)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 3).fill(Age.card))
                            .overlay(RoundedRectangle(cornerRadius: 3)
                                .stroke(Age.inkPale.opacity(0.35), lineWidth: 1))
                        }
                    }
                    HStack(spacing: 10) {
                        PillButton(title: "Look again", tone: Age.sepia, filled: false) {
                            showBracket = false
                        }
                        PillButton(title: "Commit") { _ = session.commit(); hapticSolid() }
                    }
                    Spacer(minLength: 20)
                }
                .padding(18)
            }
        }
    }

    private func verdict(_ r: Dating) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PlateCard(plate: session.piece.plate, height: 260)
                HStack {
                    StarRow(count: r.stars, size: 20)
                    Spacer()
                    Text("\(Int(r.score * 100)) / 100").font(Age.serifBold(22))
                        .foregroundColor(Age.ink)
                }
                Text(r.inside
                     ? "Your bracket holds it. \(session.piece.name) is about \(session.piece.year), and you said \(r.from) to \(r.to)."
                     : "Outside your bracket. It is about \(session.piece.year), and you said \(r.from) to \(r.to).")
                    .font(Age.serif(16)).foregroundColor(Age.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                RangeBar(from: .constant(r.from), to: .constant(r.to),
                         bands: session.piece.spots.map { ($0.from, $0.to) },
                         truth: session.piece.year)
                Rule()
                VStack(alignment: .leading, spacing: 8) {
                    SectionTitle(text: "What it actually is")
                    Text("\(session.piece.period), about \(session.piece.year), \(session.piece.region).")
                        .font(Age.serifBold(16)).foregroundColor(Age.ink)
                    Text(session.piece.timber).font(Age.serif(14)).foregroundColor(Age.inkSoft)
                    ForEach(session.piece.spots) { s in
                        HStack(alignment: .top, spacing: 8) {
                            Circle().fill(session.found.contains(s.title) ? Age.moss : Age.oxblood)
                                .frame(width: 5, height: 5).padding(.top, 7)
                            VStack(alignment: .leading, spacing: 1) {
                                Text(s.title).font(Age.serifBold(14)).foregroundColor(Age.ink)
                                Text(s.finding).font(Age.serif(13)).foregroundColor(Age.inkPale)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
                if filed, let c = store.lastConsignment {
                    VStack(alignment: .leading, spacing: 5) {
                        SectionTitle(text: c.done ? "Instruction filled" : "One filed")
                        Text(principalBySlug(c.principal).name)
                            .font(Age.serifBold(16)).foregroundColor(Age.ink)
                        Text(c.done
                             ? "Paid \(c.pay). Standing with them is up \(c.rep)."
                             : "\(c.done_) of \(c.count) filed. They are waiting on the rest.")
                            .font(Age.serif(14)).foregroundColor(Age.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 4).fill(Age.moss.opacity(0.14))
                        .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Age.moss.opacity(0.5), lineWidth: 1)))
                } else if filed, let m = store.lastConsignmentMiss {
                    VStack(alignment: .leading, spacing: 5) {
                        SectionTitle(text: "Not what was instructed")
                        Text(m).font(Age.serif(14)).foregroundColor(Age.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 4).fill(Age.card)
                        .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Age.inkPale.opacity(0.34), lineWidth: 1)))
                }

                PillButton(title: "Into the ledger") {
                    if !filed { filed = true; store.file(r) }
                    onQuit()
                }
                .padding(.bottom, 20)
            }
            .padding(18)
        }
    }
}
