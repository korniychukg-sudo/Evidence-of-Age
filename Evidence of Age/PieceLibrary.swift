import SwiftUI

enum EvidenceKind: String, Codable, CaseIterable {
    case dovetails, saw, screws, shrinkage, handles, patina, timber, backboards

    var title: String {
        switch self {
        case .dovetails: return "Dovetails"
        case .saw: return "Saw marks"
        case .screws: return "Screws and nails"
        case .shrinkage: return "Shrinkage"
        case .handles: return "Hardware"
        case .patina: return "Patina and wear"
        case .timber: return "Timber and veneer"
        case .backboards: return "Backboards"
        }
    }
    var instruction: String {
        switch self {
        case .dovetails: return "Drag the caliper across a pin and read its width against the tails."
        case .saw: return "Rake the lamp across the board until the tool marks show."
        case .screws: return "Turn the screw under the glass and read the slot, the thread and the end."
        case .shrinkage: return "Measure across the grain, then along it, and compare."
        case .handles: return "Open the drawer and count every hole the front has ever carried."
        case .patina: return "Rake the light along the surface and find where the wear actually is."
        case .timber: return "Look at a chipped edge under the glass and read the thickness."
        case .backboards: return "Take the torch to the back, where nobody ever polished."
        }
    }
    var lens: String {
        switch self {
        case .dovetails: return "caliper"
        case .saw, .patina: return "lamp"
        case .screws: return "loupe"
        case .shrinkage: return "rule"
        case .handles: return "count"
        case .timber: return "loupe"
        case .backboards: return "torch"
        }
    }
    var guideID: String {
        switch self {
        case .dovetails: return "dovetail"
        case .saw: return "sawmarks"
        case .screws: return "screws"
        case .shrinkage: return "shrinkage"
        case .handles: return "handles"
        case .patina: return "patina"
        case .timber: return "veneer"
        case .backboards: return "backboards"
        }
    }
}

struct Spot: Identifiable {
    var id: String { title }
    let kind: EvidenceKind
    let x: Double
    let y: Double
    let title: String
    let finding: String
    let from: Int
    let to: Int
}

struct PieceEntry: Identifiable {
    let id: String
    let name: String
    let period: String
    let year: Int
    let region: String
    let timber: String
    let line: String
    let hardware: String
    let spots: [Spot]
    var plate: String { "piece_" + id }
    var difficulty: Int {
        let span = spots.map { $0.to - $0.from }.reduce(0, +) / max(1, spots.count)
        return max(1, min(5, span / 32))
    }
    var unlockLevel: Int {
        switch difficulty {
        case 1: return 0
        case 2: return 1
        case 3: return 2
        case 4: return 3
        default: return 4
        }
    }
}

enum Pieces {
    static let all: [PieceEntry] = groupA + groupB + groupC + groupD
    static func piece(_ id: String) -> PieceEntry? { all.first { $0.id == id } }

