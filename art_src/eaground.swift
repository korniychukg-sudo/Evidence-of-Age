import Foundation
import CoreGraphics

struct ToolSpec {
    let id: String
    let name: String
    let sub: String
    let kind: String
    let note: String
}

let toolBook: [ToolSpec] = tA + tB

let tA: [ToolSpec] = [
    ToolSpec(id: "lamp", name: "The raking light", sub: "A low light across a surface, not onto it", kind: "lamp",
             note: "Held almost parallel to the wood, a small lamp throws every tool mark, every ripple and every dent into relief. Straight on, the same surface looks flat and tells you nothing. It is the single most useful thing in the room."),
    ToolSpec(id: "glass", name: "The loupe", sub: "Ten times, and no more", kind: "glass",
             note: "Enough to read a saw mark, a veneer edge or a screw thread. Beyond ten times the depth of field disappears and you spend your time hunting for focus instead of looking."),
    ToolSpec(id: "torch", name: "The torch", sub: "For the parts nobody polished", kind: "torch",
             note: "Into the back of a carcase, under a top, inside a drawer. Everything honest about a piece of furniture is in the places the maker never expected anybody to see."),
    ToolSpec(id: "rule", name: "The rule", sub: "For measuring what should be equal and is not", kind: "rule",
             note: "Across the grain and along it, on a top that was turned round. On drawer heights that should graduate. On leg tapers that should match. Wood moves, and a rule is how you catch it."),
    ToolSpec(id: "gauge", name: "The gauge and caliper", sub: "Thickness of veneer, width of a pin", kind: "gauge",
             note: "A veneer under a millimetre is machine cut and after 1830. A dovetail pin narrower than the saw kerf is hand cut. Both are settled with a caliper in ten seconds."),
]

let tB: [ToolSpec] = [
    ToolSpec(id: "mirror", name: "The inspection mirror", sub: "For seeing round the back of things", kind: "mirror",
             note: "Behind a drawer, under a rail, inside a plinth. On a piece too heavy to turn over, a small mirror on a handle is the difference between a guess and an answer."),
    ToolSpec(id: "notebook", name: "The notebook", sub: "Because you will forget", kind: "notebook",
             note: "Every finding, in order, with what it rules out. A dating is an argument built from evidence, and an argument you cannot write down is a feeling."),
    ToolSpec(id: "uv", name: "Ultraviolet lamp", sub: "Old finish and new repair fluoresce differently", kind: "uv",
             note: "Shellac glows a warm orange; modern lacquer glows cold and bright; a filled repair shows as a dark patch. It does not date a piece, but it maps every intervention on it."),
    ToolSpec(id: "cloth", name: "Cloth and wax", sub: "For leaving it better than you found it", kind: "cloth",
             note: "A dealer who strips or over cleans a surface destroys most of the evidence and most of the value at the same time. Two centuries of patina takes two centuries to replace."),
    ToolSpec(id: "register", name: "The register", sub: "Where the dating actually happens", kind: "register",
             note: "A timeline, a set of findings, and a bracket you are willing to defend. Every piece of evidence narrows it from one end or the other, and where they overlap is your answer."),
]

