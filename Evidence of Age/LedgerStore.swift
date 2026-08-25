import SwiftUI

struct Dating: Codable, Identifiable {
    var id: UUID = UUID()
    var pieceID: String
    var date: Date
    var from: Int
    var to: Int
    var found: Int
    var score: Double
    var inside: Bool

    var piece: PieceEntry { Pieces.piece(pieceID) ?? Pieces.all[0] }
    var stars: Int {
        if score >= 0.86 { return 3 }
        if score >= 0.66 { return 2 }
        return 1
    }
}

enum JobKind: String { case dateAny, dateTight, findAll, readPlates, datePeriod }

struct DailyJob {
    let kind: JobKind
    let target: Int
    let title: String
    let detail: String
    let reward: Int
    let period: String?

    static func of(_ date: Date) -> DailyJob {
        let s = DaySeed(date, salt: 7717)
        switch s.int(0, 4, 11) {
        case 0:
            return DailyJob(kind: .dateAny, target: 2, title: "Two lots catalogued",
                            detail: "Date two pieces before the viewing opens. Any two.",
                            reward: 70, period: nil)
        case 1:
            return DailyJob(kind: .dateTight, target: 1, title: "A bracket under forty years",
                            detail: "One piece dated to a range you would put in a catalogue.",
                            reward: 90, period: nil)
        case 2:
            return DailyJob(kind: .findAll, target: 1, title: "Every mark on one piece",
                            detail: "Find all four pieces of evidence before you commit to a bracket.",
                            reward: 85, period: nil)
        case 3:
            return DailyJob(kind: .readPlates, target: 3, title: "Three plates from the book",
                            detail: "Read three entries. Dating is mostly knowing what to look for.",
                            reward: 50, period: nil)
        default:
            let p = s.pick(["Georgian", "Victorian", "Regency", "Jacobean"], 13)
            return DailyJob(kind: .datePeriod, target: 1, title: "Something \(p.lowercased())",
                            detail: "The client wants a \(p.lowercased()) piece looked at today.",
                            reward: 80, period: p)
        }
    }
}

struct Badge: Identifiable {
    let id: String
    let name: String
    let note: String
}

enum Badges {
    static let all: [Badge] = a + b + c
    private static let a: [Badge] = [
        Badge(id: "first", name: "First Lot", note: "Date a piece and commit to a bracket."),
        Badge(id: "allfour", name: "Every Mark", note: "Find all four pieces of evidence on one piece."),
        Badge(id: "tight", name: "Tight Bracket", note: "Date a piece to within twenty five years and be right."),
        Badge(id: "tenlots", name: "Ten Lots", note: "Ten pieces catalogued."),
        Badge(id: "threestar", name: "Three Stars", note: "A dating that grades three stars."),
        Badge(id: "dovetail", name: "Read the Pins", note: "Read a dovetail correctly.")
    ]
    private static let b: [Badge] = [
        Badge(id: "saw", name: "Read the Saw", note: "Identify a saw mark correctly."),
        Badge(id: "screw", name: "Read the Screw", note: "Date a fixing correctly."),
        Badge(id: "century17", name: "Seventeenth Century", note: "Date a piece made before 1700."),
        Badge(id: "century20", name: "Twentieth Century", note: "Date a piece made after 1900."),
        Badge(id: "allpieces", name: "The Whole Sale", note: "Catalogue every piece in the book."),
        Badge(id: "streak", name: "Five in a Row", note: "Five consecutive datings with the true date inside.")
    ]
    private static let c: [Badge] = [
        Badge(id: "week", name: "Seven Days", note: "Come to the saleroom seven days running."),
        Badge(id: "quiz", name: "Passed the Board", note: "Answer twelve quiz questions in a row."),
        Badge(id: "plates", name: "Well Read", note: "Read thirty plates in the book."),
        Badge(id: "consultant", name: "Consultant", note: "Reach the last rank."),
        Badge(id: "perfect", name: "Textbook", note: "Score above ninety on a dating."),
        Badge(id: "timeline", name: "The Long View", note: "Walk the whole timeline from 1600 to 1960.")
    ]
    static func badge(_ id: String) -> Badge? { all.first { $0.id == id } }
}