    private static let groupA: [PieceEntry] = [
        PieceEntry(id: "oakcoffer", name: "Oak Coffer", period: "Jacobean", year: 1650,
                   region: "West Country", timber: "English oak",
                   line: "Riven oak, pegged frame and panel, and three centuries of wax",
                   hardware: "Wrought iron strap hinges",
                   spots: [
                        Spot(kind: .saw, x: 0.26, y: 0.34,
                             title: "Riven, not sawn",
                             finding: "The boards were split along the grain with a froe, so the surface follows the medullary rays and no saw mark appears anywhere on it.",
                             from: 1600, to: 1695),
                        Spot(kind: .backboards, x: 0.64, y: 0.40,
                             title: "Pegged mortice and tenon",
                             finding: "Every joint is drawbored: the peg hole in the tenon is offset so driving the peg pulls the shoulder tight. Nothing is glued.",
                             from: 1600, to: 1715),
                        Spot(kind: .screws, x: 0.46, y: 0.74,
                             title: "Iron, not brass",
                             finding: "Strap hinges hand forged, with hammer marks still on the face and nail holes punched rather than drilled.",
                             from: 1610, to: 1685),
                        Spot(kind: .shrinkage, x: 0.78, y: 0.60,
                             title: "Shrinkage across the grain",
                             finding: "The panels have shrunk in width and the original paint line shows at the edges. They float in their grooves, which is why nothing has split.",
                             from: 1600, to: 1725)
                   ]),
        PieceEntry(id: "queenannechair", name: "Queen Anne Side Chair", period: "Queen Anne", year: 1715,
                   region: "London", timber: "Walnut",
                   line: "A cabriole leg, a vase splat and no stretcher at all",
                   hardware: "None",
                   spots: [
                        Spot(kind: .handles, x: 0.30, y: 0.70,
                             title: "The cabriole",
                             finding: "Cut from a solid block and shaped with rasp and file. Look inside the knee for the flat where the block was gripped in the vice.",
                             from: 1685, to: 1745),
                        Spot(kind: .saw, x: 0.62, y: 0.34,
                             title: "Vase shaped splat",
                             finding: "Sawn from one board, and the grain runs through the whole curve. A modern copy has short grain at the neck and cracks there.",
                             from: 1670, to: 1760),
                        Spot(kind: .backboards, x: 0.46, y: 0.86,
                             title: "No stretchers",
                             finding: "The moment furniture is strong enough to lose its stretchers is a date in itself. Before about 1710 they are still there.",
                             from: 1650, to: 1780),
                        Spot(kind: .shrinkage, x: 0.74, y: 0.62,
                             title: "Seat rail joints",
                             finding: "Mortice and tenon, pinned, with the glue line dark and shrunken. The rails have shrunk away from the corner blocks.",
                             from: 1640, to: 1790)
                   ]),
        PieceEntry(id: "peartable", name: "Pembroke Table", period: "George III", year: 1780,
                   region: "London", timber: "Mahogany with satinwood banding",
                   line: "Two small flaps on wooden hinges and a single frieze drawer",
                   hardware: "Brass knob",
                   spots: [
                        Spot(kind: .handles, x: 0.28, y: 0.24,
                             title: "Rule joint",
                             finding: "The flap meets the top in a rule joint, hinged with a knuckle hinge let flush into the underside.",
                             from: 1748, to: 1810),
                        Spot(kind: .timber, x: 0.66, y: 0.42,
                             title: "Crossbanding",
                             finding: "A band of satinwood laid around the top, mitred at the corners, with a fine boxwood stringing inside it.",
                             from: 1723, to: 1835),
                        Spot(kind: .patina, x: 0.46, y: 0.76,
                             title: "Drawer runner wear",
                             finding: "The runners are worn to a dished channel with a shoulder at the back where the drawer stopped for two centuries.",
                             from: 1698, to: 1860),
                        Spot(kind: .backboards, x: 0.78, y: 0.64,
                             title: "Fly bracket",
                             finding: "The bracket that swings out to carry the flap is a hand cut knuckle joint. Count the knuckles.",
                             from: 1713, to: 1845)
                   ]),
        PieceEntry(id: "regencytable", name: "Regency Sofa Table", period: "Regency", year: 1815,
                   region: "London", timber: "Rosewood veneer",
                   line: "Sabre legs, brass paw castors and a top that folds at both ends",
                   hardware: "Brass lion paw castors",
                   spots: [
                        Spot(kind: .saw, x: 0.28, y: 0.24,
                             title: "Sabre legs",
                             finding: "Sawn from a thick plank with the grain following the curve, then finished with a spokeshave.",
                             from: 1768, to: 1860),
                        Spot(kind: .shrinkage, x: 0.66, y: 0.42,
                             title: "Brass castors",
                             finding: "Lion paw castors with the maker's name stamped in the collar. The leather wheels have worn oval.",
                             from: 1738, to: 1890),
                        Spot(kind: .timber, x: 0.46, y: 0.76,
                             title: "Rosewood veneer",
                             finding: "Laid in book matched pairs so the figure mirrors across the centre line of the top.",
                             from: 1758, to: 1870),
                        Spot(kind: .screws, x: 0.78, y: 0.64,
                             title: "Screws in the top",
                             finding: "Hand filed slots, off centre, and the threads run out before the point. Machine screws arrive in the 1850s.",
                             from: 1778, to: 1850)
                   ]),
        PieceEntry(id: "boxstool", name: "Box Stool", period: "Commonwealth", year: 1655,
                   region: "Welsh borders", timber: "Oak",
                   line: "A joint stool with a lid, and everything about it is pegged",
                   hardware: "Iron hinge",
                   spots: [
                        Spot(kind: .saw, x: 0.28, y: 0.36,
                             title: "Drawbored pegs",
                             finding: "Look at the peg ends: they are not round but slightly oval, because the offset hole dragged them as they were driven.",
                             from: 1607, to: 1700),
                        Spot(kind: .backboards, x: 0.66, y: 0.44,
                             title: "Scribed lines",
                             finding: "The layout scribe lines are still visible on the rails, and they run past the joint because nobody bothered to clean them off.",
                             from: 1600, to: 1720),
                        Spot(kind: .patina, x: 0.46, y: 0.78,
                             title: "Foot wear",
                             finding: "The feet have worn away by twenty millimetres, unevenly, and the wear matches a floor that sloped.",
                             from: 1600, to: 1735),
                        Spot(kind: .patina, x: 0.76, y: 0.66,
                             title: "Original colour",
                             finding: "Under the lid, where light and wax never reached, the oak is the pale honey it started as.",
                             from: 1600, to: 1735)
                   ]),
        PieceEntry(id: "washstand", name: "Washstand", period: "Regency", year: 1810,
                   region: "Provincial", timber: "Painted pine",
                   line: "Painted pine, a hole for the bowl, and a splashback",
                   hardware: "Turned knob",
                   spots: [
                        Spot(kind: .backboards, x: 0.28, y: 0.24,
                             title: "Original paint",
                             finding: "Under the later coats there is a thin, hard, slightly translucent paint with visible brush drag. Milk paint, not emulsion.",
                             from: 1741, to: 1875),
                        Spot(kind: .screws, x: 0.66, y: 0.42,
                             title: "Cut nails",
                             finding: "Rectangular in section, tapering on two sides only. In use from about 1800 to 1890 and then gone.",
                             from: 1771, to: 1845),
                        Spot(kind: .timber, x: 0.46, y: 0.76,
                             title: "Pine and softwood",
                             finding: "The whole thing is deal, because it was always going to be painted. Nobody wasted mahogany on a washstand.",
                             from: 1751, to: 1865),
                        Spot(kind: .backboards, x: 0.78, y: 0.64,
                             title: "Water damage",
                             finding: "The top has swollen and the joints opened around the bowl hole. That damage is honest and it dates itself.",
                             from: 1741, to: 1875)
                   ]),
        PieceEntry(id: "creamware", name: "Dressing Mirror", period: "George III", year: 1785,
                   region: "London", timber: "Mahogany and satinwood",
                   line: "A swing frame on a serpentine box of three small drawers",
                   hardware: "Brass knobs",
                   spots: [
                        Spot(kind: .backboards, x: 0.32, y: 0.30,
                             title: "Mercury glass",
                             finding: "The plate is thin, slightly grey, and the silvering has crazed into a fine web at the edges.",
                             from: 1720, to: 1850),
                        Spot(kind: .backboards, x: 0.66, y: 0.24,
                             title: "Bevel by hand",
                             finding: "The bevel is shallow, uneven in width, and it does not run quite parallel to the edge.",
                             from: 1720, to: 1850),
                        Spot(kind: .saw, x: 0.46, y: 0.74,
                             title: "Serpentine front",
                             finding: "Sawn from the solid and shaped with a compass plane, so the curve is fair but not mathematically true.",
                             from: 1740, to: 1830),
                        Spot(kind: .screws, x: 0.74, y: 0.66,
                             title: "Original glue blocks",
                             finding: "Small triangular blocks rubbed into the corners with hot glue, shrunken and dark, with no nails.",
                             from: 1750, to: 1820)
                   ]),
        PieceEntry(id: "stickstand", name: "Hall Stick Stand", period: "Late Victorian", year: 1890,
                   region: "Birmingham", timber: "Oak",
                   line: "Cast iron, pressed brass and a great deal of Victorian confidence",
                   hardware: "Cast iron drip tray",
                   spots: [
                        Spot(kind: .handles, x: 0.24, y: 0.36,
                             title: "Cast iron tray",
                             finding: "Sand cast, with the mould parting line still visible along the rim and a casting number underneath.",
                             from: 1860, to: 1920),
                        Spot(kind: .handles, x: 0.68, y: 0.40,
                             title: "Pressed brass",
                             finding: "Thin brass pressed in a die rather than chased by hand. The relief is even and slightly soft.",
                             from: 1860, to: 1920),
                        Spot(kind: .backboards, x: 0.48, y: 0.72,
                             title: "Machine cut mortices",
                             finding: "Square cornered, all identical, and the cutter left a fine ridge at the bottom of each.",
                             from: 1825, to: 1955),
                        Spot(kind: .screws, x: 0.80, y: 0.58,
                             title: "Wire nails",
                             finding: "Round in section with a flat head. They date the piece to after about 1890 and nothing earlier.",
                             from: 1855, to: 1925)
                   ])
    ]

