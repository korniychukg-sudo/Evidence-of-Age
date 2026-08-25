import SwiftUI

struct Principal: Identifiable {
    let slug: String
    let name: String
    let trade: String
    let temper: String
    let opens: Int
    var id: String { slug }
}

let principalBook: [Principal] = [
    Principal(slug: "houseclear", name: "Bregg House Clearance", trade: "van loads, no questions",
              temper: "Wants a rough century on anything with legs so the van can move today.",
              opens: 0),
    Principal(slug: "saleroom", name: "The Saleroom", trade: "weekly general sale",
              temper: "Needs a catalogue line by Thursday and does not enjoy being wrong in print.",
              opens: 0),
    Principal(slug: "insurer", name: "Cawdrey & Finch", trade: "insurance valuers",
              temper: "Pays for a bracket they can defend in writing, and audits the ones they cannot.",
              opens: 28),
    Principal(slug: "heir", name: "The Executor", trade: "settling an estate",
              temper: "Two brothers are arguing over a table. Whatever you write ends the argument.",
              opens: 58),
    Principal(slug: "dealer", name: "Marchmont of Bury", trade: "trade buyer",
              temper: "Buying to resell, so he wants the evidence listed, not just the answer.",
              opens: 92),
    Principal(slug: "museum", name: "The County Museum", trade: "accessioning",
              temper: "Everything goes on a record card that outlives everyone in this room.",
              opens: 132),
    Principal(slug: "court", name: "Instructed by Solicitors", trade: "a disputed sale",
              temper: "This one is going in front of a judge. A wide bracket is no use to anybody.",
              opens: 176),
    Principal(slug: "board", name: "The Valuers' Board", trade: "sets the qualification",
              temper: "Three pieces, tight brackets, all the evidence found. It is how they admit you.",
              opens: 228),
]

func principalBySlug(_ s: String) -> Principal { principalBook.first { $0.slug == s } ?? principalBook[0] }

struct Consignment: Codable, Identifiable {
    var id: String
    var principal: String
    var issued: Date
    var days: Int
    var pay: Int
    var rep: Int
    var title: String
    var line: String
    var piece: String?
    var period: String?
    var maxSpan: Int?
    var minFound: Int?
    var mustBeInside: Bool
    var count: Int
    var done_: Int
    var taken: Bool
    var done: Bool

    var due: Date { Calendar.current.date(byAdding: .day, value: days, to: issued) ?? issued }

    func daysLeft(_ now: Date) -> Int {
        let a = Calendar.current.startOfDay(for: now)
        let b = Calendar.current.startOfDay(for: due)
        return Calendar.current.dateComponents([.day], from: a, to: b).day ?? 0
    }

    var demands: [String] {
        var out: [String] = []
        if let p = piece, let e = Pieces.piece(p) { out.append(e.name) }
        else if let per = period { out.append("anything \(per)") }
        if let s = maxSpan { out.append("a bracket no wider than \(s) years") }
        if let f = minFound { out.append("\(f) pieces of evidence found") }
        if mustBeInside { out.append("the true date inside the bracket") }
        if count > 1 { out.append("\(count) lots") }
        if out.isEmpty { out.append("a century will do") }
        return out
    }
}

func datingMatches(_ c: Consignment, dating: Dating) -> Bool {
    let piece = dating.piece
    if let p = c.piece, p != dating.pieceID { return false }
    if let per = c.period, piece.period != per { return false }
    if let s = c.maxSpan, dating.to - dating.from > s { return false }
    if let f = c.minFound, dating.found < f { return false }
    if c.mustBeInside && !dating.inside { return false }
    return true
}

func datingMissedBy(_ c: Consignment, dating: Dating) -> String? {
    let piece = dating.piece
    if let p = c.piece, p != dating.pieceID {
        return "wanted the \(Pieces.piece(p)?.name ?? p)"
    }
    if let per = c.period, piece.period != per { return "wanted something \(per)" }
    if let s = c.maxSpan, dating.to - dating.from > s {
        return "bracket \(dating.to - dating.from) years wide, they will take \(s)"
    }
    if let f = c.minFound, dating.found < f {
        return "\(dating.found) findings, they wanted \(f)"
    }
    if c.mustBeInside && !dating.inside { return "the true date fell outside your bracket" }
    return nil
}

