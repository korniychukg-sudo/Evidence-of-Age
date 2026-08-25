import Foundation
import CoreGraphics

func makeIcon(dir: String) {
    let S = 1024
    let p = Plate(S, S)
    p.topDown()
    p.light = -0.42
    let seed: UInt64 = 0xA6E_11
    var rng = Dice(seed &+ 5)
    let W = Double(S)

    p.fillAll(Tone(r: 0.098, g: 0.082, b: 0.066))
    for k in 0..<9 {
        let y0 = W * Double(k) / 9
        let t = rng.r(0, 1)
        p.rect(0, y0, W, W / 9 + 1,
               Tone(r: 0.176 + t * 0.042, g: 0.128 + t * 0.028, b: 0.092 + t * 0.018))
    }
    for k in 0..<44 {
        let r = W * (0.74 - Double(k) * 0.0148)
        p.disc(W * 0.12, W * 0.04, r, Tone(r: 0.988, g: 0.796, b: 0.502).al(0.011))
    }

    let ax = 84.0, ay = 208.0
    let depth = 344.0
    let faceW = 546.0
    let faceH = 640.0

    let fTL = pt(ax, ay)
    let fTR = pt(ax + faceW, ay + 64)
    let fBR = pt(ax + faceW, ay + 64 + faceH)
    let fBL = pt(ax, ay + faceH)
    let sTR = pt(ax + faceW + depth, ay - 24)
    let sBR = pt(ax + faceW + depth, ay - 24 + faceH * 0.94)

    for k in 0..<10 {
        let o = Double(k) * 9
        p.poly([pt(Double(fTL.x) - o * 0.4, Double(fTL.y) + o + 44),
                pt(Double(sTR.x) - o * 0.4, Double(sTR.y) + o + 44),
                pt(Double(sBR.x) - o * 0.4, Double(sBR.y) + o + 44),
                pt(Double(fBL.x) - o * 0.4, Double(fBL.y) + o + 44)],
               Tone(r: 0.02, g: 0.016, b: 0.012).al(0.048))
    }

    p.poly([fTR, sTR, sBR, fBR], Field.walnut.dk(0.30))
    var sideGrain = Dice(seed &+ 61)
    for k in 0..<16 {
        let u = Double(k) / 15
        pen(p, [pt(Double(fTR.x) + 6, Double(fTR.y) + u * faceH * 0.94),
                pt(Double(sTR.x) - 6, Double(sTR.y) + u * faceH * 0.94)],
            weight: sideGrain.r(1.6, 3.6),
            colour: Field.mahogDark.al(sideGrain.r(0.16, 0.34)),
            wobble: 1.2, taper: true, seed: seed &+ UInt64(k * 7 + 70))
    }
    penContour(p, [fTR, sTR, sBR, fBR], weight: 5.0, colour: Field.night.al(0.86), seed: seed &+ 71)

    p.poly([fTL, fTR, fBR, fBL], Field.walnut)
    p.clip(pathOf([fTL, fTR, fBR, fBL])) {
        var g = Dice(seed &+ 91)
        for k in 0..<22 {
            let u = Double(k) / 21
            var line: [CGPoint] = []
            for i in 0...10 {
                let v = Double(i) / 10
                let x = Double(fTL.x) + v * faceW
                let y = Double(fTL.y) + u * faceH + v * 64 + sin(v * 5 + u * 9) * 12
                line.append(pt(x, y))
            }
            penBroken(p, line, weight: g.r(1.8, 4.2),
                      colour: Field.mahogDark.al(g.r(0.14, 0.32)),
                      pieces: 3, gap: 0.05, wobble: 1.3, seed: seed &+ UInt64(k * 11 + 100))
        }
        for _ in 0..<3 {
            let kx = g.r(Double(fTL.x) + 60, Double(fTR.x) - 60)
            let ky = g.r(Double(fTL.y) + 60, Double(fBL.y) - 60)
            p.ellipse(kx, ky, g.r(10, 22), g.r(7, 14), Field.mahogDark.al(0.34))
        }
    }

    let pinCount = 5
    let pinTop = ay + 118
    let pinStep = 96.0
    let ex = Double(fTR.x)
    for k in 0..<pinCount {
        let y0 = pinTop + Double(k) * pinStep
        let tailFront: [CGPoint] = [
            pt(ex - 2, y0 + 4),
            pt(ex - 2, y0 + 74),
            pt(ex - 168, y0 + 60),
            pt(ex - 168, y0 + 22)]
        p.poly(tailFront, Field.walnut.lt(0.12))
        penContour(p, tailFront, weight: 4.2, colour: Field.night.al(0.82), seed: seed &+ UInt64(k * 13 + 130))
        let pinSide: [CGPoint] = [
            pt(ex + 2, y0 + 74),
            pt(ex + 2, y0 + 122),
            pt(ex + 166, y0 + 92),
            pt(ex + 166, y0 + 56)]
        p.poly(pinSide, Field.walnut.dk(0.16))
        penContour(p, pinSide, weight: 4.2, colour: Field.night.al(0.82), seed: seed &+ UInt64(k * 17 + 140))
        pen(p, [pt(ex - 168, y0 + 22), pt(ex - 2, y0 + 4)],
            weight: 5.4, colour: Field.lampWarm.al(0.50), wobble: 0.6, taper: true,
            seed: seed &+ UInt64(k * 19 + 150))
        pen(p, [pt(ex - 168, y0 + 60), pt(ex - 2, y0 + 74)],
            weight: 4.2, colour: Field.night.al(0.58), wobble: 0.6, taper: true,
            seed: seed &+ UInt64(k * 23 + 160))
        pen(p, [pt(ex + 2, y0 + 76), pt(ex + 166, y0 + 58)],
            weight: 4.4, colour: Field.lampWarm.al(0.30), wobble: 0.5, taper: true,
            seed: seed &+ UInt64(k * 29 + 168))
    }
    pen(p, [fTR, fBR], weight: 6.0, colour: Field.night.al(0.9), wobble: 0.6, taper: false,
        seed: seed &+ 171)

    var scribe: [CGPoint] = []
    for i in 0...16 {
        let u = Double(i) / 16
        scribe.append(pt(Double(fTR.x) - 178 + rng.signed() * 2, Double(fTR.y) + u * faceH))
    }
    pen(p, scribe, weight: 3.0, colour: Field.night.al(0.55), wobble: 0.8, taper: false, seed: seed &+ 175)

    let hx = ax + 176.0, hy = ay + 402.0
    p.poly([pt(hx - 108, hy + 12), pt(hx + 108, hy + 26), pt(hx + 104, hy + 60), pt(hx - 112, hy + 46)],
           Tone(r: 0.02, g: 0.016, b: 0.012).al(0.40))
    var plate: [CGPoint] = []
    for i in 0...30 {
        let a = Double.pi * 2 * Double(i) / 30
        plate.append(pt(hx + cos(a) * 112, hy + sin(a) * 46 + 8))
    }
    p.poly(plate, Field.brass.dk(0.16))
    penContour(p, plate, weight: 4.4, colour: Field.night.al(0.85), seed: seed &+ 181)
    var bail: [CGPoint] = []
    for i in 0...26 {
        let a = Double.pi * Double(i) / 26
        bail.append(pt(hx + cos(a) * 92, hy + 12 + sin(a) * 78))
    }
    pen(p, bail.map { pt(Double($0.x) + 6, Double($0.y) + 12) }, weight: 20.0,
        colour: Tone(r: 0.02, g: 0.016, b: 0.012).al(0.40), wobble: 0.6, taper: false, seed: seed &+ 183)
    pen(p, bail, weight: 19.0, colour: Field.brass, wobble: 0.5, taper: false, seed: seed &+ 185)
    pen(p, bail.map { pt(Double($0.x) - 4, Double($0.y) - 5) }, weight: 6.0,
        colour: Field.lampWarm.al(0.62), wobble: 0.4, taper: true, seed: seed &+ 187)
    for side in [-1.0, 1.0] {
        p.disc(hx + side * 92, hy + 12, 15, Field.brass.dk(0.24))
        penContour(p, ringPoints(cx: hx + side * 92, cy: hy + 12, rx: 15, ry: 15, steps: 18),
                   weight: 3.4, colour: Field.night.al(0.8), seed: seed &+ UInt64(190 + Int(side + 2)))
    }

    p.poly([fTL, fTR, fBR, fBL].map { $0 }, Field.night.al(0.0))
    var lit: [CGPoint] = [pt(Double(fTL.x) - 20, Double(fTL.y) - 20),
                          pt(Double(fTR.x) + 20, Double(fTR.y) - 20),
                          pt(Double(fTR.x) + 20, Double(fTR.y) + 150),
                          pt(Double(fTL.x) - 20, Double(fTL.y) + 110)]
    p.clipBoth(pathOf([fTL, fTR, fBR, fBL]), pathOf(lit)) {
        p.poly([fTL, fTR, fBR, fBL], Field.lampWarm.al(0.10))
    }
    formShade(p, [fTL, fTR, fBR, fBL], inset: 130, depth: 2, spacing: 9.0,
              colour: Field.night.al(0.26), seed: seed &+ 195)
    penContour(p, [fTL, fTR, fBR, fBL], weight: 6.0, colour: Field.night.al(0.9), seed: seed &+ 197)

    for k in 0..<14 {
        let inset = Double(k) * 30
        p.poly([pt(-10, W - inset), pt(W + 10, W - inset), pt(W + 10, W + 10), pt(-10, W + 10)],
               Tone(r: 0.02, g: 0.016, b: 0.012).al(0.042))
        p.poly([pt(W - inset, -10), pt(W + 10, -10), pt(W + 10, W + 10), pt(W - inset, W + 10)],
               Tone(r: 0.02, g: 0.016, b: 0.012).al(0.036))
    }
    let gx = 806.0, gy = 236.0
    let rimR = 216.0
    p.disc(gx + 18, gy + 26, rimR + 12, Tone(r: 0.02, g: 0.016, b: 0.012).al(0.42))
    p.disc(gx, gy, rimR - 24, Field.lampWarm.al(0.16))
    p.clip(pathOf(ringPoints(cx: gx, cy: gy, rx: rimR - 24, ry: rimR - 24, steps: 60))) {
        var lens = Dice(seed &+ 210)
        for k in 0..<9 {
            let u = Double(k) / 8
            pen(p, [pt(gx - rimR, gy - rimR + u * rimR * 2), pt(gx + rimR, gy - rimR * 0.4 + u * rimR * 2)],
                weight: lens.r(3.0, 7.0), colour: Field.lampWarm.al(lens.r(0.08, 0.20)),
                wobble: 1.0, taper: true, seed: seed &+ UInt64(k + 214))
        }
        pen(p, [pt(gx - rimR * 0.7, gy - rimR * 0.2), pt(gx - rimR * 0.1, gy - rimR * 0.7)],
            weight: 26.0, colour: Field.lampWarm.al(0.34), wobble: 0.8, taper: true, seed: seed &+ 219)
    }
    p.ring(gx, gy, rimR, 30, Field.brass.dk(0.22))
    p.ring(gx, gy, rimR - 3, 20, Field.brass)
    p.ring(gx, gy, rimR - 13, 6, Field.night.al(0.72))
    p.ring(gx, gy, rimR + 13, 5, Field.night.al(0.62))
    pen(p, ringPoints(cx: gx, cy: gy, rx: rimR + 2, ry: rimR + 2, steps: 60).filter {
        Double($0.y) < gy - rimR * 0.42
    }, weight: 9.0, colour: Field.lampWarm.al(0.62), wobble: 0.6, taper: true, seed: seed &+ 225)
    var handle: [CGPoint] = []
    for i in 0...16 {
        let u = Double(i) / 16
        handle.append(pt(gx + rimR * 0.72 + u * 300, gy - rimR * 0.70 - u * 220))
    }
    pen(p, handle.map { pt(Double($0.x) + 8, Double($0.y) + 14) }, weight: 34.0,
        colour: Tone(r: 0.02, g: 0.016, b: 0.012).al(0.36), wobble: 0.6, taper: false, seed: seed &+ 227)
    pen(p, handle, weight: 32.0, colour: Field.walnut.dk(0.24), wobble: 0.5, taper: false, seed: seed &+ 229)
    pen(p, handle.map { pt(Double($0.x) - 5, Double($0.y) - 8) }, weight: 8.0,
        colour: Field.lampWarm.al(0.34), wobble: 0.4, taper: true, seed: seed &+ 231)

    stipple(p, pathOf([pt(0, 0), pt(W, 0), pt(W, W), pt(0, W)]),
            density: 0.00012, sizeMin: 0.7, sizeMax: 2.0, colour: Field.lampWarm.al(0.10),
            seed: seed &+ 199)
    p.writePNG(dir, "AppIcon-1024")
}
