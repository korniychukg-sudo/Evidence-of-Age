import SwiftUI

struct PaperBack: View {
    var name: String = "bg_paper"
    var body: some View {
        Color.clear.overlay(PlateView(name: name, maxDim: 900, mode: .fill))
            .clipped().ignoresSafeArea()
    }
}

struct SectionTitle: View {
    let text: String
    var accent: Color = Age.oxblood
    var body: some View {
        Text(text.uppercased()).font(Age.serifBold(12)).tracking(2.6).foregroundColor(accent)
    }
}

struct Rule: View {
    var color: Color = Age.inkPale
    var body: some View { Rectangle().fill(color.opacity(0.45)).frame(height: 1) }
}

struct CardBox<Content: View>: View {
    var tint: Color = Age.card
    @ViewBuilder var content: () -> Content
    var body: some View {
        content().padding(16).frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 4).fill(tint)
                .overlay(RoundedRectangle(cornerRadius: 4)
                    .stroke(Age.inkPale.opacity(0.42), lineWidth: 1)))
    }
}

struct PillButton: View {
    let title: String
    var tone: Color = Age.oxblood
    var filled: Bool = true
    var enabled: Bool = true
    let action: () -> Void
    var body: some View {
        Button(action: { if enabled { action() } }) {
            Text(title).font(Age.serifBold(15)).tracking(1.2)
                .foregroundColor(filled ? Age.card : tone)
                .padding(.vertical, 12).padding(.horizontal, 22)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 3)
                    .fill(filled ? tone : Color.clear)
                    .overlay(RoundedRectangle(cornerRadius: 3)
                        .stroke(tone.opacity(0.72), lineWidth: 1.2)))
                .opacity(enabled ? 1 : 0.42)
        }
        .buttonStyle(GlyphButtonStyle())
    }
}

struct SmallTag: View {
    let text: String
    var tone: Color = Age.sepia
    var body: some View {
        Text(text.uppercased()).font(Age.serifBold(10)).tracking(1.6).foregroundColor(tone)
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(RoundedRectangle(cornerRadius: 2).stroke(tone.opacity(0.55), lineWidth: 1))
    }
}

struct MeterBar: View {
    let value: Double
    var tone: Color = Age.oxblood
    var track: Color = Age.inkPale
    var height: CGFloat = 6
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(track.opacity(0.25))
                Capsule().fill(tone).frame(width: max(0, min(1, value)) * geo.size.width)
            }
        }
        .frame(height: height)
    }
}

struct StarRow: View {
    let count: Int
    var total: Int = 3
    var size: CGFloat = 15
    var tone: Color = Age.brass
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<total, id: \.self) { i in
                StarGlyph().fill(i < count ? tone : Color.clear)
                    .overlay(StarGlyph().stroke(tone.opacity(i < count ? 0 : 0.45), lineWidth: 1))
                    .frame(width: size, height: size)
            }
        }
    }
}

struct AgeNavBar: View {
    let title: String
    var subtitle: String = ""
    var onBack: (() -> Void)?
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            if let back = onBack {
                Button(action: back) {
                    HStack(spacing: 6) {
                        ChevronGlyph(pointsLeft: true)
                            .stroke(Age.ink, style: StrokeStyle(lineWidth: 2, lineCap: .round,
                                                                lineJoin: .round))
                            .frame(width: 15, height: 20)
                        Text("Back").font(Age.serif(15)).foregroundColor(Age.ink)
                    }
                    .padding(.vertical, 6).padding(.trailing, 8)
                }
                .buttonStyle(GlyphButtonStyle())
            }
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(Age.serifBold(18)).foregroundColor(Age.ink)
                    .lineLimit(1).minimumScaleFactor(0.7)
                if !subtitle.isEmpty {
                    Text(subtitle).font(Age.serifItalic(12)).foregroundColor(Age.inkPale)
                        .lineLimit(1).minimumScaleFactor(0.8)
                }
            }
            Spacer(minLength: 4)
        }
        .padding(.horizontal, 16).padding(.vertical, 10)
    }
}

struct SheetHeader: View {
    let title: String
    var subtitle: String = ""
    let onClose: () -> Void
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(Age.serifBold(20)).foregroundColor(Age.ink)
                if !subtitle.isEmpty {
                    Text(subtitle).font(Age.serifItalic(13)).foregroundColor(Age.inkPale)
                }
            }
            Spacer()
            Button(action: onClose) {
                CrossGlyph().stroke(Age.inkSoft, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .frame(width: 18, height: 18).padding(8)
                    .background(Circle().stroke(Age.inkPale.opacity(0.45), lineWidth: 1))
            }
            .buttonStyle(GlyphButtonStyle())
        }
        .padding(.horizontal, 18).padding(.top, 16).padding(.bottom, 10)
    }
}

struct PlateCard: View {
    let plate: String
    var height: CGFloat = 200
    var body: some View {
        PlateView(name: plate, maxDim: 900, mode: .fill)
            .frame(height: height).clipped()
            .overlay(Rectangle().stroke(Age.inkPale.opacity(0.4), lineWidth: 1))
    }
}

struct EmptyNote: View {
    let title: String
    let body1: String
    var body: some View {
        VStack(spacing: 10) {
            ChairGlyph().stroke(Age.inkPale.opacity(0.6), lineWidth: 1.5)
                .frame(width: 50, height: 44)
            Text(title).font(Age.serifBold(17)).foregroundColor(Age.inkSoft)
            Text(body1).font(Age.serif(14)).foregroundColor(Age.inkPale)
                .multilineTextAlignment(.center).fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 30).padding(.vertical, 34).frame(maxWidth: .infinity)
    }
}

struct BadgeToast: View {
    let badge: Badge
    var body: some View {
        HStack(spacing: 12) {
            StarGlyph().fill(Age.brass).frame(width: 22, height: 22)
            VStack(alignment: .leading, spacing: 2) {
                Text(badge.name).font(Age.serifBold(15)).foregroundColor(Age.linen)
                Text(badge.note).font(Age.serif(12)).foregroundColor(Age.linen.opacity(0.8))
                    .lineLimit(2)
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 4).fill(Age.night))
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Age.brass.opacity(0.6), lineWidth: 1))
        .padding(.horizontal, 18)
    }
}

func hapticTick() { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
func hapticSolid() { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
