import Foundation
import CoreGraphics

func woodFill(_ p: Plate, _ pts: [CGPoint], tone: Tone, seed: UInt64, vertical: Bool = false) {
    guard pts.count > 2 else { return }
    let path = pathOf(pts)
    let box = path.boundingBox
    var rng = Dice(seed)
    p.poly(pts, tone)
    p.clip(path) {
        for _ in 0..<Int(Double(box.width * box.height) / 520) {
            let x = Double(box.minX) + rng.d() * Double(box.width)
            let y = Double(box.minY) + rng.d() * Double(box.height)
            let len = rng.r(20, 160)
            let a = vertical ? [pt(x, y), pt(x + rng.r(-3, 3), y + len)]
                             : [pt(x, y), pt(x + len, y + rng.r(-3, 3))]
            pen(p, a, weight: rng.r(0.6, 2.2),
                colour: (rng.chance(0.5) ? tone.dk(rng.r(0.10, 0.34)) : tone.lt(rng.r(0.06, 0.26)))
                    .al(rng.r(0.16, 0.48)),
                wobble: 0.8, taper: true, seed: seed &+ bits(Int(x + y)))
        }
        for _ in 0..<Int(Double(box.width * box.height) / 26000) {
            let x = Double(box.minX) + rng.d() * Double(box.width)
            let y = Double(box.minY) + rng.d() * Double(box.height)
            let r = rng.r(5, 16)
            for k in 0..<4 {
                p.ring(x, y, r + Double(k) * 3.4, 1.6, tone.dk(0.36).al(rng.r(0.20, 0.52)))
            }
        }
        if let g = CGGradient(colorsSpace: rgbSpace,
                              colors: [cg(tone.lt(0.16).al(0.5)), cg(tone.dk(0.26).al(0.42))] as CFArray,
                              locations: [0, 1]) {
            p.ctx.drawLinearGradient(g, start: CGPoint(x: box.minX, y: box.minY),
                                     end: CGPoint(x: box.maxX, y: box.maxY),
                                     options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        }
    }
    penContour(p, pts, weight: 2.0, colour: Field.ink.al(0.68), seed: seed &+ 7)
}

func rectPts(_ x: Double, _ y: Double, _ w: Double, _ h: Double) -> [CGPoint] {
    [pt(x, y), pt(x + w, y), pt(x + w, y + h), pt(x, y + h)]
}

func drawLeg(_ p: Plate, kind: Leg, x: Double, top: Double, bottom: Double,
             width: Double, tone: Tone, seed: UInt64) {
    let h = bottom - top
    switch kind {
    case .turned:
        var rng = Dice(seed)
        var y = top
        var k = 0
        while y < bottom {
            let seg = h / 9
            let bulge = k % 2 == 0 ? width * rng.r(0.60, 0.78) : width * rng.r(0.34, 0.46)
            woodFill(p, ringPoints(cx: x, cy: y + seg / 2, rx: bulge, ry: seg / 2 + 2, steps: 22),
                     tone: tone, seed: seed &+ bits(k), vertical: true)
            y += seg
            k += 1
        }
    case .cabriole:
        var spine: [CGPoint] = []
        for i in 0...24 {
            let t = Double(i) / 24
            let dx = sin(t * 3.14159) * width * 0.9 - t * width * 0.5
            spine.append(pt(x + dx, top + t * h))
        }
        var left: [CGPoint] = [], right: [CGPoint] = []
        for (i, q) in spine.enumerated() {
            let t = Double(i) / Double(spine.count - 1)
            let w = width * (0.78 - t * 0.42) + width * 0.30 * (t > 0.90 ? 1.6 : 0)
            left.append(pt(Double(q.x) - w, Double(q.y)))
            right.append(pt(Double(q.x) + w, Double(q.y)))
        }
        woodFill(p, left + right.reversed(), tone: tone, seed: seed, vertical: true)
        woodFill(p, ringPoints(cx: Double(spine[spine.count - 1].x), cy: bottom - width * 0.4,
                               rx: width * 0.86, ry: width * 0.62, steps: 20),
                 tone: tone.dk(0.06), seed: seed &+ 3)
    case .square:
        woodFill(p, [pt(x - width * 0.62, top), pt(x + width * 0.62, top),
                     pt(x + width * 0.34, bottom), pt(x - width * 0.34, bottom)],
                 tone: tone, seed: seed, vertical: true)
    case .bracket:
        var curve: [CGPoint] = [pt(x - width * 1.5, bottom)]
        for i in 0...16 {
            let t = Double(i) / 16
            curve.append(pt(x - width * 1.5 + t * width * 1.5,
                            bottom - sin(t * 1.5708) * h))
        }
        curve.append(pt(x + width * 1.5, bottom - h))
        curve.append(pt(x + width * 1.5, bottom))
        woodFill(p, curve, tone: tone, seed: seed)
    case .bun:
        woodFill(p, ringPoints(cx: x, cy: bottom - h * 0.5, rx: width * 1.1, ry: h * 0.5, steps: 26),
                 tone: tone, seed: seed)
    case .ball:
        woodFill(p, ringPoints(cx: x, cy: bottom - h * 0.5, rx: width * 0.9, ry: h * 0.5, steps: 26),
                 tone: tone, seed: seed)
    case .sabre:
        var spine: [CGPoint] = []
        for i in 0...20 {
            let t = Double(i) / 20
            spine.append(pt(x + t * t * width * 2.4, top + t * h))
        }
        var left: [CGPoint] = [], right: [CGPoint] = []
        for (i, q) in spine.enumerated() {
            let t = Double(i) / Double(spine.count - 1)
            let w = width * (0.66 - t * 0.28)
            left.append(pt(Double(q.x) - w, Double(q.y)))
            right.append(pt(Double(q.x) + w, Double(q.y)))
        }
        woodFill(p, left + right.reversed(), tone: tone, seed: seed, vertical: true)
    case .none:
        break
    }
}

func drawHandle(_ p: Plate, _ style: String, x: Double, y: Double, s: Double, seed: UInt64) {
    if style.contains("knob") || style.contains("Turned wooden") {
        p.disc(x, y, s * 0.5, Field.walnut.dk(0.06))
        p.disc(x - s * 0.14, y - s * 0.14, s * 0.22, Field.walnut.lt(0.22))
        p.ring(x, y, s * 0.5, 1.4, Field.ink.al(0.5))
    } else if style.contains("drop") || style.contains("Brass drop") {
        p.disc(x, y - s * 0.30, s * 0.30, Field.brass)
        p.ring(x, y - s * 0.30, s * 0.30, 1.4, Field.brassDark)
        p.ellipse(x, y + s * 0.24, s * 0.26, s * 0.42, Field.brass)
        p.ring(x, y + s * 0.24, s * 0.26, 1.2, Field.brassDark)
    } else if style.contains("Iron") || style.contains("Wrought") {
        p.rect(x - s * 0.8, y - s * 0.18, s * 1.6, s * 0.36, Field.iron)
        p.rect(x - s * 0.8, y - s * 0.18, s * 1.6, s * 0.12, Field.steel.al(0.4))
    } else {
        p.ellipse(x, y - s * 0.10, s * 0.86, s * 0.34, Field.brass)
        p.ring(x, y - s * 0.10, s * 0.86, 1.6, Field.brassDark)
        var swan: [CGPoint] = []
        for i in 0...16 {
            let t = Double(i) / 16
            swan.append(pt(x - s * 0.66 + t * s * 1.32, y + s * 0.20 + sin(t * 3.14159) * s * 0.42))
        }
        pen(p, swan, weight: s * 0.16, colour: Field.brass, wobble: 0.5, taper: false, seed: seed)
        pen(p, swan, weight: s * 0.06, colour: Field.brass.lt(0.34).al(0.7),
            wobble: 0.3, taper: false, seed: seed &+ 3)
    }
}

func drawPiece(_ p: Plate, _ spec: PieceSpec, box: CGRect, seed: UInt64) {
    let bw = Double(box.width) * spec.width
    let bh = Double(box.height) * spec.height
    let cx = Double(box.midX)
    let bottom = Double(box.maxY)
    let top = bottom - bh
    let left = cx - bw / 2
    let right = cx + bw / 2
    let tone = spec.timber
    var rng = Dice(seed)

    if let g = CGGradient(colorsSpace: rgbSpace,
                          colors: [cg(Field.ink.al(0.28)), cg(Field.ink.al(0))] as CFArray,
                          locations: [0, 1]) {
        p.ctx.saveGState()
        p.ctx.translateBy(x: CGFloat(cx + bw * 0.06), y: CGFloat(bottom + 6))
        p.ctx.scaleBy(x: 1, y: 0.14)
        p.ctx.drawRadialGradient(g, startCenter: .zero, startRadius: 0,
                                 endCenter: .zero, endRadius: CGFloat(bw * 0.66), options: [])
        p.ctx.restoreGState()
    }

    switch spec.form {
    case .chair:
        let seatY = bottom - bh * 0.46
        let legTop = seatY + bh * 0.04
        for lx in [left + bw * 0.14, right - bw * 0.14] {
            drawLeg(p, kind: spec.leg, x: lx, top: legTop, bottom: bottom,
                    width: bw * 0.055, tone: tone, seed: seed &+ bits(Int(lx)))
        }
        if spec.leg == .turned || spec.leg == .square {
            woodFill(p, rectPts(left + bw * 0.14, bottom - bh * 0.12, bw * 0.72, bh * 0.03),
                     tone: tone.dk(0.05), seed: seed &+ 11)
        }
        woodFill(p, rectPts(left + bw * 0.06, seatY, bw * 0.88, bh * 0.07),
                 tone: tone, seed: seed &+ 13)
        let backTop = top
        woodFill(p, rectPts(left + bw * 0.10, backTop, bw * 0.06, seatY - backTop),
                 tone: tone, seed: seed &+ 15, vertical: true)
        woodFill(p, rectPts(right - bw * 0.16, backTop, bw * 0.06, seatY - backTop),
                 tone: tone, seed: seed &+ 17, vertical: true)
        woodFill(p, rectPts(left + bw * 0.10, backTop, bw * 0.74, bh * 0.06),
                 tone: tone.dk(0.04), seed: seed &+ 19)
        if spec.panels > 0 {
            let sw = bw * 0.24
            var splat: [CGPoint] = []
            for i in 0...24 {
                let t = Double(i) / 24
                splat.append(pt(cx - sw * (0.45 + 0.55 * sin(t * 3.14159)),
                                backTop + bh * 0.06 + t * (seatY - backTop - bh * 0.06)))
            }
            for i in stride(from: 24, through: 0, by: -1) {
                let t = Double(i) / 24
                splat.append(pt(cx + sw * (0.45 + 0.55 * sin(t * 3.14159)),
                                backTop + bh * 0.06 + t * (seatY - backTop - bh * 0.06)))
            }
            woodFill(p, splat, tone: tone.lt(0.04), seed: seed &+ 21, vertical: true)
            if spec.panels > 2 {
                for k in 0..<3 {
                    let hy = backTop + bh * 0.10 + Double(k) * (seatY - backTop) * 0.26
                    p.ellipse(cx, hy, sw * 0.30, bh * 0.030, tone.dk(0.22).al(0.6))
                }
            }
        }
    case .chest, .bureau:
        let sloped = spec.form == .bureau
        let footH = bh * 0.10
        let caseTop = sloped ? top + bh * 0.30 : top
        woodFill(p, rectPts(left, caseTop, bw, bottom - footH - caseTop),
                 tone: tone, seed: seed &+ 23)
        if sloped {
            woodFill(p, [pt(left, caseTop), pt(right, caseTop),
                         pt(right, top + bh * 0.10), pt(left + bw * 0.02, top)],
                     tone: tone.lt(0.03), seed: seed &+ 25)
        }
        let n = max(1, spec.drawers)
        var y = caseTop + bh * 0.03
        let usable = (bottom - footH - caseTop) - bh * 0.06
        var weights: [Double] = []
        for i in 0..<n { weights.append(1.0 + Double(i) * 0.18) }
        let wsum = weights.reduce(0, +)
        for i in 0..<n {
            let dh = usable * weights[i] / wsum
            woodFill(p, rectPts(left + bw * 0.04, y, bw * 0.92, dh - bh * 0.012),
                     tone: tone.lt(0.05), seed: seed &+ bits(i * 7 + 31))
            for hx in [left + bw * 0.28, right - bw * 0.28] {
                drawHandle(p, spec.hardware, x: hx, y: y + dh / 2, s: bw * 0.055,
                           seed: seed &+ bits(i * 13))
            }
            y += dh
        }
        for k in 0..<spec.moulding {
            p.rect(left - bw * 0.012, caseTop - Double(k) * bh * 0.014 - bh * 0.014,
                   bw + bw * 0.024, bh * 0.013, tone.dk(0.10 + Double(k) * 0.05))
        }
        for lx in [left + bw * 0.06, right - bw * 0.06] {
            drawLeg(p, kind: spec.leg, x: lx, top: bottom - footH, bottom: bottom,
                    width: bw * 0.05, tone: tone.dk(0.04), seed: seed &+ bits(Int(lx)))
        }
    case .table:
        let topH = bh * 0.05
        woodFill(p, rectPts(left, top, bw, topH), tone: tone, seed: seed &+ 41)
        woodFill(p, rectPts(left + bw * 0.06, top + topH, bw * 0.88, bh * 0.11),
                 tone: tone.dk(0.05), seed: seed &+ 43)
        if spec.drawers > 0 {
            woodFill(p, rectPts(left + bw * 0.30, top + topH + bh * 0.02, bw * 0.40, bh * 0.07),
                     tone: tone.lt(0.05), seed: seed &+ 45)
            drawHandle(p, spec.hardware, x: cx, y: top + topH + bh * 0.055, s: bw * 0.05,
                       seed: seed &+ 47)
        }
        for lx in [left + bw * 0.10, right - bw * 0.10] {
            drawLeg(p, kind: spec.leg, x: lx, top: top + topH + bh * 0.11, bottom: bottom,
                    width: bw * 0.045, tone: tone, seed: seed &+ bits(Int(lx)))
        }
        if spec.leg == .turned {
            woodFill(p, rectPts(left + bw * 0.10, bottom - bh * 0.13, bw * 0.80, bh * 0.025),
                     tone: tone.dk(0.06), seed: seed &+ 49)
        }
    case .clock:
        let hoodH = bh * 0.26
        let plinthH = bh * 0.16
        woodFill(p, rectPts(left, top, bw, hoodH), tone: tone, seed: seed &+ 51)
        woodFill(p, rectPts(left + bw * 0.10, top + hoodH, bw * 0.80,
                            bh - hoodH - plinthH), tone: tone.dk(0.02), seed: seed &+ 53)
        woodFill(p, rectPts(left - bw * 0.02, bottom - plinthH, bw * 1.04, plinthH),
                 tone: tone.dk(0.06), seed: seed &+ 55)
        p.rect(left + bw * 0.10, top + hoodH * 0.16, bw * 0.80, hoodH * 0.72, Field.brass)
        p.ring(cx, top + hoodH * 0.52, bw * 0.30, 4, Field.brassDark)
        p.disc(cx, top + hoodH * 0.52, bw * 0.26, Field.brass.lt(0.20))
        for k in 0..<12 {
            let a = Double(k) / 12 * 6.283
            pen(p, [pt(cx + cos(a) * bw * 0.20, top + hoodH * 0.52 + sin(a) * bw * 0.20),
                    pt(cx + cos(a) * bw * 0.25, top + hoodH * 0.52 + sin(a) * bw * 0.25)],
                weight: 2.2, colour: Field.ink.al(0.7), wobble: 0, taper: false,
                seed: seed &+ bits(k))
        }
        pen(p, [pt(cx, top + hoodH * 0.52), pt(cx + bw * 0.10, top + hoodH * 0.40)],
            weight: 3.4, colour: Field.ink, wobble: 0, taper: true, seed: seed &+ 57)
        pen(p, [pt(cx, top + hoodH * 0.52), pt(cx - bw * 0.06, top + hoodH * 0.66)],
            weight: 2.6, colour: Field.ink, wobble: 0, taper: true, seed: seed &+ 59)
        woodFill(p, rectPts(left + bw * 0.18, top + hoodH + bh * 0.06, bw * 0.64,
                            bh * 0.40), tone: tone.lt(0.04), seed: seed &+ 61)
        p.ellipse(cx, top + hoodH + bh * 0.40, bw * 0.14, bw * 0.14, Field.brass)
    case .mirror:
        let boxH = bh * 0.32
        woodFill(p, rectPts(left, bottom - boxH, bw, boxH - bh * 0.05),
                 tone: tone, seed: seed &+ 63)
        var y = bottom - boxH + bh * 0.02
        for i in 0..<max(1, spec.drawers) {
            let dh = (boxH - bh * 0.09) / Double(max(1, spec.drawers))
            woodFill(p, rectPts(left + bw * 0.04, y, bw * 0.92, dh - bh * 0.008),
                     tone: tone.lt(0.05), seed: seed &+ bits(i + 65))
            drawHandle(p, spec.hardware, x: cx, y: y + dh / 2, s: bw * 0.05, seed: seed &+ bits(i))
            y += dh
        }
        for lx in [left + bw * 0.08, right - bw * 0.08] {
            drawLeg(p, kind: spec.leg, x: lx, top: bottom - bh * 0.05, bottom: bottom,
                    width: bw * 0.05, tone: tone.dk(0.06), seed: seed &+ bits(Int(lx)))
        }
        let frameH = bh - boxH - bh * 0.02
        for lx in [left + bw * 0.10, right - bw * 0.10] {
            woodFill(p, rectPts(lx - bw * 0.02, top + frameH * 0.06, bw * 0.04, frameH * 0.94),
                     tone: tone.dk(0.04), seed: seed &+ bits(Int(lx * 3)), vertical: true)
        }
        woodFill(p, rectPts(left + bw * 0.14, top, bw * 0.72, frameH * 0.94),
                 tone: tone.lt(0.02), seed: seed &+ 67)
        let glass = rectPts(left + bw * 0.19, top + bh * 0.02, bw * 0.62, frameH * 0.86)
        p.poly(glass, Field.steel.lt(0.28))
        p.clip(pathOf(glass)) {
            if let g = CGGradient(colorsSpace: rgbSpace,
                                  colors: [cg(Field.bone.al(0.6)), cg(Field.slate.al(0.5))] as CFArray,
                                  locations: [0, 1]) {
                p.ctx.drawLinearGradient(g, start: CGPoint(x: left, y: top),
                                         end: CGPoint(x: right, y: top + frameH),
                                         options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
            }
            for _ in 0..<200 {
                let x = left + rng.d() * bw, y2 = top + rng.d() * frameH
                p.disc(x, y2, rng.r(1, 5), Field.ink.al(rng.r(0.02, 0.10)))
            }
        }
        penContour(p, glass, weight: 2.0, colour: Field.ink.al(0.6), seed: seed &+ 69)
    case .stool, .coffer, .box:
        let lidH = spec.form == .box ? 0 : bh * 0.10
        let footH = bh * 0.16
        woodFill(p, rectPts(left, top + lidH, bw, bh - lidH - footH * 0.4),
                 tone: tone, seed: seed &+ 71)
        if lidH > 0 {
            woodFill(p, rectPts(left - bw * 0.015, top, bw * 1.03, lidH),
                     tone: tone.lt(0.04), seed: seed &+ 73)
        }
        if spec.form == .box {
            let n = max(1, spec.drawers)
            let rows = max(1, Int((Double(n) + 1) / 2))
            for r in 0..<rows {
                for c in 0..<2 {
                    let dw = bw * 0.42
                    let dh = (bh - footH) / Double(rows) - bh * 0.02
                    let dx = left + bw * 0.04 + Double(c) * (dw + bw * 0.08)
                    let dy = top + bh * 0.03 + Double(r) * (dh + bh * 0.02)
                    woodFill(p, rectPts(dx, dy, dw, dh), tone: tone.lt(0.06),
                             seed: seed &+ bits(r * 5 + c))
                    drawHandle(p, spec.hardware, x: dx + dw / 2, y: dy + dh / 2, s: bw * 0.04,
                               seed: seed &+ bits(r * 3 + c))
                }
            }
        } else {
            for k in 0..<max(1, spec.panels) {
                let pw = bw * 0.86 / Double(max(1, spec.panels))
                let px = left + bw * 0.07 + Double(k) * pw
                woodFill(p, rectPts(px + pw * 0.08, top + lidH + bh * 0.08,
                                    pw * 0.84, bh - lidH - footH - bh * 0.16),
                         tone: tone.dk(0.05), seed: seed &+ bits(k + 81))
            }
        }
        for lx in [left + bw * 0.08, right - bw * 0.08] {
            drawLeg(p, kind: spec.leg, x: lx, top: bottom - footH, bottom: bottom,
                    width: bw * 0.05, tone: tone.dk(0.05), seed: seed &+ bits(Int(lx)))
        }
    case .cabinet:
        let footH = bh * 0.10
        woodFill(p, rectPts(left, top, bw, bh - footH), tone: tone, seed: seed &+ 91)
        for k in 0..<max(1, spec.panels) {
            let pw = bw * 0.90 / Double(max(1, spec.panels))
            let px = left + bw * 0.05 + Double(k) * pw
            woodFill(p, rectPts(px + pw * 0.06, top + bh * 0.30, pw * 0.88, bh * 0.50),
                     tone: tone.dk(0.06), seed: seed &+ bits(k + 93))
            drawHandle(p, spec.hardware, x: px + pw * 0.5, y: top + bh * 0.55, s: bw * 0.04,
                       seed: seed &+ bits(k))
        }
        if spec.drawers > 0 {
            var y = top + bh * 0.04
            for i in 0..<spec.drawers {
                let dh = bh * 0.20 / Double(spec.drawers)
                woodFill(p, rectPts(left + bw * 0.05, y, bw * 0.90, dh - bh * 0.01),
                         tone: tone.lt(0.05), seed: seed &+ bits(i + 97))
                drawHandle(p, spec.hardware, x: cx, y: y + dh / 2, s: bw * 0.04,
                           seed: seed &+ bits(i))
                y += dh
            }
        }
        for k in 0..<spec.moulding {
            p.rect(left - bw * 0.015, top + Double(k) * bh * 0.012, bw + bw * 0.03,
                   bh * 0.011, tone.dk(0.12 + Double(k) * 0.04))
        }
        for lx in [left + bw * 0.06, right - bw * 0.06] {
            drawLeg(p, kind: spec.leg, x: lx, top: bottom - footH, bottom: bottom,
                    width: bw * 0.05, tone: tone.dk(0.05), seed: seed &+ bits(Int(lx)))
        }
    }
}

func makePiecePlate(_ spec: PieceSpec, dir: String) {
    let p = Plate(1350, 1620)
    let seed = hashOf("piece-" + spec.slug)
    layPaper(p, seed: seed, tone: Field.paper)
    p.topDown()
    p.light = -2.28

    drawPiece(p, spec, box: CGRect(x: 210, y: 170, width: 930, height: 700), seed: seed &+ 5)

    caption(p, spec.period.uppercased(), at: 118, 118, size: 21, colour: Field.oxblood,
            face: "Georgia-Bold", align: .left, tracking: 3.6)
    caption(p, spec.region.uppercased(), at: 1232, 118, size: 19, colour: Field.sepia,
            face: "Georgia-Bold", align: .right, tracking: 2.6)

    caption(p, spec.name, at: 118, 962, size: 54, colour: Field.ink,
            face: "Georgia-Bold", align: .left)
    caption(p, spec.line, at: 118, 1006, size: 26, colour: Field.inkPale,
            face: "Georgia-Italic", align: .left)
    pen(p, [pt(118, 1036), pt(1232, 1036)], weight: 1.6, colour: Field.inkPale.al(0.6),
        wobble: 0.5, taper: false, seed: seed &+ 61)
    caption(p, spec.timberName.uppercased() + "   ·   ABOUT " + String(spec.year),
            at: 118, 1078, size: 19, colour: Field.sepia, face: "Georgia-Bold",
            align: .left, tracking: 2.4)

    var ty = 1128.0
    for e in spec.evidence.prefix(3) {
        caption(p, e.0.uppercased(), at: 118, ty, size: 18, colour: Field.sepia,
                face: "Georgia-Bold", align: .left, tracking: 2.4)
        ty += 30
        for line in wrapText(e.1, width: 1114, size: 23).prefix(2) {
            caption(p, line, at: 118, ty, size: 23, colour: Field.inkSoft, face: "Georgia", align: .left)
            ty += 29
        }
        ty += 12
    }

    plateFrame(p, inset: 46, seed: seed &+ 99)
    p.write(dir, "piece_" + spec.slug, quality: 0.90)
}