struct LedgerState: Codable {
    var xp: Int = 0
    var streak: Int = 0
    var bestStreak: Int = 0
    var lastDay: String = ""
    var badges: [String] = []
    var seen: [String] = []
    var datings: [Dating] = []
    var rightRun: Int = 0
    var bestRun: Int = 0
    var quizBest: Int = 0
    var quizStreakBest: Int = 0
    var jobDay: String = ""
    var jobDated: Int = 0
    var jobTight: Int = 0
    var jobFull: Int = 0
    var jobReads: Int = 0
    var jobPeriods: [String] = []
    var jobClaimed: Bool = false
    var introSeen: Bool = false
    var money: Int = 90
    var tools: [String] = []
    var principalRep: [String: Int] = [:]
    var board: [Consignment] = []
    var boardDay: String = ""
    var taken: [Consignment] = []
    var filled: Int = 0
    var missed: Int = 0
    var earned: Int = 0
    var lastResult: String = ""

    var repTotal: Int { principalRep.values.reduce(0, +) }
}

final class LedgerStore: ObservableObject {
    @Published var state = LedgerState()
    @Published var lastBadge: Badge?
    @Published var lastConsignment: Consignment?
    @Published var lastConsignmentMiss: String?
    private let key = "evidence.of.age.state.v1"

    init() {
        load()
        rollDay()
    }

    func load() {
        defer { syncKit() }
        guard let d = UserDefaults.standard.data(forKey: key),
              let s = try? JSONDecoder().decode(LedgerState.self, from: d) else { return }
        state = s
    }
    func saveNow() {
        syncKit()
        guard let d = try? JSONEncoder().encode(state) else { return }
        UserDefaults.standard.set(d, forKey: key)
    }

    var kit: DeskKit { DeskKit(owned: state.tools) }

    func syncKit() { ActiveDeskKit.current = kit }

    func refreshBoard(_ now: Date = Date()) {
        let today = dayKey(now)
        var changed = false
        var still: [Consignment] = []
        for c in state.taken {
            if c.done { continue }
            if c.daysLeft(now) < 0 {
                state.missed += 1
                state.principalRep[c.principal] = max(0, (state.principalRep[c.principal] ?? 0) - 12)
                state.lastResult = "\(principalBySlug(c.principal).name) took it elsewhere."
                changed = true
            } else {
                still.append(c)
            }
        }
        if still.count != state.taken.count { state.taken = still }
        if state.boardDay != today {
            state.boardDay = today
            let busy = Set(state.taken.map { $0.principal })
            state.board = rollConsignments(state.repTotal, level: DealerRank.level(state.xp), now: now)
                .filter { !busy.contains($0.principal) }
            changed = true
        }
        if changed { saveNow() }
    }

    func takeConsignment(_ c: Consignment) {
        guard !state.taken.contains(where: { $0.id == c.id }) else { return }
        var copy = c
        copy.taken = true
        state.taken.append(copy)
        state.board.removeAll { $0.id == c.id }
        saveNow()
    }

    func dropConsignment(_ c: Consignment) {
        state.taken.removeAll { $0.id == c.id }
        state.principalRep[c.principal] = max(0, (state.principalRep[c.principal] ?? 0) - 5)
        saveNow()
    }

    @discardableResult
    func settle(_ d: Dating) -> Consignment? {
        for i in state.taken.indices where !state.taken[i].done {
            let c = state.taken[i]
            guard datingMatches(c, dating: d) else { continue }
            state.taken[i].done_ += 1
            if state.taken[i].done_ >= c.count {
                state.taken[i].done = true
                state.money += c.pay
                state.earned += c.pay
                state.filled += 1
                state.principalRep[c.principal] = (state.principalRep[c.principal] ?? 0) + c.rep
                state.lastResult = "\(principalBySlug(c.principal).name) paid \(c.pay)."
                addXP(c.pay)
                let done = state.taken[i]
                state.taken.removeAll { $0.id == c.id }
                saveNow()
                return done
            }
            saveNow()
            return state.taken.first { $0.id == c.id }
        }
        return nil
    }

