import SwiftUI

struct ConsignmentCard: View {
    let consignment: Consignment
    let now: Date
    let taken: Bool

    private var left: Int { consignment.daysLeft(now) }
    private var urgent: Bool { left <= 2 }

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(consignment.title).font(Age.serifBold(16)).foregroundColor(Age.ink)
                    Text(principalBySlug(consignment.principal).name)
                        .font(Age.serifItalic(13)).foregroundColor(Age.inkPale)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(consignment.pay)").font(Age.serifBold(19)).foregroundColor(Age.oxblood)
                    Text((left == 0 ? "today" : (left == 1 ? "1 day" : "\(left) days")).uppercased())
                        .font(Age.serif(10)).tracking(1.6)
                        .foregroundColor(urgent ? Age.oxblood : Age.inkPale)
                }
            }
            Rule()
            ForEach(Array(consignment.demands.enumerated()), id: \.offset) { _, d in
                HStack(spacing: 6) {
                    Rectangle().fill(Age.brass.opacity(0.8)).frame(width: 4, height: 4)
                    Text(d).font(Age.serif(13)).foregroundColor(Age.inkSoft)
                }
            }
            if taken {
                Text(consignment.count > 1
                     ? "TAKEN  \u{00B7}  \(consignment.done_) OF \(consignment.count)" : "TAKEN")
                    .font(Age.serif(10)).tracking(1.8).foregroundColor(Age.moss)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(taken ? Age.linen : Age.card)
                .overlay(RoundedRectangle(cornerRadius: 4)
                    .stroke(urgent && taken ? Age.oxblood.opacity(0.5) : Age.inkPale.opacity(0.34),
                            lineWidth: urgent && taken ? 1.6 : 1))
        )
    }
}

struct ConsignmentPage: View {
    @EnvironmentObject var store: LedgerStore
    @Environment(\.presentationMode) var presentation
    let consignment: Consignment
    let taken: Bool

    private var principal: Principal { principalBySlug(consignment.principal) }
    private var rep: Int { store.state.principalRep[consignment.principal] ?? 0 }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                CardBox {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(principal.trade.uppercased()).font(Age.serif(11)).tracking(2.2)
                            .foregroundColor(Age.inkPale)
                        Rule()
                        Text(principal.temper).font(Age.serifItalic(15)).foregroundColor(Age.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                        HStack {
                            Text("STANDING WITH THEM").font(Age.serif(10)).tracking(1.8)
                                .foregroundColor(Age.inkPale)
                            Spacer()
                            Text("\(min(100, rep * 2))%").font(Age.serifBold(12))
                                .foregroundColor(Age.inkSoft)
                        }
                        MeterBar(value: min(1, Double(rep) / 60), tone: Age.brass).frame(height: 6)
                    }
                }
                CardBox {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(consignment.title).font(Age.serifBold(18)).foregroundColor(Age.ink)
                        Text("\u{201C}" + consignment.line + "\u{201D}")
                            .font(Age.serif(15)).foregroundColor(Age.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                        Rule()
                        ForEach(Array(consignment.demands.enumerated()), id: \.offset) { _, d in
                            HStack(spacing: 8) {
                                Rectangle().fill(Age.brass).frame(width: 5, height: 5)
                                Text(d).font(Age.serifBold(14)).foregroundColor(Age.ink)
                            }
                        }
                        Rule()
                        AgeStat(label: "Pays", value: "\(consignment.pay)")
                        AgeStat(label: "Due in", value: consignment.daysLeft(Date()) == 1 ? "1 day"
                                    : "\(consignment.daysLeft(Date())) days")
                        AgeStat(label: "Standing", value: "+\(consignment.rep) when it is filled")
                        if consignment.count > 1 {
                            AgeStat(label: "Filed", value: "\(consignment.done_) of \(consignment.count)")
                        }
                    }
                }
                if let pid = consignment.piece, let e = Pieces.piece(pid) {
                    CardBox {
                        HStack(spacing: 12) {
                            PlateCard(plate: e.plate, height: 78).frame(width: 106)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(e.name).font(Age.serifBold(15)).foregroundColor(Age.ink)
                                Text(e.region).font(Age.serif(12)).foregroundColor(Age.inkPale)
                                Text(e.timber).font(Age.serifItalic(12)).foregroundColor(Age.inkSoft)
                            }
                            Spacer()
                        }
                    }
                }
                if taken {
                    PillButton(title: "Send it back", tone: Age.oxblood) {
                        store.dropConsignment(consignment)
                        presentation.wrappedValue.dismiss()
                    }
                } else {
                    PillButton(title: "Take the instruction", tone: Age.walnut) {
                        store.takeConsignment(consignment)
                        presentation.wrappedValue.dismiss()
                    }
                }
            }
            .padding(14)
            .padding(.top, 46)
        }
        .background(PaperBack().ignoresSafeArea())
        .navigationBarHidden(true)
        .overlay(AgeNavBar(title: principal.name), alignment: .top)
    }
}

