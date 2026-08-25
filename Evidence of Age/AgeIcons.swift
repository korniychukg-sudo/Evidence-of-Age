import SwiftUI

struct RoomGlyph: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width, h = r.height
        p.move(to: CGPoint(x: r.minX + w * 0.12, y: r.minY + h * 0.86))
        p.addCurve(to: CGPoint(x: r.minX + w * 0.46, y: r.minY + h * 0.16),
                   control1: CGPoint(x: r.minX + w * 0.34, y: r.minY + h * 0.66),
                   control2: CGPoint(x: r.minX + w * 0.28, y: r.minY + h * 0.36))
        p.move(to: CGPoint(x: r.minX + w * 0.56, y: r.minY + h * 0.86))
        p.addCurve(to: CGPoint(x: r.minX + w * 0.58, y: r.minY + h * 0.16),
                   control1: CGPoint(x: r.minX + w * 0.76, y: r.minY + h * 0.62),
                   control2: CGPoint(x: r.minX + w * 0.42, y: r.minY + h * 0.38))
        p.move(to: CGPoint(x: r.minX + w * 0.18, y: r.minY + h * 0.50))
        p.addLine(to: CGPoint(x: r.minX + w * 0.34, y: r.minY + h * 0.50))
        p.move(to: CGPoint(x: r.minX + w * 0.68, y: r.minY + h * 0.62))
        p.addLine(to: CGPoint(x: r.minX + w * 0.84, y: r.minY + h * 0.62))
        return p
    }
}

struct LampGlyph: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width, h = r.height
        p.move(to: CGPoint(x: r.minX + w * 0.14, y: r.minY + h * 0.88))
        p.addQuadCurve(to: CGPoint(x: r.minX + w * 0.88, y: r.minY + h * 0.14),
                       control: CGPoint(x: r.minX + w * 0.34, y: r.minY + h * 0.30))
        p.move(to: CGPoint(x: r.minX + w * 0.14, y: r.minY + h * 0.88))
        p.addLine(to: CGPoint(x: r.minX + w * 0.30, y: r.minY + h * 0.72))
        p.addEllipse(in: CGRect(x: r.minX + w * 0.20, y: r.minY + h * 0.60,
                                width: w * 0.20, height: h * 0.20))
        p.move(to: CGPoint(x: r.minX + w * 0.88, y: r.minY + h * 0.14))
        p.addQuadCurve(to: CGPoint(x: r.minX + w * 0.52, y: r.minY + h * 0.72),
                       control: CGPoint(x: r.minX + w * 0.86, y: r.minY + h * 0.54))
        return p
    }
}

struct BenchGlyph: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width, h = r.height
        p.addRect(CGRect(x: r.minX + w * 0.42, y: r.minY + h * 0.40,
                         width: w * 0.16, height: h * 0.42))
        p.addEllipse(in: CGRect(x: r.minX + w * 0.28, y: r.minY + h * 0.80,
                                width: w * 0.44, height: h * 0.14))
        p.move(to: CGPoint(x: r.minX + w * 0.44, y: r.minY + h * 0.42))
        p.addLine(to: CGPoint(x: r.minX + w * 0.80, y: r.minY + h * 0.22))
        p.move(to: CGPoint(x: r.minX + w * 0.50, y: r.minY + h * 0.48))
        p.addLine(to: CGPoint(x: r.minX + w * 0.84, y: r.minY + h * 0.30))
        p.addArc(center: CGPoint(x: r.minX + w * 0.34, y: r.minY + h * 0.24),
                 radius: w * 0.16, startAngle: .degrees(20), endAngle: .degrees(300),
                 clockwise: false)
        return p
    }
}