    func buyTool(_ t: DeskTool) {
        guard state.money >= t.price, !state.tools.contains(t.slug) else { return }
        state.money -= t.price
        state.tools.append(t.slug)
        saveNow()
    }

    func rollDay(_ now: Date = Date()) {
        refreshBoard(now)
        let today = dayKey(now)
        if state.lastDay != today {
            if let prev = Calendar.current.date(byAdding: .day, value: -1, to: now),
               dayKey(prev) == state.lastDay { state.streak += 1 } else { state.streak = 1 }
            state.bestStreak = max(state.bestStreak, state.streak)
            state.lastDay = today
            if state.streak >= 7 { award("week") }
            saveNow()
        }
        if state.jobDay != today {
            state.jobDay = today
            state.jobDated = 0
            state.jobTight = 0
            state.jobFull = 0
            state.jobReads = 0
            state.jobPeriods = []
            state.jobClaimed = false
            saveNow()
        }
    }

    var todayJob: DailyJob { DailyJob.of(Date()) }
    var todayLot: PieceEntry {
        let s = DaySeed(Date(), salt: 4441)
        return s.pick(Pieces.all, 3)
    }

    func jobProgress() -> (Int, Int) {
        let j = todayJob
        switch j.kind {
        case .dateAny: return (min(state.jobDated, j.target), j.target)
        case .dateTight: return (min(state.jobTight, j.target), j.target)
        case .findAll: return (min(state.jobFull, j.target), j.target)
        case .readPlates: return (min(state.jobReads, j.target), j.target)
        case .datePeriod:
            let hit = state.jobPeriods.filter { $0 == (j.period ?? "") }.count
            return (min(hit, j.target), j.target)
        }
    }
    var jobComplete: Bool { let (a, b) = jobProgress(); return a >= b }
    func claimJob() {
        guard jobComplete, !state.jobClaimed else { return }
        state.jobClaimed = true
        addXP(todayJob.reward)
    }

    func addXP(_ n: Int) {
        state.xp += n
        if DealerRank.level(state.xp) >= DealerRank.names.count - 1 { award("consultant") }
        saveNow()
    }
    func award(_ id: String) {
        guard !state.badges.contains(id), Badges.badge(id) != nil else { return }
        state.badges.append(id)
        lastBadge = Badges.badge(id)
        state.xp += 40
        saveNow()
    }
    func hasBadge(_ id: String) -> Bool { state.badges.contains(id) }

    func markSeen(_ id: String) {
        guard !state.seen.contains(id) else { return }
        state.seen.append(id)
        state.jobReads += 1
        state.xp += 6
        if state.seen.count >= 30 { award("plates") }
        saveNow()
    }

    func file(_ d: Dating) {
        lastConsignment = settle(d)
        if lastConsignment == nil {
            lastConsignmentMiss = state.taken.compactMap { datingMissedBy($0, dating: d) }.first
        } else {
            lastConsignmentMiss = nil
        }
        state.money += 14 + Int(d.score * 40)
        state.datings.insert(d, at: 0)
        state.jobDated += 1
        if d.inside && (d.to - d.from) <= 40 { state.jobTight += 1 }
        if d.found >= 4 { state.jobFull += 1; award("allfour") }
        state.jobPeriods.append(d.piece.period)
        award("first")
        if d.inside && (d.to - d.from) <= 25 { award("tight") }
        if d.stars == 3 { award("threestar") }
        if d.score >= 0.90 { award("perfect") }
        if d.piece.year < 1700 { award("century17") }
        if d.piece.year > 1900 { award("century20") }
        if state.datings.count >= 10 { award("tenlots") }
        if Set(state.datings.map { $0.pieceID }).count >= Pieces.all.count { award("allpieces") }
        if d.inside {
            state.rightRun += 1
            state.bestRun = max(state.bestRun, state.rightRun)
            if state.rightRun >= 5 { award("streak") }
        } else {
            state.rightRun = 0
        }
        addXP(50 + Int(d.score * 150))
    }

    func unlocked(_ p: PieceEntry) -> Bool { DealerRank.level(state.xp) >= p.unlockLevel }
    func bestFor(_ id: String) -> Double { state.datings.filter { $0.pieceID == id }.map { $0.score }.max() ?? 0 }
}