func makeConsignment(_ pr: Principal, seed: DaySeed, salt: UInt64, now: Date, level: Int) -> Consignment {
    var rng = Seeded(seed.value &+ salt &* 2654435761 &+ hashString(pr.slug))
    var days = 4 + Int(rng.d() * 8)
    var extras = 0
    var count = 1
    var pieceID: String? = nil
    var period: String? = nil
    var maxSpan: Int? = nil
    var minFound: Int? = nil
    var inside = false

    let pool: [PieceEntry]
    switch pr.slug {
    case "houseclear":
        pool = Pieces.all.filter { $0.difficulty <= 2 }
        days = 2 + Int(rng.d() * 4)
        maxSpan = 120
    case "saleroom":
        pool = Pieces.all.filter { $0.difficulty <= 3 }
        maxSpan = 80
        inside = true
        extras += 1
    case "insurer":
        pool = Pieces.all
        maxSpan = 60
        inside = true
        minFound = 3
        extras += 2
    case "heir":
        pool = Pieces.all
        maxSpan = 50
        inside = true
        extras += 2
    case "dealer":
        pool = Pieces.all
        minFound = 4
        maxSpan = 55
        inside = true
        extras += 3
        days = 6 + Int(rng.d() * 6)
    case "museum":
        pool = Pieces.all.filter { $0.difficulty >= 2 }
        minFound = 4
        maxSpan = 40
        inside = true
        extras += 3
        days = 7 + Int(rng.d() * 7)
    case "court":
        pool = Pieces.all.filter { $0.difficulty >= 3 }
        maxSpan = 30
        minFound = 4
        inside = true
        extras += 4
        days = 8 + Int(rng.d() * 8)
    default:
        pool = Pieces.all.filter { $0.difficulty >= 3 }
        count = 3
        maxSpan = 35
        minFound = 4
        inside = true
        extras += 5
        days = 12 + Int(rng.d() * 10)
    }

    let picked = pool.isEmpty ? Pieces.all[Int(rng.d() * Double(Pieces.all.count)) % Pieces.all.count]
                              : pool[Int(rng.d() * Double(pool.count)) % pool.count]
    if pr.slug == "heir" || pr.slug == "court" || rng.chance(0.36) {
        pieceID = picked.id
    } else if rng.chance(0.5) {
        period = picked.period
    }
    if level >= 3, let s = maxSpan { maxSpan = max(20, s - 8) }

    let pay = (60 + picked.difficulty * 24 + extras * 30 + max(0, 8 - days) * 8) * count
    return Consignment(id: "\(pr.slug)-\(ageDayKey(now))-\(salt)", principal: pr.slug, issued: now,
                       days: days, pay: pay, rep: 8 + extras * 4,
                       title: consignTitle(pr.slug, picked, &rng),
                       line: consignLine(pr.slug, picked, count),
                       piece: pieceID, period: period, maxSpan: maxSpan, minFound: minFound,
                       mustBeInside: inside, count: count, done_: 0, taken: false, done: false)
}

private func consignTitle(_ slug: String, _ p: PieceEntry, _ rng: inout Seeded) -> String {
    switch slug {
    case "houseclear": return rng.chance(0.5) ? "The van is waiting" : "Rough century on the lot"
    case "saleroom": return "A catalogue line by Thursday"
    case "insurer": return "A bracket we can defend"
    case "heir": return "Two brothers and one table"
    case "dealer": return "List the evidence, not just the answer"
    case "museum": return "For the accession card"
    case "court": return "Instructed by solicitors"
    default: return "The board examination"
    }
}

private func consignLine(_ slug: String, _ p: PieceEntry, _ count: Int) -> String {
    switch slug {
    case "houseclear":
        return "I do not need the century to the year. I need it before the van has to move."
    case "saleroom":
        return "It goes in print with my name at the bottom of the page. Do not make me wrong in public."
    case "insurer":
        return "We pay out against what you write. If we cannot defend the bracket, we audit you instead."
    case "heir":
        return "The \(p.name). Whatever you put on paper settles it, so make the bracket narrow enough to mean something."
    case "dealer":
        return "I am buying to sell on. Tell me what you found, not just what you concluded."
    case "museum":
        return "This goes on a record card that will outlast everyone in this room. Be sure."
    case "court":
        return "A judge reads this. A hundred year bracket is the same as saying you do not know."
    default:
        return "\(count) lots, tight brackets, every finding on every one. This is the piece they admit you on."
    }
}

func ageDayKey(_ d: Date) -> String {
    let c = Calendar.current.dateComponents([.year, .month, .day], from: d)
    return String(format: "%04d-%02d-%02d", c.year ?? 0, c.month ?? 0, c.day ?? 0)
}

func rollConsignments(_ repTotal: Int, level: Int, now: Date) -> [Consignment] {
    let seed = DaySeed(now, salt: 0xA6E)
    let open = principalBook.filter { $0.opens <= repTotal }
    var out: [Consignment] = []
    let count = min(open.count, 2 + min(2, repTotal / 80))
    for i in 0..<count {
        let pr = open[(Int(seed.value % UInt64(max(1, open.count))) + i * 3) % open.count]
        if out.contains(where: { $0.principal == pr.slug }) { continue }
        out.append(makeConsignment(pr, seed: seed, salt: UInt64(i), now: now, level: level))
    }
    if out.isEmpty, let f = open.first {
        out.append(makeConsignment(f, seed: seed, salt: 9, now: now, level: level))
    }
    return out
}
