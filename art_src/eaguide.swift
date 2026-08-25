import Foundation
import CoreGraphics

struct GuideSpec {
    let id: String
    let kicker: String
    let title: String
    let sub: String
    let kind: String
    let notes: [(String, String)]
}

let guideBook: [GuideSpec] = gA + gB + gC

let gA: [GuideSpec] = [
    GuideSpec(id: "dovetail", kicker: "Plate I", title: "Dovetails",
              sub: "The single most useful thing in a drawer",
              kind: "dovetail",
              notes: [("Narrow pins mean a hand", "A hand cut dovetail has pins far narrower than the tails, because a saw kerf is all the room you need. A machine cannot do it."),
                      ("The gauge line does not stop", "A hand cut joint is set out with a marking gauge run right across the board, and the line is still there, running past the joint at both ends."),
                      ("Machine cut is perfectly even", "From about 1860 a router jig gives pins and tails of identical width and a gauge line that starts and stops with the cutter."),
                      ("Count them", "Three to a corner on an eighteenth century drawer of ordinary depth; five or six on a Victorian one, because the machine did not care.")]),
    GuideSpec(id: "sawmarks", kicker: "Plate II", title: "Saw marks",
              sub: "Three technologies, three signatures, three date ranges",
              kind: "saw",
              notes: [("Pit saw: straight and irregular", "Two men, one above and one below. The marks run straight across but the spacing wanders because it was cut by hand."),
                      ("Frame or gang saw: straight and even", "Water or steam powered, from the late eighteenth century. Straight marks at very regular spacing."),
                      ("Circular saw: arcs", "Curved marks, and they cannot be anything else. In general use from about 1830 and never absent afterwards."),
                      ("Look where nobody polished", "Backboards, drawer bottoms, the underside of a top. The marks survive only where the piece was never finished.")]),
    GuideSpec(id: "shrinkage", kicker: "Plate III", title: "Shrinkage",
              sub: "Wood moves across the grain and hardly at all along it",
              kind: "shrinkage",
              notes: [("Round becomes oval", "A tabletop turned round in 1770 now measures several millimetres less across the grain than along it. A modern copy is still round."),
                      ("Panels shrink out of their grooves", "Frame and panel construction exists because of this. Look at the panel edges for a line of original colour that the shrinkage has exposed."),
                      ("Doors and drawer fronts", "A drawer front shrinks in height, not in width, so the gaps at top and bottom grow while the sides stay tight."),
                      ("It never stops", "Wood keeps moving with the seasons for its whole life. A piece that is dead square and perfectly tight is telling you something.")]),
    GuideSpec(id: "screws", kicker: "Plate IV", title: "Screws and nails",
              sub: "Fixings date a piece more reliably than its style",
              kind: "screws",
              notes: [("Hand made screws", "Before about 1780: a filed slot, off centre, an irregular thread and a blunt end. The head is never a true circle."),
                      ("Machine screws with blunt ends", "1780 to 1850: even threads from a lathe, but the end is still blunt because the gimlet point had not been invented."),
                      ("Gimlet point", "After about 1850 screws are pointed, threads are even and the slot is dead centre. That combination is a hard date."),
                      ("Nails tell the same story", "Hand forged rose head, then rectangular cut nails from about 1800, then round wire nails from about 1890.")]),
    GuideSpec(id: "patina", kicker: "Plate V", title: "Patina and wear",
              sub: "Where the surface has gone, and where it has built up",
              kind: "patina",
              notes: [("Wear where hands go", "Chair arms, drawer edges, the front of a seat, the lower rail of a table where feet rest. Anywhere else is suspicious."),
                      ("Build up where nothing touches", "Wax, dust and dirt collect in mouldings and corners and darken over centuries. Sharp clean mouldings on a dark piece are a warning."),
                      ("Colour under the top", "Lift a table top and look at the underside. Old wood oxidises to a colour that no stain reproduces, and it is even, not blotchy."),
                      ("Faked wear is too even", "Real wear follows use, so it is asymmetric and it stops abruptly where hands stopped. Sanded wear is smooth and everywhere.")]),
]

