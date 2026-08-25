import SwiftUI

struct BookRootView: View {
    @EnvironmentObject var store: LedgerStore
    @State private var tab = 0
    @State private var openPiece: PieceEntry?
    @State private var openGuide: GuideEntry?
    @State private var openKit: KitEntry?
    @State private var quiz = false

    var body: some View {
        ZStack {
            PaperBack()
            VStack(spacing: 0) {
                AgeNavBar(title: "The Book",
                           subtitle: "Thirty two lots, and how a date is argued")
                Rule()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        seg("Lots", 0); seg("Craft", 1); seg("Kit", 2)
                        seg("Terms", 3); seg("Board", 4)
                    }
                    .padding(.horizontal, 14).padding(.vertical, 10)
                }
                Rule()
                ScrollView {
                    switch tab {
                    case 0: pieceList
                    case 1: guideList
                    case 2: kitList
                    case 3: glossaryList
                    default: boardPanel
                    }
                }
            }
        }
        .sheet(item: $openPiece) { s in
            EntryReader(title: s.name, subtitle: s.period + "  ·  " + s.region,
                        plate: s.plate, lead: s.line,
                        sections: [("Timber", s.timber), ("Hardware", s.hardware),
                                   ("About", "\(s.year)")] + s.spots.map { ($0.title, $0.finding) }) {
                openPiece = nil
            }
            .onAppear { store.markSeen("piece-" + s.id) }
        }
        .sheet(item: $openGuide) { g in
            EntryReader(title: g.title, subtitle: g.plateNo, plate: g.plate, lead: g.sub,
                        sections: g.sections) { openGuide = nil }
                .onAppear { store.markSeen("guide-" + g.id) }
        }
        .sheet(item: $openKit) { k in
            EntryReader(title: k.name, subtitle: k.sub, plate: k.plate, lead: k.note,
                        sections: []) { openKit = nil }
                .onAppear { store.markSeen("kit-" + k.id) }
        }
        .sheet(isPresented: $quiz) { QuizView { quiz = false }.environmentObject(store) }
    }

    private func seg(_ t: String, _ i: Int) -> some View {
        Button(action: { tab = i }) {
            Text(t.uppercased()).font(Age.serifBold(10)).tracking(1.6)
                .foregroundColor(tab == i ? Age.card : Age.inkPale)
                .padding(.horizontal, 13).padding(.vertical, 7)
                .background(RoundedRectangle(cornerRadius: 2)
                    .fill(tab == i ? Age.oxblood : Color.clear)
                    .overlay(RoundedRectangle(cornerRadius: 2)
                        .stroke(Age.inkPale.opacity(0.5), lineWidth: 1)))
        }
        .buttonStyle(GlyphButtonStyle())
    }

    private var pieceList: some View {
        LazyVStack(spacing: 10) {
            ForEach(Pieces.all) { s in
                Button(action: { openPiece = s }) {
                    HStack(spacing: 12) {
                        PlateThumb(name: s.plate, focusY: 0.30, bandHeight: 0.38, maxDim: 420)
                            .frame(width: 100, height: 74)
                            .overlay(Rectangle().stroke(Age.inkPale.opacity(0.4), lineWidth: 1))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(s.name).font(Age.serifBold(15)).foregroundColor(Age.ink)
                            Text(s.period + "  ·  " + s.region).font(Age.serif(12))
                                .foregroundColor(Age.inkPale)
                            SmallTag(text: s.timber, tone: Age.sepia)
                        }
                        Spacer(minLength: 0)
                        ChevronGlyph().stroke(Age.inkPale, lineWidth: 1.6).frame(width: 8, height: 13)
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 3).fill(Age.card))
                    .overlay(RoundedRectangle(cornerRadius: 3).stroke(Age.inkPale.opacity(0.4), lineWidth: 1))
                }
                .buttonStyle(GlyphButtonStyle())
            }
        }
        .padding(14)
    }

    private var guideList: some View {
        LazyVStack(spacing: 10) {
            ForEach(Book.guides) { g in
                Button(action: { openGuide = g }) {
                    HStack(spacing: 12) {
                        PlateView(name: g.plate, maxDim: 380, mode: .fill)
                            .frame(width: 84, height: 76).clipped()
                            .overlay(Rectangle().stroke(Age.inkPale.opacity(0.4), lineWidth: 1))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(g.plateNo.uppercased()).font(Age.serifBold(9)).tracking(1.6)
                                .foregroundColor(Age.oxblood)
                            Text(g.title).font(Age.serifBold(15)).foregroundColor(Age.ink)
                                .fixedSize(horizontal: false, vertical: true)
                            Text(g.sub).font(Age.serifItalic(12)).foregroundColor(Age.inkPale)
                                .lineLimit(2)
                        }
                        Spacer(minLength: 0)
                        if store.state.seen.contains("guide-" + g.id) {
                            CheckGlyph().stroke(Age.moss, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                                .frame(width: 15, height: 15)
                        }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 3).fill(Age.card))
                    .overlay(RoundedRectangle(cornerRadius: 3).stroke(Age.inkPale.opacity(0.4), lineWidth: 1))
                }
                .buttonStyle(GlyphButtonStyle())
            }
        }
        .padding(14)
    }

    private var kitList: some View {
        LazyVStack(spacing: 10) {
            ForEach(Book.kit) { k in
                Button(action: { openKit = k }) {
                    HStack(spacing: 12) {
                        PlateView(name: k.plate, maxDim: 380, mode: .fill)
                            .frame(width: 96, height: 74).clipped()
                            .overlay(Rectangle().stroke(Age.inkPale.opacity(0.4), lineWidth: 1))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(k.name).font(Age.serifBold(15)).foregroundColor(Age.ink)
                            Text(k.sub).font(Age.serifItalic(12)).foregroundColor(Age.inkPale)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 3).fill(Age.card))
                    .overlay(RoundedRectangle(cornerRadius: 3).stroke(Age.inkPale.opacity(0.4), lineWidth: 1))
                }
                .buttonStyle(GlyphButtonStyle())
            }
        }
        .padding(14)
    }

    private var glossaryList: some View {
        LazyVStack(spacing: 8) {
            ForEach(Book.glossary) { g in
                VStack(alignment: .leading, spacing: 3) {
                    Text(g.term).font(Age.serifBold(15)).foregroundColor(Age.ink)
                    Text(g.meaning).font(Age.serif(13)).foregroundColor(Age.ink.opacity(0.78))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(12).frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 3).fill(Age.card))
                .overlay(RoundedRectangle(cornerRadius: 3).stroke(Age.inkPale.opacity(0.4), lineWidth: 1))
            }
        }
        .padding(14)
    }

    private var boardPanel: some View {
        VStack(spacing: 14) {
            PlateCard(plate: "guide_faking", height: 220)
            CardBox {
                VStack(alignment: .leading, spacing: 10) {
                    SectionTitle(text: "Face the board")
                    Text("Thirty two questions on joints, saws, fixings, timber and wear. One at a time, and see how long a run you can hold.")
                        .font(Age.serif(14)).foregroundColor(Age.ink.opacity(0.82))
                        .fixedSize(horizontal: false, vertical: true)
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("BEST RUN").font(Age.serifBold(9)).tracking(1.5)
                                .foregroundColor(Age.inkPale)
                            Text("\(store.state.quizStreakBest)").font(Age.serifBold(22))
                                .foregroundColor(Age.ink)
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 2) {
                            Text("BEST SCORE").font(Age.serifBold(9)).tracking(1.5)
                                .foregroundColor(Age.inkPale)
                            Text("\(store.state.quizBest)").font(Age.serifBold(22))
                                .foregroundColor(Age.ink)
                        }
                        Spacer()
                    }
                    PillButton(title: "Begin") { quiz = true }
                }
            }
        }
        .padding(14)
    }
}