struct AgeStat: View {
    let label: String
    let value: String
    var body: some View {
        HStack {
            Text(label).font(Age.serif(14)).foregroundColor(Age.inkSoft)
            Spacer()
            Text(value).font(Age.serifBold(14)).foregroundColor(Age.ink)
        }
    }
}

struct DeskShopView: View {
    @EnvironmentObject var store: LedgerStore

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                CardBox {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("FEES BANKED").font(Age.serif(10)).tracking(2.0)
                                .foregroundColor(Age.inkPale)
                            Text("\(store.state.money)").font(Age.serifBold(26))
                                .foregroundColor(Age.ink)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("OWNED").font(Age.serif(10)).tracking(2.0)
                                .foregroundColor(Age.inkPale)
                            Text("\(store.state.tools.count) of \(deskTools.count)")
                                .font(Age.serifBold(18)).foregroundColor(Age.inkSoft)
                        }
                    }
                }
                Text("Every one of these changes what the bench can show you, not what it looks like.")
                    .font(Age.serifItalic(14)).foregroundColor(Age.inkPale)
                    .multilineTextAlignment(.center)
                ForEach(deskTools) { t in DeskToolRow(tool: t) }
            }
            .padding(14)
            .padding(.top, 46)
        }
        .background(PaperBack().ignoresSafeArea())
        .navigationBarHidden(true)
        .overlay(AgeNavBar(title: "The Bench"), alignment: .top)
    }
}

struct DeskToolRow: View {
    @EnvironmentObject var store: LedgerStore
    let tool: DeskTool

    private var owned: Bool { store.state.tools.contains(tool.slug) }
    private var affordable: Bool { store.state.money >= tool.price }

    var body: some View {
        CardBox {
            VStack(spacing: 10) {
                HStack(spacing: 12) {
                    PlateCard(plate: tool.plate, height: 68).frame(width: 78)
                    VStack(alignment: .leading, spacing: 3) {
                        HStack {
                            Text(tool.name).font(Age.serifBold(16)).foregroundColor(Age.ink)
                            Spacer()
                            if owned {
                                Text("OWNED").font(Age.serif(10)).tracking(1.8)
                                    .foregroundColor(Age.moss)
                            } else {
                                Text("\(tool.price)").font(Age.serifBold(16))
                                    .foregroundColor(affordable ? Age.walnut : Age.inkPale)
                            }
                        }
                        Text(tool.line).font(Age.serif(12)).foregroundColor(Age.inkPale)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                HStack(spacing: 6) {
                    Rectangle().fill(Age.moss.opacity(0.8)).frame(width: 4, height: 4)
                    Text(tool.effect).font(Age.serifBold(13))
                        .foregroundColor(owned ? Age.moss : Age.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                if !owned {
                    PillButton(title: affordable ? "Buy it" : "Not enough banked",
                               tone: Age.walnut, enabled: affordable) {
                        store.buyTool(tool)
                    }
                }
            }
        }
    }
}