    private static let groupB: [PieceEntry] = [
        PieceEntry(id: "wainscot", name: "Wainscot Chair", period: "Charles II", year: 1670,
                   region: "Yorkshire", timber: "English oak",
                   line: "A panelled back, a plank seat and legs turned on a pole lathe",
                   hardware: "None",
                   spots: [
                        Spot(kind: .backboards, x: 0.30, y: 0.70,
                             title: "Pole lathe turning",
                             finding: "The rings are slightly uneven and the tool left a series of fine chatter marks that no powered lathe produces.",
                             from: 1601, to: 1735),
                        Spot(kind: .backboards, x: 0.62, y: 0.34,
                             title: "Carved by hand",
                             finding: "The lunette carving runs out of register at one end because it was set out by eye and cut with a gouge.",
                             from: 1601, to: 1735),
                        Spot(kind: .patina, x: 0.46, y: 0.86,
                             title: "Seat wear",
                             finding: "The plank seat is worn hollow toward the front edge and along the arms where hands have gripped for centuries.",
                             from: 1600, to: 1750),
                        Spot(kind: .screws, x: 0.74, y: 0.62,
                             title: "No screws anywhere",
                             finding: "Everything is pegged. A screw in a joint of this date is a repair, and there are two.",
                             from: 1631, to: 1705)
                   ]),
        PieceEntry(id: "bureau", name: "Walnut Bureau", period: "George I", year: 1725,
                   region: "London", timber: "Walnut on oak",
                   line: "A fall front on lopers, four graduated drawers, bracket feet",
                   hardware: "Brass swan neck handles",
                   spots: [
                        Spot(kind: .backboards, x: 0.26, y: 0.30,
                             title: "Graduated drawers",
                             finding: "Each drawer is deeper than the one above by a consistent step. A copy usually gets the rhythm slightly wrong.",
                             from: 1657, to: 1790),
                        Spot(kind: .dovetails, x: 0.68, y: 0.44,
                             title: "Hand cut dovetails",
                             finding: "Three per corner, narrow pins, and the marking gauge line runs across the whole board and does not stop.",
                             from: 1662, to: 1785),
                        Spot(kind: .patina, x: 0.48, y: 0.72,
                             title: "Loper wear",
                             finding: "The lopers that carry the fall are worn to a taper and their housings are polished bright at the top.",
                             from: 1642, to: 1805),
                        Spot(kind: .timber, x: 0.80, y: 0.60,
                             title: "Oak linings",
                             finding: "Drawer sides of straight grained oak, about ten millimetres, planed and left from the plane. Feel the ripple.",
                             from: 1667, to: 1780)
                   ]),
        PieceEntry(id: "windsor", name: "Windsor Chair", period: "George III", year: 1790,
                   region: "Buckinghamshire", timber: "Elm seat, ash bow, beech legs",
                   line: "Three timbers, no glue in the legs, and a seat adzed from a slab of elm",
                   hardware: "None",
                   spots: [
                        Spot(kind: .timber, x: 0.30, y: 0.70,
                             title: "Three woods on purpose",
                             finding: "Elm for the seat because it does not split, ash for the bow because it bends, beech for the legs because it turns.",
                             from: 1730, to: 1845),
                        Spot(kind: .backboards, x: 0.62, y: 0.34,
                             title: "Adzed seat",
                             finding: "The saddle is cut with an adze and a travisher, and the tool marks are still there under the wax if you rake a light across it.",
                             from: 1720, to: 1855),
                        Spot(kind: .timber, x: 0.46, y: 0.86,
                             title: "Wedged through tenons",
                             finding: "The legs go right through the seat and are wedged from above. The wedge and the leg are different woods.",
                             from: 1730, to: 1845),
                        Spot(kind: .saw, x: 0.74, y: 0.62,
                             title: "Dry joints",
                             finding: "The legs were driven in green and shrank tight. There is no glue anywhere in the undercarriage.",
                             from: 1740, to: 1835)
                   ]),
        PieceEntry(id: "victorianchest", name: "Mahogany Chest", period: "Early Victorian", year: 1845,
                   region: "Midlands", timber: "Mahogany on pine",
                   line: "Straight fronted, wooden knobs, and the first circular saw marks",
                   hardware: "Turned wooden knobs",
                   spots: [
                        Spot(kind: .saw, x: 0.22, y: 0.42,
                             title: "Circular saw marks",
                             finding: "Arcs across the back boards. The circular saw is in general use from about 1830 and there is no going back.",
                             from: 1796, to: 1890),
                        Spot(kind: .screws, x: 0.70, y: 0.30,
                             title: "Wooden knobs",
                             finding: "Turned mahogany knobs on a screw thread. They replace brass in the 1830s and are back out of fashion by 1870.",
                             from: 1806, to: 1880),
                        Spot(kind: .saw, x: 0.50, y: 0.74,
                             title: "Machine cut veneer",
                             finding: "Thin, even, and cut on a knife rather than a saw. Under a glass the surface shows no saw ripple at all.",
                             from: 1796, to: 1890),
                        Spot(kind: .backboards, x: 0.80, y: 0.62,
                             title: "Drawer bottoms grooved",
                             finding: "The bottom boards run side to side and sit in a groove, with a muntin down the middle of the wider drawers.",
                             from: 1776, to: 1910)
                   ]),
        PieceEntry(id: "spicebox", name: "Spice Box", period: "Restoration", year: 1680,
                   region: "Pennsylvania", timber: "Black walnut",
                   line: "A little cabinet of drawers, locked, because spice was worth locking up",
                   hardware: "Iron lock and brass drops",
                   spots: [
                        Spot(kind: .dovetails, x: 0.28, y: 0.32,
                             title: "Tiny dovetails",
                             finding: "Four to a corner on a drawer forty millimetres deep, cut with a knife rather than a saw at the shoulder.",
                             from: 1620, to: 1740),
                        Spot(kind: .handles, x: 0.66, y: 0.38,
                             title: "Original lock",
                             finding: "A wrought iron lock let into the door with a hand cut mortice. The key is worn to a shine on one face.",
                             from: 1650, to: 1710),
                        Spot(kind: .timber, x: 0.44, y: 0.70,
                             title: "Secret drawer",
                             finding: "There is one behind the central bank, released by a wooden spring. Every spice box has one and none advertise it.",
                             from: 1625, to: 1735),
                        Spot(kind: .patina, x: 0.76, y: 0.58,
                             title: "Interior colour",
                             finding: "The inside of the drawers is bare walnut, oxidised to a warm brown that no stain reproduces.",
                             from: 1600, to: 1760)
                   ]),
        PieceEntry(id: "chiffonier", name: "Chiffonier", period: "William IV", year: 1832,
                   region: "London", timber: "Mahogany",
                   line: "Heavy mouldings, brass grilles backed with silk, and a shelf above",
                   hardware: "Brass grille and knobs",
                   spots: [
                        Spot(kind: .backboards, x: 0.24, y: 0.36,
                             title: "Heavy scroll moulding",
                             finding: "Run with a moulding plane in several passes. Look for the small step where the plane was reset.",
                             from: 1762, to: 1899),
                        Spot(kind: .handles, x: 0.68, y: 0.40,
                             title: "Brass grille",
                             finding: "Woven brass wire, backed with pleated silk that has rotted to threads. The original tacks are still there.",
                             from: 1797, to: 1864),
                        Spot(kind: .saw, x: 0.48, y: 0.72,
                             title: "Saw marks change",
                             finding: "Pit saw marks on the older secondary timber, circular saw on the later repairs. Both are on the same piece.",
                             from: 1782, to: 1879),
                        Spot(kind: .patina, x: 0.80, y: 0.58,
                             title: "Turned feet",
                             finding: "Squat turned feet, and the wear on them is on the front pair only because it always stood against a wall.",
                             from: 1747, to: 1914)
                   ]),
        PieceEntry(id: "canterbury", name: "Canterbury", period: "Regency", year: 1820,
                   region: "London", timber: "Rosewood",
                   line: "Four divisions for sheet music, a drawer below and castors on everything",
                   hardware: "Brass castors",
                   spots: [
                        Spot(kind: .backboards, x: 0.24, y: 0.36,
                             title: "Turned spindles",
                             finding: "Every spindle is slightly different in length because each was fitted to its own hole.",
                             from: 1755, to: 1885),
                        Spot(kind: .timber, x: 0.68, y: 0.40,
                             title: "Rosewood grain",
                             finding: "Dark stripes on a red brown ground, and it smells faintly of roses when freshly cut. It is not a stain.",
                             from: 1765, to: 1875),
                        Spot(kind: .handles, x: 0.48, y: 0.72,
                             title: "Original castors",
                             finding: "Brass cup castors with the maker stamped on the collar and leather wheels worn flat on one side.",
                             from: 1790, to: 1850),
                        Spot(kind: .handles, x: 0.80, y: 0.58,
                             title: "Drawer stops",
                             finding: "Small blocks glued to the rails, worn to a shine, and one of them has been replaced.",
                             from: 1790, to: 1850)
                   ]),
        PieceEntry(id: "deco", name: "Art Deco Cocktail Cabinet", period: "Art Deco", year: 1932,
                   region: "London", timber: "Birds eye maple veneer",
                   line: "Stepped, veneered, chrome handled and entirely of its decade",
                   hardware: "Chromed steel",
                   spots: [
                        Spot(kind: .timber, x: 0.24, y: 0.36,
                             title: "Plywood carcase",
                             finding: "Multi ply, machine made, with a paper thin knife cut veneer laid on both faces to balance it.",
                             from: 1877, to: 1975),
                        Spot(kind: .handles, x: 0.68, y: 0.40,
                             title: "Chrome, not brass",
                             finding: "Electroplated chromium on steel. It pits rather than tarnishes and the pitting is the giveaway.",
                             from: 1902, to: 1964),
                        Spot(kind: .backboards, x: 0.48, y: 0.72,
                             title: "Cellulose finish",
                             finding: "Sprayed cellulose lacquer, which crazes into a fine crackle. Shellac, which is older, does not do that.",
                             from: 1867, to: 1975),
                        Spot(kind: .backboards, x: 0.80, y: 0.58,
                             title: "Machine everything",
                             finding: "Not one hand cut joint anywhere in the piece, and that is a statement rather than an economy.",
                             from: 1867, to: 1975)
                   ])
    ]