struct EntryReader: View {
    let title: String
    let subtitle: String
    let plate: String
    let lead: String
    let sections: [(String, String)]
    let onClose: () -> Void

    var body: some View {
        ZStack {
            PaperBack()
            VStack(spacing: 0) {
                SheetHeader(title: title, subtitle: subtitle, onClose: onClose)
                Rule()
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        PlateCard(plate: plate, height: 300)
                        Text(lead).font(Age.serifItalic(16)).foregroundColor(Age.ink.opacity(0.88))
                            .fixedSize(horizontal: false, vertical: true)
                        if !sections.isEmpty {
                            Rule()
                            ForEach(Array(sections.enumerated()), id: \.offset) { _, s in
                                VStack(alignment: .leading, spacing: 5) {
                                    SectionTitle(text: s.0, accent: Age.inkPale)
                                    Text(s.1).font(Age.serif(15))
                                        .foregroundColor(Age.ink.opacity(0.84))
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        Spacer(minLength: 20)
                    }
                    .padding(18)
                }
            }
        }
    }
}

struct QuizView: View {
    let onClose: () -> Void
    @EnvironmentObject var store: LedgerStore
    @State private var order: [Int] = []
    @State private var index = 0
    @State private var picked: Int? = nil
    @State private var correct = 0
    @State private var run = 0
    @State private var bestRun = 0
    @State private var finished = false