struct BookGlyph: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width, h = r.height
        p.move(to: CGPoint(x: r.midX, y: r.minY + h * 0.26))
        p.addCurve(to: CGPoint(x: r.minX + w * 0.10, y: r.minY + h * 0.20),
                   control1: CGPoint(x: r.minX + w * 0.34, y: r.minY + h * 0.16),
                   control2: CGPoint(x: r.minX + w * 0.20, y: r.minY + h * 0.16))
        p.addLine(to: CGPoint(x: r.minX + w * 0.10, y: r.minY + h * 0.80))
        p.addCurve(to: CGPoint(x: r.midX, y: r.minY + h * 0.86),
                   control1: CGPoint(x: r.minX + w * 0.20, y: r.minY + h * 0.76),
                   control2: CGPoint(x: r.minX + w * 0.34, y: r.minY + h * 0.76))
        p.addCurve(to: CGPoint(x: r.minX + w * 0.90, y: r.minY + h * 0.80),
                   control1: CGPoint(x: r.minX + w * 0.66, y: r.minY + h * 0.76),
                   control2: CGPoint(x: r.minX + w * 0.80, y: r.minY + h * 0.76))
        p.addLine(to: CGPoint(x: r.minX + w * 0.90, y: r.minY + h * 0.20))
        p.addCurve(to: CGPoint(x: r.midX, y: r.minY + h * 0.26),
                   control1: CGPoint(x: r.minX + w * 0.80, y: r.minY + h * 0.16),
                   control2: CGPoint(x: r.minX + w * 0.66, y: r.minY + h * 0.16))
        p.move(to: CGPoint(x: r.midX, y: r.minY + h * 0.26))
        p.addLine(to: CGPoint(x: r.midX, y: r.minY + h * 0.86))
        return p
    }
}

struct LedgerGlyph: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width, h = r.height
        p.move(to: CGPoint(x: r.minX + w * 0.16, y: r.minY + h * 0.40))
        p.addLine(to: CGPoint(x: r.minX + w * 0.84, y: r.minY + h * 0.40))
        p.addLine(to: CGPoint(x: r.minX + w * 0.76, y: r.minY + h * 0.86))
        p.addLine(to: CGPoint(x: r.minX + w * 0.24, y: r.minY + h * 0.86))
        p.closeSubpath()
        p.move(to: CGPoint(x: r.minX + w * 0.20, y: r.minY + h * 0.58))
        p.addLine(to: CGPoint(x: r.minX + w * 0.80, y: r.minY + h * 0.58))
        p.move(to: CGPoint(x: r.minX + w * 0.28, y: r.minY + h * 0.40))
        p.addArc(center: CGPoint(x: r.midX, y: r.minY + h * 0.40), radius: w * 0.22,
                 startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
        p.move(to: CGPoint(x: r.minX + w * 0.14, y: r.minY + h * 0.30))
        p.addLine(to: CGPoint(x: r.minX + w * 0.86, y: r.minY + h * 0.14))
        return p
    }
}

struct ChairGlyph: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width, h = r.height
        p.move(to: CGPoint(x: r.minX + w * 0.12, y: r.midY))
        p.addQuadCurve(to: CGPoint(x: r.minX + w * 0.70, y: r.minY + h * 0.28),
                       control: CGPoint(x: r.minX + w * 0.36, y: r.minY + h * 0.22))
        p.addQuadCurve(to: CGPoint(x: r.minX + w * 0.70, y: r.minY + h * 0.72),
                       control: CGPoint(x: r.minX + w * 0.92, y: r.midY))
        p.addQuadCurve(to: CGPoint(x: r.minX + w * 0.12, y: r.midY),
                       control: CGPoint(x: r.minX + w * 0.36, y: r.minY + h * 0.78))
        p.move(to: CGPoint(x: r.minX + w * 0.70, y: r.minY + h * 0.28))
        p.addLine(to: CGPoint(x: r.minX + w * 0.94, y: r.minY + h * 0.14))
        p.addLine(to: CGPoint(x: r.minX + w * 0.94, y: r.minY + h * 0.86))
        p.addLine(to: CGPoint(x: r.minX + w * 0.70, y: r.minY + h * 0.72))
        p.addEllipse(in: CGRect(x: r.minX + w * 0.22, y: r.midY - h * 0.06,
                                width: w * 0.08, height: h * 0.08))
        return p
    }
}