let gB: [GuideSpec] = [
    GuideSpec(id: "timber", kicker: "Plate VI", title: "Timbers by date",
              sub: "What was available, and when it became fashionable",
              kind: "timber",
              notes: [("Oak, to about 1670", "English oak, riven or pit sawn, in frame and panel construction. Almost everything before the Restoration is oak."),
                      ("Walnut, 1670 to 1730", "Then a hard winter in 1709 killed the European walnut forests and a French export ban finished it."),
                      ("Mahogany, 1730 onward", "Cuban first, dense and dark; then Honduras, lighter and softer. It arrives with a change in the timber duty."),
                      ("Rosewood and satinwood, Regency", "Exotic and expensive, usually as veneer. Then the Victorians go back to oak and walnut and everything gets heavier.")]),
    GuideSpec(id: "veneer", kicker: "Plate VII", title: "Veneer",
              sub: "Thickness dates it better than pattern does",
              kind: "veneer",
              notes: [("Saw cut veneer", "Before about 1830 veneer is sawn, and it is one and a half to two millimetres thick. Look at an edge or a chipped corner."),
                      ("Knife cut veneer", "After the veneer slicer arrives, thickness drops to half a millimetre and then less. It is perfectly even and it cannot be scraped."),
                      ("Groundwork matters", "Early veneer is laid on pine or oak. Plywood grounds are twentieth century and end the argument at once."),
                      ("Look for the joint", "Book matched or quarter matched veneer meets at a joint. On old work the joint has opened very slightly with age.")]),
    GuideSpec(id: "handles", kicker: "Plate VIII", title: "Handles",
              sub: "Fashions change every twenty years, and the holes are permanent",
              kind: "handles",
              notes: [("Drops, then plates", "Brass drops to about 1710, then pierced backplates, then swan neck bails from about 1740, then stamped plates from about 1790."),
                      ("Wooden knobs", "Turned wood from about 1820, gone by 1870. Cheap, fashionable, and hated by everybody who came after."),
                      ("Count the holes", "Look inside the drawer. Every set of handles a piece has ever worn has left its holes, and the earliest set is the one that matters."),
                      ("Original is rare", "A piece with its first handles and no extra holes is unusual and it is worth a great deal more than one without.")]),
    GuideSpec(id: "backboards", kicker: "Plate IX", title: "Backboards and secondary timber",
              sub: "The parts nobody was meant to see are the honest ones",
              kind: "backboards",
              notes: [("Never finished", "Backboards were left from the saw. Whatever tool cut them is still readable on the surface, and nobody polished it away."),
                      ("Riven, then sawn, then machined", "Riven oak boards with irregular edges are seventeenth century. Wide pine boards are eighteenth. Thin even boards or plywood are later."),
                      ("Gaps have opened", "Backboards shrink across their width and the gaps between them grow. A tight back on an old carcase has been replaced."),
                      ("Secondary timber by region", "Oak linings in London, pine in the provinces, and in America whatever grew nearby. It narrows the place as well as the date.")]),
    GuideSpec(id: "finish", kicker: "Plate X", title: "Finish",
              sub: "Four surfaces, four centuries",
              kind: "finish",
              notes: [("Wax and oil", "Before about 1820 the surface is wax over bare wood, or a linseed oil finish, built up over generations and full of dirt."),
                      ("French polish", "Shellac, from about 1820, applied with a rubber. It gives a deep gloss and it goes white if water touches it."),
                      ("Cellulose", "Sprayed, from the 1920s. It crazes into a fine crackle as it ages, which shellac never does."),
                      ("Modern lacquer", "Hard, plastic, even, and it sits on the surface rather than in it. It is the easiest thing in the world to spot.")]),
]

