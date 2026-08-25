import Foundation
import CoreGraphics

func makeIcon(dir: String) {
    let p = Plate(1024, 1024)
    p.fillAll(Tone(r: 0.118, g: 0.098, b: 0.078))
    p.topDown()
    var rng = Dice(441907)

    if let g = CGGradient(colorsSpace: rgbSpace,
                          colors: [cg(Tone(r: 0.259, g: 0.196, b: 0.129)),
                                   cg(Tone(r: 0.086, g: 0.071, b: 0.059))] as CFArray,
                          locations: [0, 1]) {
        p.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 390, y: 330), startRadius: 0,
                                 endCenter: CGPoint(x: 390, y: 330), endRadius: 1160,
                                 options: [.drawsAfterEndLocation])
    }
    for _ in 0..<3600 {
        p.disc(rng.d() * 1024, rng.d() * 1024, rng.r(0.5, 2.2),
               (rng.chance(0.5) ? Tone(r: 0.95, g: 0.86, b: 0.68) : Tone(r: 0, g: 0, b: 0))
                   .al(rng.r(0.012, 0.062)))
    }

    let cx = 512.0, cy = 524.0
    let r = 260.0
    p.ellipse(cx + 14, cy + 42, r * 0.98, r * 0.38, Tone(r: 0, g: 0, b: 0).al(0.28))

    let ring = ringPoints(cx: cx, cy: cy, rx: r, ry: r * 0.92, steps: 72)
    p.poly(ring, Tone(r: 0.769, g: 0.588, b: 0.278))
    p.clip(pathOf(ring)) {
        if let g = CGGradient(colorsSpace: rgbSpace,
                              colors: [cg(Tone(r: 0.949, g: 0.816, b: 0.518)),
                                       cg(Tone(r: 0.749, g: 0.561, b: 0.251)),
                                       cg(Tone(r: 0.463, g: 0.318, b: 0.141))] as CFArray,
                              locations: [0, 0.46, 1]) {
            p.ctx.drawLinearGradient(g, start: CGPoint(x: cx - r * 0.7, y: cy - r * 0.8),
                                     end: CGPoint(x: cx + r * 0.8, y: cy + r * 0.8),
                                     options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        }
        for _ in 0..<2400 {
            let a = rng.r(0, 6.283), rr = rng.d().squareRoot() * r
            p.disc(cx + cos(a) * rr, cy + sin(a) * rr * 0.92, rng.r(0.6, 2.6),
                   (rng.chance(0.5) ? Tone(r: 1, g: 0.95, b: 0.80) : Tone(r: 0.26, g: 0.18, b: 0.09))
                       .al(rng.r(0.02, 0.12)))
        }
        if let g = CGGradient(colorsSpace: rgbSpace,
                              colors: [cg(Tone(r: 1, g: 0.96, b: 0.86).al(0.50)),
                                       cg(Tone(r: 1, g: 0.96, b: 0.86).al(0))] as CFArray,
                              locations: [0, 1]) {
            p.ctx.drawRadialGradient(g, startCenter: CGPoint(x: cx - r * 0.32, y: cy - r * 0.40),
                                     startRadius: 0,
                                     endCenter: CGPoint(x: cx - r * 0.32, y: cy - r * 0.40),
                                     endRadius: r * 0.86, options: [])
        }
    }
    for k in 0..<3 {
        let rr = r - 24 - Double(k) * 22
        p.ctx.setStrokeColor(cg(Tone(r: 1, g: 0.94, b: 0.79).al(k == 0 ? 0.42 : 0.15)))
        p.ctx.setLineWidth(k == 0 ? 5 : 2.4)
        p.ctx.strokeEllipse(in: CGRect(x: cx - rr, y: cy - rr * 0.92, width: rr * 2, height: rr * 1.84))
    }
    p.ctx.setStrokeColor(cg(Tone(r: 0.239, g: 0.157, b: 0.071).al(0.55)))
    p.ctx.setLineWidth(6)
    p.ctx.strokeEllipse(in: CGRect(x: cx - r, y: cy - r * 0.92, width: r * 2, height: r * 1.84))

    func spark(_ sx: Double, _ sy: Double, _ s: Double, _ a: Double) {
        for k in 0..<4 {
            let ang = Double(k) * 1.5708
            p.poly([pt(sx, sy), pt(sx + cos(ang + 0.30) * s * 0.30, sy + sin(ang + 0.30) * s * 0.30),
                    pt(sx + cos(ang) * s, sy + sin(ang) * s),
                    pt(sx + cos(ang - 0.30) * s * 0.30, sy + sin(ang - 0.30) * s * 0.30)],
                   Tone(r: 1, g: 0.96, b: 0.86).al(a))
        }
    }
    spark(782, 290, 52, 0.66)
    spark(250, 760, 36, 0.42)
    p.disc(850, 386, 9, Tone(r: 1, g: 0.96, b: 0.86).al(0.40))

    if let g = CGGradient(colorsSpace: rgbSpace,
                          colors: [cg(Tone(r: 0, g: 0, b: 0).al(0)),
                                   cg(Tone(r: 0, g: 0, b: 0).al(0.38))] as CFArray,
                          locations: [0.58, 1]) {
        p.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 512, y: 512), startRadius: 0,
                                 endCenter: CGPoint(x: 512, y: 512), endRadius: 800,
                                 options: [.drawsAfterEndLocation])
    }
    p.writePNG(dir, "AppIcon-1024")
}
