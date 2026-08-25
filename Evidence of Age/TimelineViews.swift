import SwiftUI

struct TimelineFact: Identifiable {
    var id: String { label }
    let label: String
    let from: Int
    let to: Int
    let row: Int
    let note: String
}

enum Timeline {
    static let rows = ["Timber", "Saw", "Fixings", "Handles", "Finish", "Construction"]

    static let facts: [TimelineFact] = a + b

    private static let a: [TimelineFact] = [
        TimelineFact(label: "Oak", from: 1600, to: 1680, row: 0,
                     note: "Riven or pit sawn English oak, in frame and panel construction."),
        TimelineFact(label: "Walnut", from: 1665, to: 1735, row: 0,
                     note: "Solid and veneered. Ends with the winter of 1709 and a French export ban."),
        TimelineFact(label: "Mahogany", from: 1730, to: 1900, row: 0,
                     note: "Cuban first, dense and dark; then Honduras, lighter and easier to carve."),
        TimelineFact(label: "Rosewood and satinwood", from: 1790, to: 1840, row: 0,
                     note: "Exotic, expensive and almost always laid as veneer."),
        TimelineFact(label: "Oak and walnut again", from: 1840, to: 1910, row: 0,
                     note: "The Victorians go back to heavier native timbers and heavier shapes."),
        TimelineFact(label: "Plywood and maple", from: 1920, to: 1975, row: 0,
                     note: "Machine made grounds, knife cut veneer and sprayed finishes."),
        TimelineFact(label: "Riven", from: 1600, to: 1690, row: 1,
                     note: "Split with a froe along the grain. No tool marks at all."),
        TimelineFact(label: "Pit saw", from: 1600, to: 1810, row: 1,
                     note: "Two men, one above and one below. Straight marks at irregular spacing."),
        TimelineFact(label: "Frame saw", from: 1780, to: 1860, row: 1,
                     note: "Water or steam powered. Straight marks at very even spacing."),
        TimelineFact(label: "Circular saw", from: 1830, to: 1975, row: 1,
                     note: "Curved marks, and nothing else makes them. Never absent afterwards."),
        TimelineFact(label: "Hand made screws", from: 1600, to: 1780, row: 2,
                     note: "Filed slot, off centre, irregular thread, blunt end."),
        TimelineFact(label: "Machine thread, blunt", from: 1780, to: 1855, row: 2,
                     note: "Even threads from a lathe, but the point had not been invented."),
    ]

    private static let b: [TimelineFact] = [
        TimelineFact(label: "Gimlet point", from: 1850, to: 1975, row: 2,
                     note: "Pointed, even, slot dead centre. A hard date after which everything is machine made."),
        TimelineFact(label: "Rose head nails", from: 1600, to: 1800, row: 2,
                     note: "Hand forged, with hammer facets on the head."),
        TimelineFact(label: "Cut nails", from: 1800, to: 1895, row: 2,
                     note: "Rectangular in section, tapering on two sides only."),
        TimelineFact(label: "Wire nails", from: 1890, to: 1975, row: 2,
                     note: "Round in section, drawn from wire, with a flat head."),
        TimelineFact(label: "Iron hardware", from: 1600, to: 1700, row: 3,
                     note: "Wrought strap hinges, hasps and locks, punched rather than drilled."),
        TimelineFact(label: "Brass drops", from: 1670, to: 1715, row: 3,
                     note: "Cast drops on wire, with a single hole through the drawer front."),
        TimelineFact(label: "Pierced backplates", from: 1710, to: 1750, row: 3,
                     note: "A shaped plate behind a bail handle, cut and chased by hand."),
        TimelineFact(label: "Swan neck bails", from: 1740, to: 1800, row: 3,
                     note: "The classic Georgian handle, on a plain or stamped plate."),
        TimelineFact(label: "Wooden knobs", from: 1820, to: 1875, row: 3,
                     note: "Turned mahogany or walnut on a screw thread. Cheap and briefly universal."),
        TimelineFact(label: "Pressed brass", from: 1860, to: 1920, row: 3,
                     note: "Thin brass pressed in a die. Even relief and slightly soft detail."),
        TimelineFact(label: "Wax and oil", from: 1600, to: 1830, row: 4,
                     note: "Built up over generations, full of dirt, and the only honest surface there is."),
        TimelineFact(label: "French polish", from: 1820, to: 1930, row: 4,
                     note: "Shellac applied with a rubber. Deep gloss, and it blooms white if water touches it."),
        TimelineFact(label: "Cellulose", from: 1925, to: 1975, row: 4,
                     note: "Sprayed in a booth. It crazes into a fine crackle as it ages."),
        TimelineFact(label: "Pegged frame and panel", from: 1600, to: 1690, row: 5,
                     note: "Drawbored mortice and tenon, no glue, panels floating in grooves."),
        TimelineFact(label: "Dovetailed carcase", from: 1670, to: 1900, row: 5,
                     note: "Hand cut, narrow pins, and a gauge line that runs right across the board."),
        TimelineFact(label: "Machine dovetails", from: 1865, to: 1975, row: 5,
                     note: "Pins and tails identical, and the gauge line stops where the cutter stopped."),
        TimelineFact(label: "Staples and dowels", from: 1930, to: 1975, row: 5,
                     note: "Mass production. A staple in a carcase ends the argument immediately."),
    ]
}