    private static let groupC: [PieceEntry] = [
        PieceEntry(id: "walnutchest", name: "Walnut Chest of Drawers", period: "William and Mary", year: 1695,
                   region: "London", timber: "Walnut veneer on pine",
                   line: "Oyster veneer, half round mouldings and bun feet",
                   hardware: "Brass drop handles",
                   spots: [
                        Spot(kind: .saw, x: 0.22, y: 0.42,
                             title: "Veneer laid on pine",
                             finding: "Saw cut veneer nearly two millimetres thick, laid with animal glue. Modern veneer is a tenth of that.",
                             from: 1649, to: 1740),
                        Spot(kind: .backboards, x: 0.70, y: 0.30,
                             title: "Half round moulding",
                             finding: "The moulding runs around the drawer opening on the carcase, not on the drawer front. After about 1710 it moves to the drawer.",
                             from: 1629, to: 1760),
                        Spot(kind: .handles, x: 0.50, y: 0.74,
                             title: "Drop handles",
                             finding: "Cast brass drops on wire, with the original holes only. A later handle leaves two extra holes inside the drawer.",
                             from: 1664, to: 1725),
                        Spot(kind: .screws, x: 0.80, y: 0.62,
                             title: "Drawer bottoms front to back",
                             finding: "The boards of the drawer bottom run front to back and are nailed. Side to side and grooved is a later habit.",
                             from: 1659, to: 1730)
                   ]),
        PieceEntry(id: "longcase", name: "Longcase Clock", period: "George II", year: 1745,
                   region: "Lancashire", timber: "Oak with mahogany crossbanding",
                   line: "Eight day movement, brass dial, and a case made locally to fit it",
                   hardware: "Brass dial and hinges",
                   spots: [
                        Spot(kind: .backboards, x: 0.50, y: 0.20,
                             title: "Case and movement differ",
                             finding: "Provincial cases were made by a joiner to fit a movement bought in. The two are often a decade apart in style.",
                             from: 1678, to: 1810),
                        Spot(kind: .handles, x: 0.42, y: 0.52,
                             title: "Hood door lock",
                             finding: "A wooden turn button, not a lock. Locks on hood doors are a nineteenth century habit.",
                             from: 1713, to: 1775),
                        Spot(kind: .shrinkage, x: 0.56, y: 0.78,
                             title: "Trunk door shrinkage",
                             finding: "The door has shrunk across its width and the beading now stands proud at one edge by two millimetres.",
                             from: 1668, to: 1820),
                        Spot(kind: .patina, x: 0.36, y: 0.88,
                             title: "Seat board wear",
                             finding: "The board the movement stands on is compressed under the pillars, and the marks match this movement and no other.",
                             from: 1663, to: 1825)
                   ]),
        PieceEntry(id: "hepplewhite", name: "Shield Back Chair", period: "Hepplewhite", year: 1795,
                   region: "London", timber: "Mahogany",
                   line: "A shield back, tapered legs and spade feet",
                   hardware: "None",
                   spots: [
                        Spot(kind: .backboards, x: 0.30, y: 0.70,
                             title: "Shield back",
                             finding: "Built up from several pieces with the grain running round the curve. One piece would have short grain and would break.",
                             from: 1727, to: 1860),
                        Spot(kind: .backboards, x: 0.62, y: 0.34,
                             title: "Tapered leg",
                             finding: "The taper is on the two inner faces only. Look at the outside corner: it is dead straight from seat to floor.",
                             from: 1727, to: 1860),
                        Spot(kind: .handles, x: 0.46, y: 0.86,
                             title: "Spade foot",
                             finding: "A separate block glued and pinned on. Later reproductions carve it from the leg and the grain gives them away.",
                             from: 1762, to: 1825),
                        Spot(kind: .backboards, x: 0.74, y: 0.62,
                             title: "Stuffed over seat",
                             finding: "The rails are rebated for webbing and the original tack holes run in a dense line along the top edge.",
                             from: 1727, to: 1860)
                   ]),
        PieceEntry(id: "davenport", name: "Davenport Desk", period: "Victorian", year: 1865,
                   region: "Lancashire", timber: "Burr walnut",
                   line: "A sloping leather top, drawers down one side and dummies down the other",
                   hardware: "Brass gallery and knobs",
                   spots: [
                        Spot(kind: .timber, x: 0.26, y: 0.30,
                             title: "Burr veneer",
                             finding: "Cut from a burr and laid in quarters. The figure meets at the centre line and the joint is barely visible.",
                             from: 1807, to: 1920),
                        Spot(kind: .dovetails, x: 0.68, y: 0.44,
                             title: "Machine dovetails",
                             finding: "Even pins and tails of exactly the same width, and the gauge line stops where the machine stopped.",
                             from: 1802, to: 1925),
                        Spot(kind: .backboards, x: 0.48, y: 0.72,
                             title: "Leather skiver",
                             finding: "A thin leather writing surface, gold tooled at the edge, and the tooling is a wheel run rather than separate stamps.",
                             from: 1797, to: 1930),
                        Spot(kind: .backboards, x: 0.80, y: 0.60,
                             title: "Pop up gallery",
                             finding: "A spring loaded stationery compartment. The mechanism is stamped steel, not hand made.",
                             from: 1797, to: 1930)
                   ]),
        PieceEntry(id: "cornercupboard", name: "Corner Cupboard", period: "George II", year: 1750,
                   region: "Shropshire", timber: "Oak with mahogany banding",
                   line: "Hung in a corner, shaped shelves inside, and never meant to be moved",
                   hardware: "Brass H hinges",
                   spots: [
                        Spot(kind: .screws, x: 0.24, y: 0.36,
                             title: "H hinges",
                             finding: "Brass H hinges surface mounted, with hand filed screw slots that all point in different directions.",
                             from: 1715, to: 1785),
                        Spot(kind: .backboards, x: 0.68, y: 0.40,
                             title: "Shaped shelves",
                             finding: "The shelves have a shaped front edge with a spoon groove cut along the back. Both are cut by hand and vary.",
                             from: 1685, to: 1815),
                        Spot(kind: .saw, x: 0.48, y: 0.72,
                             title: "Backboards",
                             finding: "Riven oak, nailed with rose head nails, and the gaps between them have opened by five millimetres with age.",
                             from: 1705, to: 1795),
                        Spot(kind: .patina, x: 0.80, y: 0.58,
                             title: "No finish inside",
                             finding: "The interior is bare wood. Polishing the inside of a cupboard is a modern idea.",
                             from: 1670, to: 1830)
                   ]),
        PieceEntry(id: "gothicdesk", name: "Gothic Revival Desk", period: "Victorian", year: 1855,
                   region: "London", timber: "Oak",
                   line: "Pointed arches, chamfered stops and a great deal of conviction",
                   hardware: "Iron strap hinges and brass",
                   spots: [
                        Spot(kind: .backboards, x: 0.26, y: 0.30,
                             title: "Machine moulding",
                             finding: "The chamfer stops are identical on every member. A hand cut stop never is.",
                             from: 1790, to: 1920),
                        Spot(kind: .saw, x: 0.68, y: 0.44,
                             title: "Circular saw everywhere",
                             finding: "Every secondary surface carries the arc of a circular saw, including inside the drawers.",
                             from: 1810, to: 1900),
                        Spot(kind: .screws, x: 0.48, y: 0.72,
                             title: "Machine made screws",
                             finding: "Gimlet points, even threads, and the slot dead centre. That combination means after 1850.",
                             from: 1820, to: 1890),
                        Spot(kind: .handles, x: 0.80, y: 0.60,
                             title: "Deliberate medievalism",
                             finding: "Iron strap hinges on a piece that does not need them, made in a factory to look forged.",
                             from: 1825, to: 1885)
                   ]),
        PieceEntry(id: "whatnot", name: "Whatnot", period: "Victorian", year: 1850,
                   region: "London", timber: "Walnut",
                   line: "Four graduated tiers on turned supports, for displaying things",
                   hardware: "Brass castors",
                   spots: [
                        Spot(kind: .backboards, x: 0.24, y: 0.36,
                             title: "Machine turning",
                             finding: "The supports are identical to a tenth of a millimetre, which means a copying lathe.",
                             from: 1783, to: 1915),
                        Spot(kind: .saw, x: 0.68, y: 0.40,
                             title: "Fretwork gallery",
                             finding: "Cut with a treadle fretsaw. The kerf is even, and there are no file marks cleaning it up.",
                             from: 1803, to: 1895),
                        Spot(kind: .screws, x: 0.48, y: 0.72,
                             title: "Screwed from below",
                             finding: "Each tier is screwed up through the support from underneath. Earlier work would be tenoned.",
                             from: 1813, to: 1885),
                        Spot(kind: .patina, x: 0.80, y: 0.58,
                             title: "Dust patterns",
                             finding: "A century of dust has darkened the timber everywhere except where objects stood, and those ghosts are still readable.",
                             from: 1768, to: 1930)
                   ]),
        PieceEntry(id: "utility", name: "Utility Sideboard", period: "Utility", year: 1944,
                   region: "England", timber: "Oak on plywood",
                   line: "Made to a government specification, and stamped to prove it",
                   hardware: "Turned wooden handles",
                   spots: [
                        Spot(kind: .backboards, x: 0.24, y: 0.36,
                             title: "The utility mark",
                             finding: "Two stylised cheeses and a number, branded into the back or stamped in ink. It is a legal mark, not a maker's.",
                             from: 1874, to: 1975),
                        Spot(kind: .timber, x: 0.68, y: 0.40,
                             title: "No ornament at all",
                             finding: "Timber was rationed. Every moulding, every bead and every unnecessary cut was forbidden by regulation.",
                             from: 1884, to: 1975),
                        Spot(kind: .screws, x: 0.48, y: 0.72,
                             title: "Plywood back",
                             finding: "Nailed on with wire nails, and the plywood is thin and slightly warped with damp.",
                             from: 1904, to: 1975),
                        Spot(kind: .backboards, x: 0.80, y: 0.58,
                             title: "Honest joints",
                             finding: "The joinery is good because it was specified to be. Utility furniture was cheap but it was never shoddy.",
                             from: 1874, to: 1975)
                   ])
    ]

