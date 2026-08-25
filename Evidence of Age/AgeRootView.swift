import SwiftUI

struct AgeRootView: View {
    @EnvironmentObject var store: LedgerStore
    @State private var tab: Int = 0
    @State private var intro = false

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Group {
                    switch tab {
                    case 0:
                        NavigationView {
                            RoomRootView(goToBench: { tab = 1 }, goToTimeline: { tab = 2 })
                                .navigationBarHidden(true)
                        }.navigationViewStyle(StackNavigationViewStyle())
                    case 1:
                        NavigationView { BenchRootView().navigationBarHidden(true) }
                            .navigationViewStyle(StackNavigationViewStyle())
                    case 2:
                        NavigationView { TimelineRootView().navigationBarHidden(true) }
                            .navigationViewStyle(StackNavigationViewStyle())
                    case 3:
                        NavigationView { BookRootView().navigationBarHidden(true) }
                            .navigationViewStyle(StackNavigationViewStyle())
                    default:
                        NavigationView { LedgerRootView().navigationBarHidden(true) }
                            .navigationViewStyle(StackNavigationViewStyle())
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                HStack(spacing: 0) {
                    tabButton(0, "Room", AnyView(RoomGlyph()
                        .stroke(tone(0), style: StrokeStyle(lineWidth: 1.7, lineJoin: .round))))
                    tabButton(1, "Bench", AnyView(BenchGlyph()
                        .stroke(tone(1), style: StrokeStyle(lineWidth: 1.7, lineJoin: .round))))
                    tabButton(2, "Timeline", AnyView(RuleGlyph()
                        .stroke(tone(2), style: StrokeStyle(lineWidth: 1.7, lineJoin: .round))))
                    tabButton(3, "Book", AnyView(BookGlyph()
                        .stroke(tone(3), style: StrokeStyle(lineWidth: 1.7, lineJoin: .round))))
                    tabButton(4, "Ledger", AnyView(LedgerGlyph()
                        .stroke(tone(4), style: StrokeStyle(lineWidth: 1.7, lineJoin: .round))))
                }
                .padding(.top, 9).padding(.bottom, 3)
                .background(Age.card.overlay(Rule(color: Age.sepia), alignment: .top)
                    .ignoresSafeArea(edges: .bottom))
            }
            if intro {
                IntroCard { intro = false; store.state.introSeen = true; store.saveNow() }
            }
        }
        .onAppear { if !store.state.introSeen { intro = true } }
    }

    private func tone(_ i: Int) -> Color { tab == i ? Age.oxblood : Age.inkPale.opacity(0.65) }

    private func tabButton(_ i: Int, _ label: String, _ icon: AnyView) -> some View {
        Button(action: { tab = i; hapticTick() }) {
            VStack(spacing: 4) {
                icon.frame(width: 25, height: 25)
                Text(label.uppercased()).font(Age.serifBold(9)).tracking(1.1)
                    .foregroundColor(tone(i))
            }
            .frame(maxWidth: .infinity).contentShape(Rectangle())
        }
        .buttonStyle(GlyphButtonStyle())
    }
}

struct IntroCard: View {
    let onClose: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.55).ignoresSafeArea()
            VStack(spacing: 0) {
                PlateView(name: "guide_dovetail", maxDim: 700, mode: .fill)
                    .frame(height: 190).clipped()
                VStack(alignment: .leading, spacing: 12) {
                    Text("It arrives with no label")
                        .font(Age.serifBold(23)).foregroundColor(Age.ink)
                    Text("A dating is an argument built from evidence. Every joint, every saw mark, every screw and every worn edge narrows the range from one end or the other.")
                        .font(Age.serif(15)).foregroundColor(Age.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                    VStack(alignment: .leading, spacing: 7) {
                        bullet("Look properly", "Rake a light across a board, turn a screw under the glass, measure across the grain and along it.")
                        bullet("Collect the bands", "Each finding gives you a window. Where the windows overlap is where the truth is.")
                        bullet("Commit to a bracket", "Not a year. A range you are willing to put in a catalogue and defend.")
                    }
                    PillButton(title: "Open the saleroom", action: onClose)
                }
                .padding(20).background(Age.card)
            }
            .frame(maxWidth: 420)
            .overlay(Rectangle().stroke(Age.sepia.opacity(0.5), lineWidth: 1))
            .padding(22)
        }
    }

    private func bullet(_ title: String, _ body: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Circle().fill(Age.oxblood).frame(width: 5, height: 5).padding(.top, 6)
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(Age.serifBold(14)).foregroundColor(Age.ink)
                Text(body).font(Age.serif(13)).foregroundColor(Age.inkPale)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