struct TimelineRootView: View {
    @EnvironmentObject var store: LedgerStore
    @State private var year: Double = 1750
    @State private var visited: Set<Int> = []

    private var active: [TimelineFact] {
        Timeline.facts.filter { Double($0.from) <= year && Double($0.to) >= year }
    }

    var body: some View {
        ZStack {
            PaperBack()
            VStack(spacing: 0) {
                AgeNavBar(title: "The Timeline",
                          subtitle: "Drag the year and watch the evidence change")
                Rule()
                VStack(spacing: 8) {
                    Text("\(Int(year))").font(Age.serifBold(44)).foregroundColor(Age.ink)
                    GeometryReader { g in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Age.inkPale.opacity(0.22)).frame(height: 8)
                            Capsule().fill(Age.oxblood)
                                .frame(width: g.size.width * CGFloat((year - 1600) / 375), height: 8)
                            Circle().fill(Age.card)
                                .overlay(Circle().stroke(Age.oxblood, lineWidth: 2))
                                .frame(width: 26, height: 26)
                                .offset(x: max(0, min(g.size.width - 26,
                                                      g.size.width * CGFloat((year - 1600) / 375) - 13)))
                        }
                        .frame(height: 30)
                        .contentShape(Rectangle())
                        .gesture(DragGesture(minimumDistance: 0).onChanged { v in
                            year = max(1600, min(1975, 1600 + Double(v.location.x / g.size.width) * 375))
                            visited.insert(Int(year) / 25)
                            if visited.count >= 14 { store.award("timeline") }
                        })
                    }
                    .frame(height: 30)
                    HStack {
                        Text("1600").font(Age.serif(11)).foregroundColor(Age.inkPale)
                        Spacer()
                        Text("1975").font(Age.serif(11)).foregroundColor(Age.inkPale)
                    }
                }
                .padding(.horizontal, 20).padding(.vertical, 10)
                Rule()
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(Timeline.rows.enumerated()), id: \.offset) { i, rowName in
                            let hit = active.filter { $0.row == i }
                            CardBox {
                                VStack(alignment: .leading, spacing: 8) {
                                    SectionTitle(text: rowName)
                                    if hit.isEmpty {
                                        Text("Nothing typical of this year.")
                                            .font(Age.serifItalic(14)).foregroundColor(Age.inkPale)
                                    }
                                    ForEach(hit) { f in
                                        VStack(alignment: .leading, spacing: 3) {
                                            HStack {
                                                Text(f.label).font(Age.serifBold(15))
                                                    .foregroundColor(Age.ink)
                                                Spacer()
                                                Text("\(f.from) — \(f.to)").font(Age.serif(12))
                                                    .foregroundColor(Age.sepia)
                                            }
                                            Text(f.note).font(Age.serif(13))
                                                .foregroundColor(Age.inkSoft)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                    }
                                }
                            }
                        }
                        Spacer(minLength: 20)
                    }
                    .padding(14)
                }
            }
        }
    }
}