    private static let groupD: [PieceEntry] = [
        PieceEntry(id: "gatelegtable", name: "Gateleg Table", period: "Late Stuart", year: 1700,
                   region: "East Anglia", timber: "Oak with elm top",
                   line: "Bobbin turned, and it folds flat against the wall",
                   hardware: "Iron pivots",
                   spots: [
                        Spot(kind: .backboards, x: 0.28, y: 0.24,
                             title: "Bobbin turning",
                             finding: "The pattern repeats but never exactly. Measure two legs and they differ by a millimetre or two in every bead.",
                             from: 1629, to: 1765),
                        Spot(kind: .shrinkage, x: 0.66, y: 0.42,
                             title: "Wear at the gate",
                             finding: "Where the gate swings, the stretcher is worn to a shallow dish and the pivot hole is oval, not round.",
                             from: 1619, to: 1775),
                        Spot(kind: .shrinkage, x: 0.46, y: 0.76,
                             title: "Oval top",
                             finding: "The top has shrunk across the grain by nearly ten millimetres, so a top made round now measures oval.",
                             from: 1619, to: 1775),
                        Spot(kind: .backboards, x: 0.78, y: 0.64,
                             title: "Rule joint or butt",
                             finding: "An early gateleg has a plain butt joint at the leaf. The rule joint arrives later and reads as a machine curve.",
                             from: 1629, to: 1765)
                   ]),
        PieceEntry(id: "chippendale", name: "Mahogany Side Chair", period: "Chippendale", year: 1765,
                   region: "London", timber: "Cuban mahogany",
                   line: "A pierced splat, square chamfered legs and a slip seat",
                   hardware: "None",
                   spots: [
                        Spot(kind: .saw, x: 0.30, y: 0.70,
                             title: "Pierced splat",
                             finding: "Fretted with a bow saw from the back, so the saw kerf breaks out slightly on the front face and was cleaned with a file.",
                             from: 1719, to: 1810),
                        Spot(kind: .backboards, x: 0.62, y: 0.34,
                             title: "Chamfered inner edge",
                             finding: "The inside of each leg is chamfered to lighten it. The chamfer stops short of the stretcher and the stop is cut by hand.",
                             from: 1699, to: 1830),
                        Spot(kind: .timber, x: 0.46, y: 0.86,
                             title: "Slip seat frame",
                             finding: "Beech, numbered with a chisel to match its chair. Roman numerals cut with a firmer, not written.",
                             from: 1709, to: 1820),
                        Spot(kind: .timber, x: 0.74, y: 0.62,
                             title: "Cuban mahogany",
                             finding: "Dense, dark, and it rings when tapped. The pores are fine and filled with two centuries of wax.",
                             from: 1709, to: 1820)
                   ]),
        PieceEntry(id: "sheraton", name: "Sheraton Sideboard", period: "Sheraton", year: 1800,
                   region: "London", timber: "Mahogany with boxwood stringing",
                   line: "A bow front, six tapered legs and a cellaret drawer lined in lead",
                   hardware: "Brass lion mask ring handles",
                   spots: [
                        Spot(kind: .timber, x: 0.24, y: 0.36,
                             title: "Bow front construction",
                             finding: "The front is built from laminated pine bricks, veneered over. Tap it and it sounds hollow and even.",
                             from: 1744, to: 1855),
                        Spot(kind: .timber, x: 0.68, y: 0.40,
                             title: "Boxwood stringing",
                             finding: "A one millimetre line of boxwood let into a scratched groove. The corners are mitred and slightly open with age.",
                             from: 1744, to: 1855),
                        Spot(kind: .backboards, x: 0.48, y: 0.72,
                             title: "Lead lined drawer",
                             finding: "The deep drawer is lined with sheet lead, folded at the corners and tacked. That lining dates the fashion precisely.",
                             from: 1734, to: 1865),
                        Spot(kind: .handles, x: 0.80, y: 0.58,
                             title: "Original handles",
                             finding: "Lion mask rings, cast and chased. The backplate has worn the surface around it into a bright halo.",
                             from: 1769, to: 1830)
                   ]),
        PieceEntry(id: "arts", name: "Arts and Crafts Settle", period: "Arts and Crafts", year: 1900,
                   region: "Cotswolds", timber: "Quartered English oak",
                   line: "Everything showing: exposed tenons, chamfers and hand cut pegs",
                   hardware: "Wrought iron hinges",
                   spots: [
                        Spot(kind: .backboards, x: 0.30, y: 0.70,
                             title: "Exposed tenons",
                             finding: "Through tenons wedged from outside and left proud, because the joint is meant to be seen and admired.",
                             from: 1832, to: 1965),
                        Spot(kind: .backboards, x: 0.62, y: 0.34,
                             title: "Deliberate tool marks",
                             finding: "The chamfers are cut with a drawknife and not sanded out. That is a decision, not carelessness.",
                             from: 1832, to: 1965),
                        Spot(kind: .saw, x: 0.46, y: 0.86,
                             title: "Quartered oak",
                             finding: "Sawn through the radius so the medullary rays show as silver flecks across the whole surface.",
                             from: 1852, to: 1945),
                        Spot(kind: .screws, x: 0.74, y: 0.62,
                             title: "Rose head nails",
                             finding: "Hand forged nails used decoratively on the ironwork, with the hammer facets still sharp.",
                             from: 1862, to: 1935)
                   ]),
        PieceEntry(id: "teatable", name: "Tripod Tea Table", period: "George III", year: 1770,
                   region: "London", timber: "Mahogany",
                   line: "A dished top on a birdcage, and it tilts up against the wall",
                   hardware: "Brass birdcage catch",
                   spots: [
                        Spot(kind: .backboards, x: 0.28, y: 0.24,
                             title: "Dished top",
                             finding: "Turned from one board with the dish and the rim cut in a single operation on a great wheel lathe.",
                             from: 1699, to: 1835),
                        Spot(kind: .handles, x: 0.66, y: 0.42,
                             title: "Birdcage",
                             finding: "Four small pillars between two plates, letting the top both tilt and turn. The wedge that locks it is original.",
                             from: 1734, to: 1800),
                        Spot(kind: .dovetails, x: 0.46, y: 0.76,
                             title: "Three legs dovetailed",
                             finding: "Each leg is dovetailed into the column and the joint is covered by an iron spider underneath.",
                             from: 1704, to: 1830),
                        Spot(kind: .shrinkage, x: 0.78, y: 0.64,
                             title: "Shrinkage to oval",
                             finding: "A top turned round in 1770 now measures four millimetres less across the grain than along it.",
                             from: 1689, to: 1845)
                   ]),
        PieceEntry(id: "bentwood", name: "Bentwood Chair", period: "Late Victorian", year: 1885,
                   region: "Vienna", timber: "Steam bent beech",
                   line: "Six pieces, ten screws, and a million of them made",
                   hardware: "Machine screws",
                   spots: [
                        Spot(kind: .timber, x: 0.30, y: 0.70,
                             title: "Steamed and bent",
                             finding: "One length of beech steamed and bent round a former. There is no joint anywhere in the back.",
                             from: 1828, to: 1940),
                        Spot(kind: .screws, x: 0.62, y: 0.34,
                             title: "Machine screws",
                             finding: "Identical, machine made, and they are what holds the whole chair together. It packs flat.",
                             from: 1848, to: 1920),
                        Spot(kind: .backboards, x: 0.46, y: 0.86,
                             title: "Factory stamp",
                             finding: "A paper label or a branded mark under the seat, with a model number. Nothing before this period is numbered.",
                             from: 1818, to: 1950),
                        Spot(kind: .backboards, x: 0.74, y: 0.62,
                             title: "Cane seat",
                             finding: "Hand woven cane in a machine cut groove. The groove is even; the weaving is not.",
                             from: 1818, to: 1950)
                   ]),
        PieceEntry(id: "kitchentable", name: "Scrubbed Pine Table", period: "Victorian", year: 1870,
                   region: "Provincial", timber: "Deal",
                   line: "Never polished, scrubbed every week for a hundred years",
                   hardware: "Iron nails",
                   spots: [
                        Spot(kind: .patina, x: 0.28, y: 0.24,
                             title: "Scrubbed surface",
                             finding: "The soft summer growth has worn away faster than the hard winter rings, so the top has a corduroy ripple.",
                             from: 1789, to: 1950),
                        Spot(kind: .patina, x: 0.66, y: 0.42,
                             title: "Bleached by soda",
                             finding: "Scrubbing with soda has bleached the top to a pale grey while the underside is still the colour of new pine.",
                             from: 1789, to: 1950),
                        Spot(kind: .screws, x: 0.46, y: 0.76,
                             title: "Cut nails in the frame",
                             finding: "Rectangular cut nails, and the holes are square. Wire nails, which are round, arrive in the 1890s.",
                             from: 1834, to: 1905),
                        Spot(kind: .backboards, x: 0.78, y: 0.64,
                             title: "Knife scars",
                             finding: "The top carries chopping marks concentrated at one end, where the light from the window fell.",
                             from: 1804, to: 1935)
                   ]),
        PieceEntry(id: "ercol", name: "Stacking Chair", period: "Mid Century", year: 1958,
                   region: "High Wycombe", timber: "Beech and elm",
                   line: "A Windsor chair redrawn for a smaller room and a lighter house",
                   hardware: "None",
                   spots: [
                        Spot(kind: .timber, x: 0.30, y: 0.70,
                             title: "Steam bent bow",
                             finding: "One piece of beech, steamed and bent, with the compression marks still visible on the inside of the curve.",
                             from: 1898, to: 1975),
                        Spot(kind: .backboards, x: 0.62, y: 0.34,
                             title: "Elm seat",
                             finding: "Machine saddled, so the dish is perfectly even. A hand adzed seat never is.",
                             from: 1888, to: 1975),
                        Spot(kind: .backboards, x: 0.46, y: 0.86,
                             title: "Stacking geometry",
                             finding: "The legs splay to exactly the angle that lets one chair sit inside another. That is a design decision, not tradition.",
                             from: 1888, to: 1975),
                        Spot(kind: .backboards, x: 0.74, y: 0.62,
                             title: "Factory finish",
                             finding: "A thin clear lacquer applied in a booth. There is no wax build up in the corners because there never was any wax.",
                             from: 1888, to: 1975)
                   ])
    ]

}