func makeToolPlate(_ spec: ToolSpec, dir: String) {
    let p = Plate(1100, 900)
    let seed = hashOf("tool-" + spec.id)
    layPaper(p, seed: seed, tone: Field.paperWarm)
    p.topDown()
    p.light = -2.26
    var rng = Dice(seed &+ 3)
    let cx = 550.0, cy = 330.0

    switch spec.kind {
    case "lamp":
        woodFill(p, rectPts(cx - 380, cy + 120, 760, 120), tone: Field.mahogany, seed: seed &+ 5)
        p.rect(cx + 180, cy - 60, 40, 190, Field.ironDark)
        p.poly([pt(cx + 130, cy - 100), pt(cx + 270, cy - 100), pt(cx + 240, cy - 40),
                pt(cx + 160, cy - 40)], Field.iron)
        if let g = CGGradient(colorsSpace: rgbSpace,
                              colors: [cg(Field.lampWarm.al(0.55)), cg(Field.lampWarm.al(0))] as CFArray,
                              locations: [0, 1]) {
            p.ctx.saveGState()
            p.ctx.setBlendMode(.plusLighter)
            p.poly([pt(cx + 160, cy - 40), pt(cx + 240, cy - 40),
                    pt(cx - 360, cy + 130), pt(cx - 380, cy + 118)], Field.lampWarm.al(0.14))
            p.ctx.drawRadialGradient(g, startCenter: CGPoint(x: cx + 200, y: cy - 40), startRadius: 0,
                                     endCenter: CGPoint(x: cx + 200, y: cy - 40), endRadius: 320,
                                     options: [])
            p.ctx.restoreGState()
        }
        p.clip(pathOf(rectPts(cx - 380, cy + 120, 760, 120))) {
            for _ in 0..<160 {
                let x = cx - 380 + rng.d() * 760
                pen(p, [pt(x, cy + 120), pt(x + rng.r(20, 90), cy + 240)], weight: rng.r(1, 3),
                    colour: Field.ink.al(rng.r(0.06, 0.24)), wobble: 0.6, taper: true,
                    seed: seed &+ bits(Int(x)))
            }
        }
    case "glass":
        p.ring(cx - 60, cy, 150, 16, Field.ironDark)
        p.disc(cx - 60, cy, 140, Field.bone.al(0.30))
        p.clip(pathOf(ringPoints(cx: cx - 60, cy: cy, rx: 140, ry: 140, steps: 50))) {
            woodFill(p, rectPts(cx - 220, cy - 160, 340, 320), tone: Field.oakPale, seed: seed &+ 7)
            for k in 0..<9 {
                pen(p, [pt(cx - 200 + Double(k) * 34, cy - 160), pt(cx - 190 + Double(k) * 34, cy + 160)],
                    weight: 3, colour: Field.sepia.al(0.34), wobble: 1.2, taper: false,
                    seed: seed &+ bits(k))
            }
        }
        p.ring(cx - 60, cy, 140, 3, Field.bone.al(0.5))
        pen(p, [pt(cx + 60, cy + 90), pt(cx + 260, cy + 260)], weight: 26,
            colour: Field.ironDark, wobble: 0, taper: false, seed: seed &+ 9)
        pen(p, [pt(cx + 200, cy + 210), pt(cx + 300, cy + 296)], weight: 34,
            colour: Field.walnutDark, wobble: 0, taper: false, seed: seed &+ 11)
    case "torch":
        p.rect(cx - 300, cy - 34, 260, 68, Field.ironDark)
        p.rect(cx - 300, cy - 34, 260, 20, Field.iron)
        p.poly([pt(cx - 40, cy - 44), pt(cx + 10, cy - 54), pt(cx + 10, cy + 54),
                pt(cx - 40, cy + 44)], Field.steel)
        if let g = CGGradient(colorsSpace: rgbSpace,
                              colors: [cg(Field.lampWarm.al(0.50)), cg(Field.lampWarm.al(0))] as CFArray,
                              locations: [0, 1]) {
            p.ctx.saveGState()
            p.ctx.setBlendMode(.plusLighter)
            p.poly([pt(cx + 10, cy - 54), pt(cx + 420, cy - 200), pt(cx + 420, cy + 200),
                    pt(cx + 10, cy + 54)], Field.lampWarm.al(0.12))
            p.ctx.drawRadialGradient(g, startCenter: CGPoint(x: cx + 20, y: cy), startRadius: 0,
                                     endCenter: CGPoint(x: cx + 20, y: cy), endRadius: 380, options: [])
            p.ctx.restoreGState()
        }
        woodFill(p, rectPts(cx + 300, cy - 200, 160, 400), tone: Field.pine, seed: seed &+ 13)
    case "rule":
        p.rect(cx - 400, cy - 24, 800, 48, Field.satinwood)
        for k in 0..<33 {
            let x = cx - 390 + Double(k) * 24
            let long = k % 5 == 0
            pen(p, [pt(x, cy - 24), pt(x, cy - 24 + (long ? 26 : 14))], weight: 2,
                colour: Field.ink.al(0.7), wobble: 0, taper: false, seed: seed &+ bits(k))
            if long {
                caption(p, "\(k / 5 * 5)", at: x, cy + 4, size: 16, colour: Field.inkSoft, face: "Georgia")
            }
        }
        p.rect(cx - 400, cy - 24, 800, 6, Field.bone.al(0.4))
        penContour(p, rectPts(cx - 400, cy - 24, 800, 48), weight: 2, colour: Field.ink.al(0.6),
                   seed: seed &+ 15)
        p.rect(cx - 60, cy - 90, 12, 40, Field.brass)
        p.rect(cx + 200, cy - 90, 12, 40, Field.brass)
    case "gauge":
        pen(p, [pt(cx - 300, cy - 120), pt(cx + 220, cy + 60)], weight: 22,
            colour: Field.steel, wobble: 0, taper: false, seed: seed &+ 17)
        pen(p, [pt(cx - 300, cy + 120), pt(cx + 220, cy - 60)], weight: 22,
            colour: Field.steel.dk(0.10), wobble: 0, taper: false, seed: seed &+ 19)
        p.disc(cx - 40, cy, 22, Field.brass)
        p.poly([pt(cx + 220, cy + 60), pt(cx + 330, cy + 26), pt(cx + 220, cy + 20)], Field.steel)
        p.poly([pt(cx + 220, cy - 60), pt(cx + 330, cy - 26), pt(cx + 220, cy - 20)],
               Field.steel.dk(0.10))
        p.rect(cx + 336, cy - 12, 60, 24, Field.walnut)
    case "mirror":
        pen(p, [pt(cx - 320, cy + 220), pt(cx + 60, cy - 60)], weight: 20,
            colour: Field.ironDark, wobble: 0, taper: false, seed: seed &+ 21)
        let disc = ringPoints(cx: cx + 110, cy: cy - 110, rx: 130, ry: 130, steps: 44)
        p.poly(disc, Field.steel.lt(0.24))
        p.clip(pathOf(disc)) {
            woodFill(p, rectPts(cx - 40, cy - 260, 320, 320), tone: Field.oak.dk(0.10),
                     seed: seed &+ 23)
            for k in 0..<5 {
                p.disc(cx + 40 + Double(k) * 46, cy - 140, 7, Field.ironDark)
            }
        }
        p.ring(cx + 110, cy - 110, 130, 8, Field.ironDark)
    case "notebook":
        woodFill(p, rectPts(cx - 300, cy - 200, 600, 420), tone: Field.leather, seed: seed &+ 25)
        p.rect(cx - 280, cy - 180, 560, 380, Field.linen)
        for k in 0..<11 {
            pen(p, [pt(cx - 250, cy - 140 + Double(k) * 32), pt(cx + 250, cy - 140 + Double(k) * 32)],
                weight: 1.2, colour: Field.inkPale.al(0.4), wobble: 0.3, taper: false,
                seed: seed &+ bits(k))
            if k < 7 {
                let len = rng.r(180, 420)
                pen(p, [pt(cx - 240, cy - 146 + Double(k) * 32), pt(cx - 240 + len, cy - 146 + Double(k) * 32)],
                    weight: 2.4, colour: Field.ink.al(0.55), wobble: 1.8, taper: false,
                    seed: seed &+ bits(k + 20))
            }
        }
    case "uv":
        p.rect(cx - 260, cy - 30, 300, 60, Field.ironDark)
        p.rect(cx + 40, cy - 22, 60, 44, Field.slate)
        if let g = CGGradient(colorsSpace: rgbSpace,
                              colors: [cg(Tone(r: 0.62, g: 0.44, b: 0.94).al(0.45)),
                                       cg(Tone(r: 0.62, g: 0.44, b: 0.94).al(0))] as CFArray,
                              locations: [0, 1]) {
            p.ctx.saveGState()
            p.ctx.setBlendMode(.plusLighter)
            p.ctx.drawRadialGradient(g, startCenter: CGPoint(x: cx + 260, y: cy), startRadius: 0,
                                     endCenter: CGPoint(x: cx + 260, y: cy), endRadius: 300, options: [])
            p.ctx.restoreGState()
        }
        woodFill(p, rectPts(cx + 120, cy - 180, 320, 360), tone: Field.walnut, seed: seed &+ 27)
        p.poly(blob(cx: cx + 300, cy: cy + 40, rx: 70, ry: 46, rough: 0.3, steps: 18,
                    seed: seed &+ 29), Field.night.al(0.55))
        caption(p, "a filled repair", at: cx + 300, cy + 130, size: 22, colour: Field.sepia,
                face: "Georgia-Italic")
    case "cloth":
        p.poly(blob(cx: cx - 120, cy: cy, rx: 220, ry: 160, rough: 0.22, steps: 26, seed: seed &+ 31),
               Field.linen)
        for _ in 0..<600 {
            p.disc(cx - 320 + rng.d() * 420, cy - 170 + rng.d() * 340, rng.r(1, 3),
                   Field.dust.al(rng.r(0.05, 0.20)))
        }
        p.disc(cx + 220, cy + 40, 110, Field.brass.dk(0.16))
        p.disc(cx + 220, cy + 20, 100, Field.wax)
        p.ring(cx + 220, cy + 40, 110, 4, Field.brassDark)
    default:
        drawGrid(p, CGRect(x: 120, y: 160, width: 860, height: 340), step: 40, seed: seed &+ 33)
        pen(p, [pt(150, 420), pt(950, 420)], weight: 4, colour: Field.ink, wobble: 0.4,
            taper: false, seed: seed &+ 35)
        for k in 0..<9 {
            let x = 150.0 + Double(k) * 100
            pen(p, [pt(x, 405), pt(x, 435)], weight: 2.4, colour: Field.inkSoft, wobble: 0,
                taper: false, seed: seed &+ bits(k))
            caption(p, "\(1650 + k * 40)", at: x, 468, size: 19, colour: Field.inkSoft, face: "Georgia")
        }
        p.rect(430, 380, 220, 18, Field.oxblood.al(0.5))
        pen(p, [pt(430, 350), pt(430, 400)], weight: 3, colour: Field.oxblood, wobble: 0,
            taper: false, seed: seed &+ 37)
        pen(p, [pt(650, 350), pt(650, 400)], weight: 3, colour: Field.oxblood, wobble: 0,
            taper: false, seed: seed &+ 39)
        caption(p, "the bracket you will defend", at: 540, 320, size: 23, colour: Field.oxblood,
                face: "Georgia-Bold")
    }

    caption(p, spec.name, at: 92, 640, size: 40, colour: Field.ink, face: "Georgia-Bold", align: .left)
    caption(p, spec.sub, at: 92, 678, size: 24, colour: Field.inkPale, face: "Georgia-Italic", align: .left)
    pen(p, [pt(92, 704), pt(1008, 704)], weight: 1.4, colour: Field.inkPale.al(0.6),
        wobble: 0.4, taper: false, seed: seed &+ 61)
    var ty = 748.0
    for line in wrapText(spec.note, width: 916, size: 23) {
        caption(p, line, at: 92, ty, size: 23, colour: Field.inkSoft, face: "Georgia", align: .left)
        ty += 29
    }
    plateFrame(p, inset: 40, seed: seed &+ 99)
    p.write(dir, "tool_" + spec.id, quality: 0.92)
}