struct RuleGlyph: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width, h = r.height
        p.move(to: CGPoint(x: r.minX + w * 0.20, y: r.minY + h * 0.18))
        p.addLine(to: CGPoint(x: r.minX + w * 0.66, y: r.minY + h * 0.18))
        p.addArc(center: CGPoint(x: r.minX + w * 0.52, y: r.minY + h * 0.58),
                 radius: w * 0.26, startAngle: .degrees(-70), endAngle: .degrees(190),
                 clockwise: false)
        p.addEllipse(in: CGRect(x: r.minX + w * 0.12, y: r.minY + h * 0.12,
                                width: w * 0.12, height: h * 0.12))
        return p
    }
}

struct LoupeGlyph: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width, h = r.height
        p.move(to: CGPoint(x: r.midX, y: r.minY + h * 0.12))
        p.addCurve(to: CGPoint(x: r.minX + w * 0.78, y: r.minY + h * 0.66),
                   control1: CGPoint(x: r.minX + w * 0.62, y: r.minY + h * 0.32),
                   control2: CGPoint(x: r.minX + w * 0.78, y: r.minY + h * 0.48))
        p.addArc(center: CGPoint(x: r.midX, y: r.minY + h * 0.66), radius: w * 0.28,
                 startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
        p.addCurve(to: CGPoint(x: r.midX, y: r.minY + h * 0.12),
                   control1: CGPoint(x: r.minX + w * 0.22, y: r.minY + h * 0.48),
                   control2: CGPoint(x: r.minX + w * 0.38, y: r.minY + h * 0.32))
        return p
    }
}

struct StarGlyph: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: r.midX, y: r.midY)
        let outer = min(r.width, r.height) * 0.48
        let inner = outer * 0.42
        for i in 0..<10 {
            let a = CGFloat(i) * .pi / 5 - .pi / 2
            let rad = i % 2 == 0 ? outer : inner
            let q = CGPoint(x: c.x + cos(a) * rad, y: c.y + sin(a) * rad)
            if i == 0 { p.move(to: q) } else { p.addLine(to: q) }
        }
        p.closeSubpath()
        return p
    }
}

struct CheckGlyph: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: r.minX + r.width * 0.20, y: r.midY))
        p.addLine(to: CGPoint(x: r.minX + r.width * 0.42, y: r.minY + r.height * 0.74))
        p.addLine(to: CGPoint(x: r.minX + r.width * 0.82, y: r.minY + r.height * 0.26))
        return p
    }
}

struct CrossGlyph: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: r.minX + r.width * 0.24, y: r.minY + r.height * 0.24))
        p.addLine(to: CGPoint(x: r.minX + r.width * 0.76, y: r.minY + r.height * 0.76))
        p.move(to: CGPoint(x: r.minX + r.width * 0.76, y: r.minY + r.height * 0.24))
        p.addLine(to: CGPoint(x: r.minX + r.width * 0.24, y: r.minY + r.height * 0.76))
        return p
    }
}

struct ChevronGlyph: Shape {
    var pointsLeft = false
    func path(in r: CGRect) -> Path {
        var p = Path()
        let x0 = pointsLeft ? r.maxX - r.width * 0.28 : r.minX + r.width * 0.28
        let x1 = pointsLeft ? r.minX + r.width * 0.34 : r.maxX - r.width * 0.34
        p.move(to: CGPoint(x: x0, y: r.minY + r.height * 0.20))
        p.addLine(to: CGPoint(x: x1, y: r.midY))
        p.addLine(to: CGPoint(x: x0, y: r.maxY - r.height * 0.20))
        return p
    }
}

struct LockGlyph: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width, h = r.height
        p.addRoundedRect(in: CGRect(x: r.minX + w * 0.20, y: r.minY + h * 0.46,
                                    width: w * 0.60, height: h * 0.40),
                         cornerSize: CGSize(width: w * 0.08, height: w * 0.08))
        p.move(to: CGPoint(x: r.minX + w * 0.32, y: r.minY + h * 0.46))
        p.addLine(to: CGPoint(x: r.minX + w * 0.32, y: r.minY + h * 0.30))
        p.addArc(center: CGPoint(x: r.midX, y: r.minY + h * 0.30), radius: w * 0.18,
                 startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
        p.addLine(to: CGPoint(x: r.minX + w * 0.68, y: r.minY + h * 0.46))
        return p
    }
}

struct GlyphButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.62 : 1)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
