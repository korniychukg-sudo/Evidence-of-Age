import SwiftUI

struct DeskTool: Identifiable {
    let slug: String
    let name: String
    let price: Int
    let line: String
    let effect: String
    let plate: String
    var id: String { slug }
}

let deskTools: [DeskTool] = [
    DeskTool(slug: "loupe", name: "Watchmaker's Loupe", price: 90,
             line: "Ten times, held in the eye, and the tool marks stop being a texture.",
             effect: "Evidence reveals with far less working of the tool.",
             plate: "tool_glass"),
    DeskTool(slug: "raking", name: "Raking Lamp", price: 130,
             line: "A hard light almost parallel to the surface. Every ridge throws a shadow.",
             effect: "Saw marks and plane tracks show up on the first pass.",
             plate: "tool_lamp"),
    DeskTool(slug: "caliper", name: "Vernier Caliper", price: 120,
             line: "Reads to a tenth of a millimetre and does not care what you expected.",
             effect: "Measurements read exact instead of approximate.",
             plate: "tool_gauge"),
    DeskTool(slug: "uv", name: "Ultraviolet Lamp", price: 170,
             line: "Old shellac fluoresces one way, a modern repair another.",
             effect: "Marks restored and replaced sections you would otherwise miss.",
             plate: "tool_uv"),
    DeskTool(slug: "mirror", name: "Inspection Mirror", price: 70,
             line: "On a stalk, for the underside of a top and the back of a drawer.",
             effect: "Opens hidden findings on backs and undersides.",
             plate: "tool_mirror"),
    DeskTool(slug: "reference", name: "Hardware Reference", price: 150,
             line: "Plates of every handle, screw and nail with the years they were current.",
             effect: "Narrows the date window every finding gives you.",
             plate: "tool_register"),
    DeskTool(slug: "scope", name: "Bench Microscope", price: 240,
             line: "Forty times, on a stand, with its own light.",
             effect: "Reads the finest evidence that a loupe simply cannot resolve.",
             plate: "tool_torch"),
    DeskTool(slug: "record", name: "Auction Records", price: 200,
             line: "Twenty years of results, indexed by form and region.",
             effect: "Shows the likely period before you start, so you know what to test.",
             plate: "tool_notebook"),
]

func deskToolBySlug(_ s: String) -> DeskTool { deskTools.first { $0.slug == s } ?? deskTools[0] }

struct DeskKit {
    let owned: [String]
    var hasLoupe: Bool { owned.contains("loupe") }
    var hasRaking: Bool { owned.contains("raking") }
    var hasCaliper: Bool { owned.contains("caliper") }
    var hasUV: Bool { owned.contains("uv") }
    var hasMirror: Bool { owned.contains("mirror") }
    var hasReference: Bool { owned.contains("reference") }
    var hasScope: Bool { owned.contains("scope") }
    var hasRecords: Bool { owned.contains("records") || owned.contains("record") }

    var revealEase: Double { hasLoupe ? 0.62 : 1.0 }
    var rakingEase: Double { hasRaking ? 0.66 : 1.0 }
    var windowNarrow: Double { hasReference ? 0.82 : 1.0 }
    var scopeBonus: Double { hasScope ? 0.58 : 1.0 }

    func hint(_ period: String) -> String? { hasRecords ? period : nil }
}

enum ActiveDeskKit {
    static var current = DeskKit(owned: [])
}