func makeGrounds(dir: String) {
    let paper = Plate(1100, 1900)
    layPaper(paper, seed: 3301, tone: Field.paper)
    paper.write(dir, "bg_paper", quality: 0.86)

    let card = Plate(900, 1200)
    layPaper(card, seed: 3307, tone: Field.paperWarm, laid: false)
    card.write(dir, "bg_card", quality: 0.86)

    let bench = Plate(1400, 900)
    bench.fillAll(Field.oak.dk(0.16))
    bench.topDown()
    var rb = Dice(3311)
    var by = -20.0
    while by < 900 {
        let hgt = rb.r(130, 210)
        bench.rect(0, by, 1400, hgt, Field.oak.dk(rb.r(0.06, 0.26)))
        for _ in 0..<520 {
            let x = rb.d() * 1400, y = by + rb.d() * hgt
            pen(bench, [pt(x, y), pt(x + rb.r(60, 340), y + rb.r(-4, 4))], weight: rb.r(0.8, 2.6),
                colour: (rb.chance(0.5) ? Field.oakDark : Field.oakPale).al(rb.r(0.06, 0.26)),
                wobble: 0.6, taper: true, seed: bits(Int(x + y)))
        }
        bench.rect(0, by + hgt - 3, 1400, 4, Field.night.al(0.4))
        by += hgt
    }
    if let g = CGGradient(colorsSpace: rgbSpace,
                          colors: [cg(Field.night.al(0)), cg(Field.night.al(0.34))] as CFArray,
                          locations: [0.45, 1]) {
        bench.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 700, y: 380), startRadius: 0,
                                     endCenter: CGPoint(x: 700, y: 380), endRadius: 1050,
                                     options: [.drawsAfterEndLocation])
    }
    bench.write(dir, "bg_bench", quality: 0.86)

    let room = Plate(1400, 900)
    room.fillAll(Field.linen.dk(0.20))
    room.topDown()
    var rr = Dice(3319)
    for _ in 0..<600 {
        let x = rr.d() * 1400, y = rr.d() * 900
        room.poly(blob(cx: x, cy: y, rx: rr.r(40, 220), ry: rr.r(30, 160), rough: 0.30, steps: 20,
                       seed: bits(Int(y))),
                  (rr.chance(0.5) ? Field.linen : Field.dust).al(rr.r(0.03, 0.12)))
    }
    room.rect(0, 620, 1400, 12, Field.walnutDark.al(0.5))
    room.rect(0, 632, 1400, 268, Field.walnut.dk(0.18))
    for k in 0..<9 {
        room.rect(Double(k) * 160, 632, 4, 268, Field.night.al(0.25))
    }
    for _ in 0..<4000 {
        room.disc(rr.d() * 1400, 632 + rr.d() * 268, rr.r(0.6, 2.6),
                  (rr.chance(0.5) ? Field.oakPale : Field.night).al(rr.r(0.03, 0.14)))
    }
    if let g = CGGradient(colorsSpace: rgbSpace,
                          colors: [cg(Field.lampWarm.al(0.16)), cg(Field.night.al(0.32))] as CFArray,
                          locations: [0, 1]) {
        room.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 1080, y: 200), startRadius: 0,
                                    endCenter: CGPoint(x: 1080, y: 200), endRadius: 1300,
                                    options: [.drawsAfterEndLocation])
    }
    room.write(dir, "bg_room", quality: 0.86)

    let baizeP = Plate(1100, 1900)
    baizeP.fillAll(Field.baize)
    baizeP.topDown()
    var rz = Dice(3323)
    for _ in 0..<20000 {
        baizeP.disc(rz.d() * 1100, rz.d() * 1900, rz.r(0.6, 2.4),
                    (rz.chance(0.5) ? Field.baize.lt(0.16) : Field.baize.dk(0.20)).al(rz.r(0.10, 0.36)))
    }
    if let g = CGGradient(colorsSpace: rgbSpace,
                          colors: [cg(Field.night.al(0)), cg(Field.night.al(0.38))] as CFArray,
                          locations: [0.45, 1]) {
        baizeP.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 550, y: 800), startRadius: 0,
                                      endCenter: CGPoint(x: 550, y: 800), endRadius: 1500,
                                      options: [.drawsAfterEndLocation])
    }
    baizeP.write(dir, "bg_baize", quality: 0.86)

    let slate = Plate(1100, 1900)
    slate.fillAll(Field.slate.dk(0.24))
    slate.topDown()
    var rs = Dice(3329)
    for _ in 0..<620 {
        let x = rs.d() * 1100, y = rs.d() * 1900
        slate.poly(blob(cx: x, cy: y, rx: rs.r(40, 220), ry: rs.r(30, 160), rough: 0.34, steps: 20,
                        seed: bits(Int(y))),
                   (rs.chance(0.5) ? Field.night : Field.slate.lt(0.14)).al(rs.r(0.05, 0.16)))
    }
    for _ in 0..<12000 {
        slate.disc(rs.d() * 1100, rs.d() * 1900, rs.r(0.6, 2.4), Field.bone.al(rs.r(0.01, 0.06)))
    }
    slate.write(dir, "bg_slate", quality: 0.86)
}
