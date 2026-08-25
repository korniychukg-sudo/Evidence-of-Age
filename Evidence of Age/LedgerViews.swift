import SwiftUI

struct LedgerRootView: View {
    @EnvironmentObject var store: LedgerStore
    @State private var tab = 0
    @State private var chosen: Dating?

    var body: some View {
        ZStack {
            PaperBack()
            VStack(spacing: 0) {
                AgeNavBar(title: "The Ledger", subtitle: "Every lot you have put a date on")
                Rule()
                HStack(spacing: 0) { seg("Datings", 0); seg("Marks", 1); seg("Records", 2) }
                    .padding(.horizontal, 14).padding(.vertical, 10)
                Rule()
                ScrollView {
                    switch tab {
                    case 0: datingList
                    case 1: badgeList
                    default: records
                    }
                }
            }
        }
        .sheet(item: $chosen) { d in DatingDetail(dating: d) { chosen = nil } }
    }

    private func seg(_ t: String, _ i: Int) -> some View {
        Button(action: { tab = i }) {
            Text(t.uppercased()).font(Age.serifBold(11)).tracking(1.8)
                .foregroundColor(tab == i ? Age.card : Age.sepia)
                .frame(maxWidth: .infinity).padding(.vertical, 9)
                .background(RoundedRectangle(cornerRadius: 2)
                    .fill(tab == i ? Age.sepia : Color.clear)
                    .overlay(RoundedRectangle(cornerRadius: 2)
                        .stroke(Age.sepia.opacity(0.4), lineWidth: 1)))
        }
        .buttonStyle(GlyphButtonStyle())
    }

    private var datingList: some View {
        Group {
            if store.state.datings.isEmpty {
                EmptyNote(title: "Nothing catalogued yet",
                          body1: "Take a lot to the bench, find what it is telling you, and commit to a bracket.")
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(store.state.datings) { d in
                        Button(action: { chosen = d }) {
                            HStack(spacing: 12) {
                                PlateThumb(name: d.piece.plate, focusY: 0.30, bandHeight: 0.36,
                                           maxDim: 380)
                                    .frame(width: 86, height: 70)
                                    .overlay(Rectangle().stroke(Age.inkPale.opacity(0.4), lineWidth: 1))
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(d.piece.name).font(Age.serifBold(15))
                                        .foregroundColor(Age.ink).lineLimit(1)
                                    Text("\(d.from) — \(d.to)  ·  \(shortDate(d.date))")
                                        .font(Age.serif(12)).foregroundColor(Age.inkPale)
                                    HStack(spacing: 6) {
                                        StarRow(count: d.stars, size: 11)
                                        SmallTag(text: d.inside ? "Right" : "Outside",
                                                 tone: d.inside ? Age.moss : Age.oxblood)
                                    }
                                }
                                Spacer(minLength: 0)
                                Text("\(Int(d.score * 100))").font(Age.serifBold(19))
                                    .foregroundColor(Age.sepia)
                            }
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 3).fill(Age.card))
                            .overlay(RoundedRectangle(cornerRadius: 3)
                                .stroke(Age.inkPale.opacity(0.34), lineWidth: 1))
                        }
                        .buttonStyle(GlyphButtonStyle())
                    }
                }
                .padding(14)
            }
        }
    }

    private var badgeList: some View {
        LazyVStack(spacing: 8) {
            ForEach(Badges.all) { b in
                let got = store.hasBadge(b.id)
                HStack(spacing: 12) {
                    ZStack {
                        Circle().fill(got ? Age.brass.opacity(0.18) : Color.clear)
                            .overlay(Circle().stroke(got ? Age.brass : Age.inkPale.opacity(0.4),
                                                     lineWidth: 1.4))
                        if got { StarGlyph().fill(Age.brass).frame(width: 17, height: 17) }
                        else { LockGlyph().stroke(Age.inkPale.opacity(0.6), lineWidth: 1.4)
                                .frame(width: 16, height: 16) }
                    }
                    .frame(width: 38, height: 38)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(b.name).font(Age.serifBold(15))
                            .foregroundColor(got ? Age.ink : Age.inkPale)
                        Text(b.note).font(Age.serif(12)).foregroundColor(Age.inkPale)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer(minLength: 0)
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 3)
                    .fill(got ? Age.card : Age.card.opacity(0.5)))
                .overlay(RoundedRectangle(cornerRadius: 3).stroke(Age.inkPale.opacity(0.3), lineWidth: 1))
            }
        }
        .padding(14)
    }

    private var records: some View {
        VStack(spacing: 12) {
            CardBox {
                VStack(alignment: .leading, spacing: 12) {
                    SectionTitle(text: "The season")
                    row("Rank", DealerRank.name(store.state.xp))
                    row("Experience", "\(store.state.xp)")
                    row("Lots catalogued", "\(store.state.datings.count)")
                    row("Inside the bracket", "\(store.state.datings.filter { $0.inside }.count)")
                    row("Different lots", "\(Set(store.state.datings.map { $0.pieceID }).count) of \(Pieces.all.count)")
                    row("Plates read", "\(store.state.seen.count)")
                }
            }
            CardBox {
                VStack(alignment: .leading, spacing: 12) {
                    SectionTitle(text: "Bests")
                    row("Best dating", store.state.datings.map { $0.score }.max().map { "\(Int($0 * 100))" } ?? "-")
                    row("Tightest right bracket", tightest)
                    row("Run of correct calls", "\(store.state.bestRun)")
                    row("Longest streak", "\(store.state.bestStreak) days")
                    row("Quiz best run", "\(store.state.quizStreakBest)")
                }
            }
        }
        .padding(14)
    }

    private var tightest: String {
        let right = store.state.datings.filter { $0.inside }
        guard let best = right.map({ $0.to - $0.from }).min() else { return "-" }
        return "\(best) years"
    }

    private func row(_ k: String, _ v: String) -> some View {
        HStack {
            Text(k).font(Age.serif(14)).foregroundColor(Age.inkSoft)
            Spacer()
            Text(v).font(Age.serifBold(14)).foregroundColor(Age.ink)
        }
    }
}

struct DatingDetail: View {
    let dating: Dating
    let onClose: () -> Void

    var body: some View {
        ZStack {
            PaperBack(name: "bg_card")
            VStack(spacing: 0) {
                SheetHeader(title: dating.piece.name,
                            subtitle: "Catalogued \(shortDate(dating.date))", onClose: onClose)
                Rule()
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        PlateCard(plate: dating.piece.plate, height: 300)
                        HStack {
                            StarRow(count: dating.stars, size: 20)
                            Spacer()
                            Text("\(Int(dating.score * 100)) / 100").font(Age.serifBold(22))
                                .foregroundColor(Age.ink)
                        }
                        RangeBar(from: .constant(dating.from), to: .constant(dating.to),
                                 bands: dating.piece.spots.map { ($0.from, $0.to) },
                                 truth: dating.piece.year)
                        Text(dating.inside
                             ? "Your bracket of \(dating.from) to \(dating.to) holds the true date of about \(dating.piece.year)."
                             : "You said \(dating.from) to \(dating.to). It is about \(dating.piece.year).")
                            .font(Age.serif(15)).foregroundColor(Age.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                        Rule()
                        VStack(alignment: .leading, spacing: 8) {
                            SectionTitle(text: "The evidence")
                            ForEach(dating.piece.spots) { s in
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(s.title).font(Age.serifBold(14)).foregroundColor(Age.ink)
                                    Text(s.finding).font(Age.serif(13)).foregroundColor(Age.inkPale)
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