    private var item: QuizItem { Book.quiz[order.isEmpty ? 0 : order[min(index, order.count - 1)]] }

    var body: some View {
        ZStack {
            PaperBack()
            VStack(spacing: 0) {
                SheetHeader(title: "The Board",
                            subtitle: finished ? "Done" : "Question \(index + 1) of \(order.count)",
                            onClose: onClose)
                Rule()
                if finished {
                    ScrollView {
                        VStack(spacing: 16) {
                            Text("\(correct) of \(order.count)").font(Age.serifBold(40))
                                .foregroundColor(Age.ink)
                            Text("Longest run: \(bestRun)").font(Age.serif(16))
                                .foregroundColor(Age.inkPale)
                            Text(correct >= order.count - 2
                                 ? "You could catalogue a sale tomorrow and nobody would query a line of it."
                                 : (correct > order.count / 2
                                    ? "Sound enough. The gaps are worth a second read of the craft plates."
                                    : "Worth going back through the plates before the next board."))
                                .font(Age.serifItalic(15)).foregroundColor(Age.inkPale)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                            PillButton(title: "Close", action: onClose)
                        }
                        .padding(24)
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                SmallTag(text: "Run \(run)", tone: Age.moss)
                                SmallTag(text: "\(correct) right", tone: Age.inkPale)
                                Spacer()
                            }
                            Text(item.question).font(Age.serifBold(19)).foregroundColor(Age.ink)
                                .fixedSize(horizontal: false, vertical: true)
                            ForEach(Array(item.options.enumerated()), id: \.offset) { i, opt in
                                Button(action: { pick(i) }) {
                                    HStack(alignment: .top, spacing: 10) {
                                        Circle().fill(fillFor(i))
                                            .overlay(Circle().stroke(Age.inkPale, lineWidth: 1.2))
                                            .frame(width: 16, height: 16).padding(.top, 2)
                                        Text(opt).font(Age.serif(15))
                                            .foregroundColor(Age.ink.opacity(0.88))
                                            .fixedSize(horizontal: false, vertical: true)
                                        Spacer(minLength: 0)
                                    }
                                    .padding(12)
                                    .background(RoundedRectangle(cornerRadius: 3).fill(Age.card))
                                    .overlay(RoundedRectangle(cornerRadius: 3)
                                        .stroke(strokeFor(i), lineWidth: 1.2))
                                }
                                .buttonStyle(GlyphButtonStyle())
                                .disabled(picked != nil)
                            }
                            if picked != nil {
                                VStack(alignment: .leading, spacing: 6) {
                                    SectionTitle(text: picked == item.answer ? "Right" : "Not quite",
                                                 accent: picked == item.answer ? Age.moss : Age.oxblood)
                                    Text(item.because).font(Age.serif(14))
                                        .foregroundColor(Age.ink.opacity(0.84))
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                PillButton(title: index + 1 >= order.count ? "Finish" : "Next") { advance() }
                            }
                        }
                        .padding(18)
                    }
                }
            }
        }
        .onAppear(perform: setup)
    }

    private func setup() {
        guard order.isEmpty else { return }
        order = Array(Book.quiz.indices).shuffled().prefix(12).map { $0 }
    }
    private func fillFor(_ i: Int) -> Color {
        guard let p = picked else { return Color.clear }
        if i == item.answer { return Age.moss }
        if i == p { return Age.oxblood }
        return Color.clear
    }
    private func strokeFor(_ i: Int) -> Color {
        guard let p = picked else { return Age.inkPale.opacity(0.4) }
        if i == item.answer { return Age.moss.opacity(0.8) }
        if i == p { return Age.oxblood.opacity(0.8) }
        return Age.inkPale.opacity(0.4)
    }
    private func pick(_ i: Int) {
        guard picked == nil else { return }
        picked = i
        if i == item.answer {
            correct += 1; run += 1; bestRun = max(bestRun, run)
            if run >= 12 { store.award("quiz") }
            hapticTick()
        } else { run = 0; hapticSolid() }
    }
    private func advance() {
        if index + 1 >= order.count {
            store.state.quizBest = max(store.state.quizBest, correct)
            store.state.quizStreakBest = max(store.state.quizStreakBest, bestRun)
            store.addXP(correct * 8)
            finished = true
        } else { index += 1; picked = nil }
    }
}