let gC: [GuideSpec] = [
    GuideSpec(id: "construction", kicker: "Plate XI", title: "How the carcase is held together",
              sub: "Pegs, then dovetails, then screws, then staples",
              kind: "construction",
              notes: [("Pegged frame and panel", "To about 1670. Drawbored mortice and tenon, no glue, and the panels float free in their grooves."),
                      ("Dovetailed carcase", "From the late seventeenth century. The sides are dovetailed to the top and bottom, and glue does the work."),
                      ("Glue blocks and screws", "Eighteenth century onward. Small triangular blocks rubbed into the corners, and screws where strength is needed."),
                      ("Staples and dowels", "Twentieth century mass production. A staple gun in a carcase ends every argument about date immediately.")]),
    GuideSpec(id: "proportion", kicker: "Plate XII", title: "Proportion",
              sub: "The first thing a good eye reads, and the hardest to fake",
              kind: "proportion",
              notes: [("Height comes down", "Furniture gets lower through the eighteenth century and lower again in the nineteenth as ceilings and rooms change."),
                      ("Legs get thinner, then thicker", "Heavy turned legs, then the cabriole, then the tapered leg at its thinnest around 1790, then heavy again by 1840."),
                      ("Drawers graduate", "On good work each drawer is deeper than the one above by a consistent step. A copy usually makes them all the same or gets the rhythm wrong."),
                      ("Cut down and married", "Many old pieces have been altered. A chest that is oddly short has lost its feet; a bookcase that is oddly wide is two pieces joined.")]),
    GuideSpec(id: "marriage", kicker: "Plate XIII", title: "Marriages and alterations",
              sub: "Half of what survives has been changed by somebody",
              kind: "marriage",
              notes: [("The top does not match", "Different timber, different colour, different saw marks, or the mouldings do not run through. Two pieces made a century apart."),
                      ("Cut down", "A tall chest made into a low one. Look for a moulding that runs off the edge, or feet that are newer than everything above them."),
                      ("Replaced feet", "Feet take the damp and go first. New feet on an old carcase are normal and honest; new feet described as original are not."),
                      ("Not a fault, but a fact", "An altered piece is still an old piece. It is only a problem when nobody says so.")]),
    GuideSpec(id: "faking", kicker: "Plate XIV", title: "How a fake gives itself away",
              sub: "Nobody can fake every kind of evidence at once",
              kind: "faking",
              notes: [("The evidence disagrees", "Hand cut dovetails and a circular sawn backboard. Georgian proportions and gimlet pointed screws. One thing is lying."),
                      ("Wear in the wrong place", "Worn edges where no hand ever went, and sharp edges where hands always go. Real wear follows use."),
                      ("Too clean inside", "Old drawers smell of old wood and are dirty in the corners. A new interior in an old carcase is a rebuild."),
                      ("Colour that is only skin deep", "Chip a hidden edge. Old colour goes into the wood; stain sits on it and shows a pale line under the surface.")]),
]

func drawGrid(_ p: Plate, _ r: CGRect, step: Double, seed: UInt64) {
    p.rect(Double(r.minX), Double(r.minY), Double(r.width), Double(r.height), Field.paperCool.al(0.5))
    var x = Double(r.minX)
    while x <= Double(r.maxX) { p.rect(x, Double(r.minY), 1.0, Double(r.height), Field.inkPale.al(0.20)); x += step }
    var y = Double(r.minY)
    while y <= Double(r.maxY) { p.rect(Double(r.minX), y, Double(r.width), 1.0, Field.inkPale.al(0.20)); y += step }
    penContour(p, [pt(Double(r.minX), Double(r.minY)), pt(Double(r.maxX), Double(r.minY)),
                   pt(Double(r.maxX), Double(r.maxY)), pt(Double(r.minX), Double(r.maxY))],
               weight: 2.2, colour: Field.ink.al(0.8), seed: seed)
}

func drawDovetails(_ p: Plate, x: Double, y: Double, w: Double, h: Double,
                   count: Int, narrowPins: Bool, seed: UInt64) {
    var rng = Dice(seed)
    woodFill(p, rectPts(x, y, w, h), tone: Field.oakPale, seed: seed &+ 3)
    let pinW = narrowPins ? w / Double(count) * 0.16 : w / Double(count) * 0.46
    for k in 0...count {
        let cx = x + Double(k) * w / Double(count)
        let jitter = narrowPins ? rng.r(-3, 3) : 0
        let tail: [CGPoint] = [pt(cx - pinW / 2 + jitter, y),
                               pt(cx + pinW / 2 + jitter, y),
                               pt(cx + pinW * 1.9 + jitter, y + h * 0.62),
                               pt(cx - pinW * 1.9 + jitter, y + h * 0.62)]
        p.poly(tail, Field.oak.dk(0.14))
        penContour(p, tail, weight: 1.8, colour: Field.ink.al(0.7), seed: seed &+ bits(k))
    }
    pen(p, [pt(x, y + h * 0.62), pt(x + w, y + h * 0.62)], weight: 1.6,
        colour: Field.ink.al(0.5), wobble: 0.4, taper: false, seed: seed &+ 11)
    if narrowPins {
        pen(p, [pt(x - 40, y + h * 0.62), pt(x + w + 40, y + h * 0.62)], weight: 1.2,
            colour: Field.oxblood.al(0.7), wobble: 0.4, taper: false, seed: seed &+ 13)
    }
}

func makeGuidePlate(_ spec: GuideSpec, dir: String) {
    let p = Plate(1350, 1560)
    let seed = hashOf("guide-" + spec.id)
    layPaper(p, seed: seed, tone: Field.paper)
    p.topDown()
    p.light = -2.30
    var rng = Dice(seed &+ 5)
    let stage = CGRect(x: 130, y: 168, width: 1090, height: 640)

    switch spec.kind {
    case "dovetail":
        drawGrid(p, stage, step: 45, seed: seed &+ 3)
        drawDovetails(p, x: 220, y: 250, w: 420, h: 230, count: 3, narrowPins: true, seed: seed &+ 7)
        drawDovetails(p, x: 720, y: 250, w: 420, h: 230, count: 6, narrowPins: false, seed: seed &+ 9)
        caption(p, "hand cut: narrow pins, gauge line runs on", at: 430, 540, size: 23,
                colour: Field.oxblood, face: "Georgia-Bold")
        caption(p, "machine cut: pins and tails identical", at: 930, 540, size: 23,
                colour: Field.inkSoft, face: "Georgia-Italic")
        drawDovetails(p, x: 220, y: 610, w: 420, h: 160, count: 3, narrowPins: true, seed: seed &+ 15)
        drawDovetails(p, x: 720, y: 610, w: 420, h: 160, count: 6, narrowPins: false, seed: seed &+ 17)
    case "saw":
        for k in 0..<3 {
            let y = 230.0 + Double(k) * 200
            woodFill(p, rectPts(230, y, 880, 150), tone: Field.pine, seed: seed &+ bits(k))
            p.clip(pathOf(rectPts(230, y, 880, 150))) {
                switch k {
                case 0:
                    var x = 240.0
                    while x < 1110 {
                        pen(p, [pt(x, y), pt(x + rng.r(-10, 10), y + 150)], weight: rng.r(1.4, 3.0),
                            colour: Field.sepia.al(rng.r(0.18, 0.44)), wobble: 1.4, taper: false,
                            seed: seed &+ bits(Int(x)))
                        x += rng.r(14, 34)
                    }
                case 1:
                    var x = 240.0
                    while x < 1110 {
                        pen(p, [pt(x, y), pt(x, y + 150)], weight: 1.8,
                            colour: Field.sepia.al(0.30), wobble: 0.4, taper: false,
                            seed: seed &+ bits(Int(x) + 3))
                        x += 18
                    }
                default:
                    var cx = 200.0
                    while cx < 1300 {
                        for r in stride(from: 120.0, through: 460.0, by: 26.0) {
                            var arc: [CGPoint] = []
                            for i in 0...20 {
                                let a = -0.9 + Double(i) / 20 * 1.8
                                arc.append(pt(cx + sin(a) * r, y + 75 - cos(a) * r + r))
                            }
                            pen(p, arc, weight: 1.8, colour: Field.sepia.al(0.26),
                                wobble: 0.5, taper: false, seed: seed &+ bits(Int(r + cx)))
                        }
                        cx += 460
                    }
                }
            }
            caption(p, ["pit saw: straight, irregular, before 1800",
                        "frame saw: straight and very even, 1780 to 1850",
                        "circular saw: arcs, after about 1830"][k],
                    at: 230, y + 180, size: 23, colour: k == 2 ? Field.oxblood : Field.inkSoft,
                    face: k == 2 ? "Georgia-Bold" : "Georgia-Italic", align: .left)
        }
    case "shrinkage":
        drawGrid(p, stage, step: 45, seed: seed &+ 3)
        for k in 0..<2 {
            let cx = 420.0 + Double(k) * 470
            let squash = k == 0 ? 1.0 : 0.93
            let circle = ringPoints(cx: cx, cy: 460, rx: 190, ry: 190 * squash, steps: 60)
            woodFill(p, circle, tone: Field.mahogany, seed: seed &+ bits(k))
            if k == 1 {
                p.ctx.setStrokeColor(cg(Field.oxblood.al(0.7)))
                p.ctx.setLineWidth(2)
                p.ctx.setLineDash(phase: 0, lengths: [7, 7])
                p.ctx.strokeEllipse(in: CGRect(x: cx - 190, y: 460 - 190, width: 380, height: 380))
                p.ctx.setLineDash(phase: 0, lengths: [])
                pen(p, [pt(cx - 210, 690), pt(cx + 210, 690)], weight: 2,
                    colour: Field.inkSoft, wobble: 0.3, taper: false, seed: seed &+ 21)
                caption(p, "4 mm less across the grain", at: cx, 726, size: 22,
                        colour: Field.oxblood, face: "Georgia-Bold")
            }
            caption(p, k == 0 ? "turned round in 1770" : "measured today", at: cx, 200,
                    size: 24, colour: Field.inkSoft, face: "Georgia-Italic")
        }
    case "screws":
        drawGrid(p, stage, step: 45, seed: seed &+ 3)
        let labels = ["hand made, before 1780", "machine thread, blunt end, 1780 to 1850",
                      "gimlet point, after 1850"]
        for k in 0..<3 {
            let y = 280.0 + Double(k) * 180
            p.disc(320, y, 46, Field.steel.dk(0.10))
            p.ring(320, y, 46, 2, Field.ironDark)
            let slotA = k == 0 ? -0.30 : 0.0
            pen(p, [pt(320 - cos(slotA) * 40 + (k == 0 ? 6 : 0),
                       y - sin(slotA) * 40 + (k == 0 ? 4 : 0)),
                    pt(320 + cos(slotA) * 40 + (k == 0 ? 6 : 0),
                       y + sin(slotA) * 40 + (k == 0 ? 4 : 0))],
                weight: 8, colour: Field.ironDark, wobble: k == 0 ? 1.6 : 0, taper: false,
                seed: seed &+ bits(k))
            let shankLen = 240.0
            p.poly([pt(366, y - 22), pt(366 + shankLen, y - (k == 2 ? 4 : 14)),
                    pt(366 + shankLen, y + (k == 2 ? 4 : 14)), pt(366, y + 22)],
                   Field.steel.dk(0.06))
            var tx = 380.0
            while tx < 366 + shankLen - 10 {
                let step = k == 0 ? rng.r(20, 34) : 24
                pen(p, [pt(tx, y - 20), pt(tx + 10, y + 20)], weight: 2.4,
                    colour: Field.ironDark.al(0.6), wobble: 0, taper: false, seed: seed &+ bits(Int(tx)))
                tx += step
            }
            if k == 2 {
                p.poly([pt(366 + shankLen, y - 4), pt(366 + shankLen + 34, y),
                        pt(366 + shankLen, y + 4)], Field.steel.dk(0.06))
            }
            caption(p, labels[k], at: 700, y + 60, size: 23,
                    colour: k == 2 ? Field.oxblood : Field.inkSoft,
                    face: k == 2 ? "Georgia-Bold" : "Georgia-Italic", align: .left)
        }
    case "patina":
        drawGrid(p, stage, step: 45, seed: seed &+ 3)
        let arm = rectPts(240, 340, 860, 120)
        woodFill(p, arm, tone: Field.mahogany, seed: seed &+ 31)
        p.clip(pathOf(arm)) {
            for _ in 0..<600 {
                let x = 240 + rng.d() * 860
                let d = abs(x - 700) / 460
                p.disc(x, 340 + rng.d() * 120, rng.r(1, 5),
                       Field.patina.al((1 - d) * rng.r(0.05, 0.30)))
            }
            if let g = CGGradient(colorsSpace: rgbSpace,
                                  colors: [cg(Field.bareWood.al(0.55)), cg(Field.bareWood.al(0))] as CFArray,
                                  locations: [0, 1]) {
                p.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 700, y: 400), startRadius: 0,
                                         endCenter: CGPoint(x: 700, y: 400), endRadius: 220, options: [])
            }
        }
        caption(p, "worn to bare wood where hands grip", at: 700, 300, size: 24,
                colour: Field.oxblood, face: "Georgia-Bold")
        caption(p, "wax and dirt built up at the ends", at: 300, 510, size: 22,
                colour: Field.sepia, face: "Georgia-Italic", align: .left)
        let mould = rectPts(240, 600, 860, 110)
        woodFill(p, mould, tone: Field.walnut, seed: seed &+ 33)
        p.clip(pathOf(mould)) {
            for k in 0..<5 {
                let y = 600.0 + Double(k) * 22
                p.rect(240, y, 860, 8, Field.patina.al(0.30 + Double(k) * 0.08))
            }
        }
        caption(p, "dirt collects in every quirk of a moulding", at: 700, 740, size: 22,
                colour: Field.sepia, face: "Georgia-Italic")
    case "timber":
        drawGrid(p, stage, step: 45, seed: seed &+ 3)
        let woods: [(String, Tone, String)] = [("Oak", Field.oak, "to 1670"),
                                               ("Walnut", Field.walnut, "1670 to 1730"),
                                               ("Mahogany", Field.mahogany, "1730 onward"),
                                               ("Rosewood", Field.mahogany.dk(0.14), "Regency"),
                                               ("Satinwood", Field.satinwood, "Regency"),
                                               ("Pine", Field.pine, "always, painted")]
        for (k, wdd) in woods.enumerated() {
            let col = k % 3, row = k / 3
            let x = 210.0 + Double(col) * 330
            let y = 250.0 + Double(row) * 270
            woodFill(p, rectPts(x, y, 280, 180), tone: wdd.1, seed: seed &+ bits(k))
            caption(p, wdd.0, at: x + 140, y + 214, size: 26, colour: Field.ink, face: "Georgia-Bold")
            caption(p, wdd.2, at: x + 140, y + 244, size: 21, colour: Field.sepia,
                    face: "Georgia-Italic")
        }
    case "veneer":
        drawGrid(p, stage, step: 45, seed: seed &+ 3)
        for k in 0..<2 {
            let y = 280.0 + Double(k) * 250
            woodFill(p, rectPts(260, y + 40, 820, 110), tone: Field.pine, seed: seed &+ bits(k))
            let vt = k == 0 ? 26.0 : 6.0
            woodFill(p, rectPts(260, y + 40 - vt, 820, vt), tone: Field.walnut,
                     seed: seed &+ bits(k + 5))
            caption(p, k == 0 ? "saw cut, nearly two millimetres, before 1830"
                              : "knife cut, half a millimetre, after 1830",
                    at: 260, y + 200, size: 23, colour: k == 0 ? Field.oxblood : Field.inkSoft,
                    face: k == 0 ? "Georgia-Bold" : "Georgia-Italic", align: .left)
            caption(p, "groundwork", at: 1120, y + 100, size: 20, colour: Field.sepia,
                    face: "Georgia-Italic", align: .right)
        }
    case "handles":
        drawGrid(p, stage, step: 45, seed: seed &+ 3)
        let styles = ["Brass drop", "Brass swan neck", "Turned wooden knob", "Iron"]
        let dates = ["to 1710", "1740 to 1790", "1820 to 1870", "before 1700"]
        for k in 0..<4 {
            let x = 300.0 + Double(k % 2) * 500
            let y = 320.0 + Double(k / 2) * 260
            woodFill(p, rectPts(x - 150, y - 80, 300, 160), tone: Field.mahogany,
                     seed: seed &+ bits(k))
            drawHandle(p, styles[k], x: x, y: y, s: 70, seed: seed &+ bits(k * 3))
            caption(p, styles[k], at: x, y + 120, size: 23, colour: Field.ink, face: "Georgia-Bold")
            caption(p, dates[k], at: x, y + 150, size: 21, colour: Field.sepia,
                    face: "Georgia-Italic")
        }
    case "backboards":
        for k in 0..<3 {
            let y = 220.0 + Double(k) * 200
            let boards = [3, 4, 7][k]
            for b in 0..<boards {
                let bw = 880.0 / Double(boards)
                let jitter = k == 0 ? rng.r(-8, 8) : 0
                woodFill(p, rectPts(230 + Double(b) * bw + jitter, y,
                                    bw - (k == 0 ? 10 : 4), 150),
                         tone: k == 0 ? Field.oak : Field.pine, seed: seed &+ bits(k * 9 + b))
                for n in 0..<3 {
                    p.disc(230 + Double(b) * bw + bw / 2 + jitter, y + 26 + Double(n) * 50,
                           5, Field.ironDark)
                }
            }
            caption(p, ["riven oak, irregular, nailed: 1600s",
                        "wide sawn pine, gaps opened: 1700s",
                        "thin machined boards: 1800s"][k],
                    at: 230, y + 178, size: 23, colour: Field.inkSoft,
                    face: "Georgia-Italic", align: .left)
        }
    case "finish":
        drawGrid(p, stage, step: 45, seed: seed &+ 3)
        let names = ["Wax over bare wood", "French polish", "Cellulose", "Modern lacquer"]
        for k in 0..<4 {
            let x = 250.0 + Double(k % 2) * 480
            let y = 300.0 + Double(k / 2) * 260
            woodFill(p, rectPts(x - 160, y - 80, 320, 160), tone: Field.walnut,
                     seed: seed &+ bits(k))
            p.clip(pathOf(rectPts(x - 160, y - 80, 320, 160))) {
                switch k {
                case 0:
                    for _ in 0..<300 {
                        p.disc(x - 160 + rng.d() * 320, y - 80 + rng.d() * 160,
                               rng.r(1, 4), Field.patina.al(rng.r(0.05, 0.20)))
                    }
                case 1:
                    if let g = CGGradient(colorsSpace: rgbSpace,
                                          colors: [cg(Field.bone.al(0.42)), cg(Field.bone.al(0))] as CFArray,
                                          locations: [0, 1]) {
                        p.ctx.drawRadialGradient(g, startCenter: CGPoint(x: x - 60, y: y - 30),
                                                 startRadius: 0,
                                                 endCenter: CGPoint(x: x - 60, y: y - 30),
                                                 endRadius: 160, options: [])
                    }
                case 2:
                    for _ in 0..<180 {
                        let cx2 = x - 160 + rng.d() * 320, cy2 = y - 80 + rng.d() * 160
                        pen(p, [pt(cx2, cy2), pt(cx2 + rng.r(-18, 18), cy2 + rng.r(-18, 18))],
                            weight: 1.0, colour: Field.bone.al(0.34), wobble: 0.4, taper: false,
                            seed: seed &+ bits(Int(cx2)))
                    }
                default:
                    p.rect(x - 160, y - 80, 320, 160, Field.bone.al(0.12))
                    if let g = CGGradient(colorsSpace: rgbSpace,
                                          colors: [cg(Field.bone.al(0.55)), cg(Field.bone.al(0))] as CFArray,
                                          locations: [0, 1]) {
                        p.ctx.drawLinearGradient(g, start: CGPoint(x: x - 160, y: y - 80),
                                                 end: CGPoint(x: x + 160, y: y + 80), options: [])
                    }
                }
            }
            caption(p, names[k], at: x, y + 118, size: 23, colour: Field.ink, face: "Georgia-Bold")
        }
    case "construction":
        drawGrid(p, stage, step: 45, seed: seed &+ 3)
        for k in 0..<2 {
            let x = 300.0 + Double(k) * 520
            woodFill(p, rectPts(x - 170, 260, 120, 400), tone: Field.oak, seed: seed &+ bits(k))
            woodFill(p, rectPts(x - 50, 320, 300, 110), tone: Field.oak.lt(0.05),
                     seed: seed &+ bits(k + 5))
            if k == 0 {
                for n in 0..<2 {
                    p.disc(x - 110, 350 + Double(n) * 60, 13, Field.oakDark)
                    p.ring(x - 110, 350 + Double(n) * 60, 13, 2, Field.ink.al(0.6))
                }
                caption(p, "pegged, no glue", at: x + 30, 700, size: 23, colour: Field.oxblood,
                        face: "Georgia-Bold")
            } else {
                drawDovetails(p, x: x - 170, y: 470, w: 300, h: 160, count: 4,
                              narrowPins: true, seed: seed &+ 45)
                caption(p, "dovetailed and glued", at: x + 30, 700, size: 23,
                        colour: Field.inkSoft, face: "Georgia-Italic")
            }
        }
    case "proportion":
        drawGrid(p, stage, step: 45, seed: seed &+ 3)
        for k in 0..<4 {
            let x = 260.0 + Double(k) * 260
            let h = 420.0 - Double(k) * 44
            woodFill(p, rectPts(x - 90, 700 - h, 180, h), tone: Field.mahogany.lt(Double(k) * 0.02),
                     seed: seed &+ bits(k))
            var y = 700.0 - h + 20
            for d in 0..<4 {
                let dh = (h - 60) / 4 * (0.82 + Double(d) * 0.12)
                p.rect(x - 78, y, 156, dh - 8, Field.mahogany.lt(0.06))
                penContour(p, rectPts(x - 78, y, 156, dh - 8), weight: 1.4,
                           colour: Field.ink.al(0.5), seed: seed &+ bits(d))
                y += dh
            }
            caption(p, ["1700", "1760", "1820", "1880"][k], at: x, 740, size: 23,
                    colour: Field.inkSoft, face: "Georgia-Bold")
        }
        caption(p, "lower, and the drawers graduate differently", at: 675, 790, size: 23,
                colour: Field.sepia, face: "Georgia-Italic")
    case "marriage":
        drawGrid(p, stage, step: 45, seed: seed &+ 3)
        woodFill(p, rectPts(380, 230, 580, 210), tone: Field.oak, seed: seed &+ 51)
        woodFill(p, rectPts(340, 450, 660, 300), tone: Field.walnut, seed: seed &+ 53)
        pen(p, [pt(320, 445), pt(1020, 445)], weight: 3, colour: Field.oxblood,
            wobble: 1, taper: false, seed: seed &+ 55)
        caption(p, "different timber, different colour, mouldings do not run through",
                at: 675, 800, size: 23, colour: Field.oxblood, face: "Georgia-Bold")
        caption(p, "top: oak, 1690", at: 1000, 300, size: 22, colour: Field.sepia,
                face: "Georgia-Italic", align: .left)
        caption(p, "base: walnut, 1740", at: 1000, 560, size: 22, colour: Field.sepia,
                face: "Georgia-Italic", align: .left)
    default:
        drawGrid(p, stage, step: 45, seed: seed &+ 3)
        drawDovetails(p, x: 220, y: 260, w: 400, h: 200, count: 3, narrowPins: true, seed: seed &+ 61)
        woodFill(p, rectPts(720, 260, 400, 200), tone: Field.pine, seed: seed &+ 63)
        p.clip(pathOf(rectPts(720, 260, 400, 200))) {
            var cx = 700.0
            while cx < 1300 {
                for r in stride(from: 120.0, through: 400.0, by: 26.0) {
                    var arc: [CGPoint] = []
                    for i in 0...20 {
                        let a = -0.9 + Double(i) / 20 * 1.8
                        arc.append(pt(cx + sin(a) * r, 335 - cos(a) * r + r))
                    }
                    pen(p, arc, weight: 1.8, colour: Field.sepia.al(0.28), wobble: 0.5,
                        taper: false, seed: seed &+ bits(Int(r + cx)))
                }
                cx += 460
            }
        }
        caption(p, "hand cut dovetails", at: 420, 500, size: 24, colour: Field.inkSoft,
                face: "Georgia-Italic")
        caption(p, "circular sawn backboard", at: 920, 500, size: 24, colour: Field.oxblood,
                face: "Georgia-Bold")
        caption(p, "one of these two is lying", at: 675, 700, size: 30, colour: Field.oxblood,
                face: "Georgia-Bold")
    }

    caption(p, spec.kicker.uppercased(), at: 130, 118, size: 20, colour: Field.oxblood,
            face: "Georgia-Bold", align: .left, tracking: 3.4)
    caption(p, spec.title, at: 130, 892, size: 46, colour: Field.ink, face: "Georgia-Bold", align: .left)
    caption(p, spec.sub, at: 130, 932, size: 25, colour: Field.inkPale,
            face: "Georgia-Italic", align: .left)
    pen(p, [pt(130, 962), pt(1220, 962)], weight: 1.6, colour: Field.inkPale.al(0.6),
        wobble: 0.5, taper: false, seed: seed &+ 61)

    var ty = 1014.0
    for note in spec.notes {
        caption(p, note.0.uppercased(), at: 130, ty, size: 19, colour: Field.sepia,
                face: "Georgia-Bold", align: .left, tracking: 2.6)
        ty += 32
        for line in wrapText(note.1, width: 1090, size: 23) {
            caption(p, line, at: 130, ty, size: 23, colour: Field.inkSoft, face: "Georgia", align: .left)
            ty += 29
        }
        ty += 14
    }

    plateFrame(p, inset: 46, seed: seed &+ 99)
    p.write(dir, "guide_" + spec.id, quality: 0.92)
}
