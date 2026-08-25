import SwiftUI

struct GuideEntry: Identifiable {
    let id: String
    let plateNo: String
    let title: String
    let sub: String
    let sections: [(String, String)]
    var plate: String { "guide_" + id }
}

struct KitEntry: Identifiable {
    let id: String
    let name: String
    let sub: String
    let note: String
    var plate: String { "tool_" + id }
}

struct GlossaryTerm: Identifiable {
    var id: String { term }
    let term: String
    let meaning: String
}

struct QuizItem: Identifiable {
    var id: String { question }
    let question: String
    let options: [String]
    let answer: Int
    let because: String
}

enum Book {
    static let guides: [GuideEntry] = gA + gB + gC

    private static let gA: [GuideEntry] = [
        GuideEntry(id: "dovetail", plateNo: "Plate I", title: "Dovetails",
                   sub: "The single most useful thing in a drawer",
                   sections: [
                              ("Narrow pins mean a hand", "A hand cut dovetail has pins far narrower than the tails, because a saw kerf is all the room you need. A machine cannot do it."),
                              ("The gauge line does not stop", "A hand cut joint is set out with a marking gauge run right across the board, and the line is still there, running past the joint at both ends."),
                              ("Machine cut is perfectly even", "From about 1860 a router jig gives pins and tails of identical width and a gauge line that starts and stops with the cutter."),
                              ("Count them", "Three to a corner on an eighteenth century drawer of ordinary depth; five or six on a Victorian one, because the machine did not care.")]),
        GuideEntry(id: "sawmarks", plateNo: "Plate II", title: "Saw marks",
                   sub: "Three technologies, three signatures, three date ranges",
                   sections: [
                              ("Pit saw: straight and irregular", "Two men, one above and one below. The marks run straight across but the spacing wanders because it was cut by hand."),
                              ("Frame or gang saw: straight and even", "Water or steam powered, from the late eighteenth century. Straight marks at very regular spacing."),
                              ("Circular saw: arcs", "Curved marks, and they cannot be anything else. In general use from about 1830 and never absent afterwards."),
                              ("Look where nobody polished", "Backboards, drawer bottoms, the underside of a top. The marks survive only where the piece was never finished.")]),
        GuideEntry(id: "shrinkage", plateNo: "Plate III", title: "Shrinkage",
                   sub: "Wood moves across the grain and hardly at all along it",
                   sections: [
                              ("Round becomes oval", "A tabletop turned round in 1770 now measures several millimetres less across the grain than along it. A modern copy is still round."),
                              ("Panels shrink out of their grooves", "Frame and panel construction exists because of this. Look at the panel edges for a line of original colour that the shrinkage has exposed."),
                              ("Doors and drawer fronts", "A drawer front shrinks in height, not in width, so the gaps at top and bottom grow while the sides stay tight."),
                              ("It never stops", "Wood keeps moving with the seasons for its whole life. A piece that is dead square and perfectly tight is telling you something.")]),
        GuideEntry(id: "screws", plateNo: "Plate IV", title: "Screws and nails",
                   sub: "Fixings date a piece more reliably than its style",
                   sections: [
                              ("Hand made screws", "Before about 1780: a filed slot, off centre, an irregular thread and a blunt end. The head is never a true circle."),
                              ("Machine screws with blunt ends", "1780 to 1850: even threads from a lathe, but the end is still blunt because the gimlet point had not been invented."),
                              ("Gimlet point", "After about 1850 screws are pointed, threads are even and the slot is dead centre. That combination is a hard date."),
                              ("Nails tell the same story", "Hand forged rose head, then rectangular cut nails from about 1800, then round wire nails from about 1890.")]),
        GuideEntry(id: "patina", plateNo: "Plate V", title: "Patina and wear",
                   sub: "Where the surface has gone, and where it has built up",
                   sections: [
                              ("Wear where hands go", "Chair arms, drawer edges, the front of a seat, the lower rail of a table where feet rest. Anywhere else is suspicious."),
                              ("Build up where nothing touches", "Wax, dust and dirt collect in mouldings and corners and darken over centuries. Sharp clean mouldings on a dark piece are a warning."),
                              ("Colour under the top", "Lift a table top and look at the underside. Old wood oxidises to a colour that no stain reproduces, and it is even, not blotchy."),
                              ("Faked wear is too even", "Real wear follows use, so it is asymmetric and it stops abruptly where hands stopped. Sanded wear is smooth and everywhere.")])
    ]

    private static let gB: [GuideEntry] = [
        GuideEntry(id: "timber", plateNo: "Plate VI", title: "Timbers by date",
                   sub: "What was available, and when it became fashionable",
                   sections: [
                              ("Oak, to about 1670", "English oak, riven or pit sawn, in frame and panel construction. Almost everything before the Restoration is oak."),
                              ("Walnut, 1670 to 1730", "Then a hard winter in 1709 killed the European walnut forests and a French export ban finished it."),
                              ("Mahogany, 1730 onward", "Cuban first, dense and dark; then Honduras, lighter and softer. It arrives with a change in the timber duty."),
                              ("Rosewood and satinwood, Regency", "Exotic and expensive, usually as veneer. Then the Victorians go back to oak and walnut and everything gets heavier.")]),
        GuideEntry(id: "veneer", plateNo: "Plate VII", title: "Veneer",
                   sub: "Thickness dates it better than pattern does",
                   sections: [
                              ("Saw cut veneer", "Before about 1830 veneer is sawn, and it is one and a half to two millimetres thick. Look at an edge or a chipped corner."),
                              ("Knife cut veneer", "After the veneer slicer arrives, thickness drops to half a millimetre and then less. It is perfectly even and it cannot be scraped."),
                              ("Groundwork matters", "Early veneer is laid on pine or oak. Plywood grounds are twentieth century and end the argument at once."),
                              ("Look for the joint", "Book matched or quarter matched veneer meets at a joint. On old work the joint has opened very slightly with age.")]),
        GuideEntry(id: "handles", plateNo: "Plate VIII", title: "Handles",
                   sub: "Fashions change every twenty years, and the holes are permanent",
                   sections: [
                              ("Drops, then plates", "Brass drops to about 1710, then pierced backplates, then swan neck bails from about 1740, then stamped plates from about 1790."),
                              ("Wooden knobs", "Turned wood from about 1820, gone by 1870. Cheap, fashionable, and hated by everybody who came after."),
                              ("Count the holes", "Look inside the drawer. Every set of handles a piece has ever worn has left its holes, and the earliest set is the one that matters."),
                              ("Original is rare", "A piece with its first handles and no extra holes is unusual and it is worth a great deal more than one without.")]),
        GuideEntry(id: "backboards", plateNo: "Plate IX", title: "Backboards and secondary timber",
                   sub: "The parts nobody was meant to see are the honest ones",
                   sections: [
                              ("Never finished", "Backboards were left from the saw. Whatever tool cut them is still readable on the surface, and nobody polished it away."),
                              ("Riven, then sawn, then machined", "Riven oak boards with irregular edges are seventeenth century. Wide pine boards are eighteenth. Thin even boards or plywood are later."),
                              ("Gaps have opened", "Backboards shrink across their width and the gaps between them grow. A tight back on an old carcase has been replaced."),
                              ("Secondary timber by region", "Oak linings in London, pine in the provinces, and in America whatever grew nearby. It narrows the place as well as the date.")]),
        GuideEntry(id: "finish", plateNo: "Plate X", title: "Finish",
                   sub: "Four surfaces, four centuries",
                   sections: [
                              ("Wax and oil", "Before about 1820 the surface is wax over bare wood, or a linseed oil finish, built up over generations and full of dirt."),
                              ("French polish", "Shellac, from about 1820, applied with a rubber. It gives a deep gloss and it goes white if water touches it."),
                              ("Cellulose", "Sprayed, from the 1920s. It crazes into a fine crackle as it ages, which shellac never does."),
                              ("Modern lacquer", "Hard, plastic, even, and it sits on the surface rather than in it. It is the easiest thing in the world to spot.")])
    ]

    private static let gC: [GuideEntry] = [
        GuideEntry(id: "construction", plateNo: "Plate XI", title: "How the carcase is held together",
                   sub: "Pegs, then dovetails, then screws, then staples",
                   sections: [
                              ("Pegged frame and panel", "To about 1670. Drawbored mortice and tenon, no glue, and the panels float free in their grooves."),
                              ("Dovetailed carcase", "From the late seventeenth century. The sides are dovetailed to the top and bottom, and glue does the work."),
                              ("Glue blocks and screws", "Eighteenth century onward. Small triangular blocks rubbed into the corners, and screws where strength is needed."),
                              ("Staples and dowels", "Twentieth century mass production. A staple gun in a carcase ends every argument about date immediately.")]),
        GuideEntry(id: "proportion", plateNo: "Plate XII", title: "Proportion",
                   sub: "The first thing a good eye reads, and the hardest to fake",
                   sections: [
                              ("Height comes down", "Furniture gets lower through the eighteenth century and lower again in the nineteenth as ceilings and rooms change."),
                              ("Legs get thinner, then thicker", "Heavy turned legs, then the cabriole, then the tapered leg at its thinnest around 1790, then heavy again by 1840."),
                              ("Drawers graduate", "On good work each drawer is deeper than the one above by a consistent step. A copy usually makes them all the same or gets the rhythm wrong."),
                              ("Cut down and married", "Many old pieces have been altered. A chest that is oddly short has lost its feet; a bookcase that is oddly wide is two pieces joined.")]),
        GuideEntry(id: "marriage", plateNo: "Plate XIII", title: "Marriages and alterations",
                   sub: "Half of what survives has been changed by somebody",
                   sections: [
                              ("The top does not match", "Different timber, different colour, different saw marks, or the mouldings do not run through. Two pieces made a century apart."),
                              ("Cut down", "A tall chest made into a low one. Look for a moulding that runs off the edge, or feet that are newer than everything above them."),
                              ("Replaced feet", "Feet take the damp and go first. New feet on an old carcase are normal and honest; new feet described as original are not."),
                              ("Not a fault, but a fact", "An altered piece is still an old piece. It is only a problem when nobody says so.")]),
        GuideEntry(id: "faking", plateNo: "Plate XIV", title: "How a fake gives itself away",
                   sub: "Nobody can fake every kind of evidence at once",
                   sections: [
                              ("The evidence disagrees", "Hand cut dovetails and a circular sawn backboard. Georgian proportions and gimlet pointed screws. One thing is lying."),
                              ("Wear in the wrong place", "Worn edges where no hand ever went, and sharp edges where hands always go. Real wear follows use."),
                              ("Too clean inside", "Old drawers smell of old wood and are dirty in the corners. A new interior in an old carcase is a rebuild."),
                              ("Colour that is only skin deep", "Chip a hidden edge. Old colour goes into the wood; stain sits on it and shows a pale line under the surface.")])
    ]

    static let kit: [KitEntry] = [
        KitEntry(id: "lamp", name: "The raking light", sub: "A low light across a surface, not onto it",
                 note: "Held almost parallel to the wood, a small lamp throws every tool mark, every ripple and every dent into relief. Straight on, the same surface looks flat and tells you nothing. It is the single most useful thing in the room."),
        KitEntry(id: "glass", name: "The loupe", sub: "Ten times, and no more",
                 note: "Enough to read a saw mark, a veneer edge or a screw thread. Beyond ten times the depth of field disappears and you spend your time hunting for focus instead of looking."),
        KitEntry(id: "torch", name: "The torch", sub: "For the parts nobody polished",
                 note: "Into the back of a carcase, under a top, inside a drawer. Everything honest about a piece of furniture is in the places the maker never expected anybody to see."),
        KitEntry(id: "rule", name: "The rule", sub: "For measuring what should be equal and is not",
                 note: "Across the grain and along it, on a top that was turned round. On drawer heights that should graduate. On leg tapers that should match. Wood moves, and a rule is how you catch it."),
        KitEntry(id: "gauge", name: "The gauge and caliper", sub: "Thickness of veneer, width of a pin",
                 note: "A veneer under a millimetre is machine cut and after 1830. A dovetail pin narrower than the saw kerf is hand cut. Both are settled with a caliper in ten seconds."),
        KitEntry(id: "mirror", name: "The inspection mirror", sub: "For seeing round the back of things",
                 note: "Behind a drawer, under a rail, inside a plinth. On a piece too heavy to turn over, a small mirror on a handle is the difference between a guess and an answer."),
        KitEntry(id: "notebook", name: "The notebook", sub: "Because you will forget",
                 note: "Every finding, in order, with what it rules out. A dating is an argument built from evidence, and an argument you cannot write down is a feeling."),
        KitEntry(id: "uv", name: "Ultraviolet lamp", sub: "Old finish and new repair fluoresce differently",
                 note: "Shellac glows a warm orange; modern lacquer glows cold and bright; a filled repair shows as a dark patch. It does not date a piece, but it maps every intervention on it."),
        KitEntry(id: "cloth", name: "Cloth and wax", sub: "For leaving it better than you found it",
                 note: "A dealer who strips or over cleans a surface destroys most of the evidence and most of the value at the same time. Two centuries of patina takes two centuries to replace."),
        KitEntry(id: "register", name: "The register", sub: "Where the dating actually happens",
                 note: "A timeline, a set of findings, and a bracket you are willing to defend. Every piece of evidence narrows it from one end or the other, and where they overlap is your answer.")
    ]
}

extension Book {
    static let glossary: [GlossaryTerm] = glA + glB + glC

    private static let glA: [GlossaryTerm] = [
        GlossaryTerm(term: "Carcase", meaning: "The box of a piece of furniture, before drawers, doors, feet or mouldings are added."),
        GlossaryTerm(term: "Cabriole leg", meaning: "An S curved leg cut from a solid block, in fashion from about 1700 to 1760 and revived endlessly afterwards."),
        GlossaryTerm(term: "Crossbanding", meaning: "A band of veneer laid with the grain running across the edge, usually around a top or a drawer front."),
        GlossaryTerm(term: "Drawbore", meaning: "A pegged mortice and tenon where the hole in the tenon is offset, so driving the peg pulls the joint tight. No glue needed."),
        GlossaryTerm(term: "Frame and panel", meaning: "A rigid frame holding a floating panel, so the panel can shrink and swell without splitting the piece."),
        GlossaryTerm(term: "Gauge line", meaning: "The scribed line a marking gauge leaves when setting out a joint. On hand cut work it runs right across the board."),
        GlossaryTerm(term: "Groundwork", meaning: "The timber a veneer is laid on. Pine and oak are early; plywood is twentieth century."),
        GlossaryTerm(term: "Loper", meaning: "The sliding arm that pulls out to carry the fall of a bureau. Its wear is one of the most honest things on the piece."),
    ]

    private static let glB: [GlossaryTerm] = [
        GlossaryTerm(term: "Marriage", meaning: "Two pieces of different origin joined to make one. Not a fault in itself, only when nobody says so."),
        GlossaryTerm(term: "Medullary ray", meaning: "The silver flecks that show when oak is sawn through the radius. Quartered oak is cut deliberately to show them."),
        GlossaryTerm(term: "Muntin", meaning: "A central divider, in a drawer bottom or a frame. In drawer bottoms it appears with grooved construction after about 1770."),
        GlossaryTerm(term: "Ovolo", meaning: "A quarter round moulding. Named after the egg shape, and run with a moulding plane in several passes."),
        GlossaryTerm(term: "Patina", meaning: "The whole surface history of a piece: wax, dirt, wear, oxidation and light. It cannot be reproduced and it should not be removed."),
        GlossaryTerm(term: "Riven", meaning: "Split along the grain with a froe rather than sawn. Leaves no tool marks and follows the natural grain of the tree."),
        GlossaryTerm(term: "Secondary timber", meaning: "The wood used where it will not be seen: drawer linings, backboards, dust boards. It narrows both date and region."),
        GlossaryTerm(term: "Skiver", meaning: "The thin leather writing surface on a desk, usually gold tooled at the edge."),
    ]

    private static let glC: [GlossaryTerm] = [
        GlossaryTerm(term: "Splat", meaning: "The vertical board in a chair back. Its shape is the fastest single guide to a chair's date."),
        GlossaryTerm(term: "Stringing", meaning: "A very fine line of contrasting wood let into a scratched groove, usually boxwood or ebony."),
        GlossaryTerm(term: "Stretcher", meaning: "A rail joining the legs of a chair or table. Present on everything before about 1710, and then it disappears."),
        GlossaryTerm(term: "Through tenon", meaning: "A tenon that passes right through its mortice and shows on the other side, usually wedged."),
        GlossaryTerm(term: "Utility mark", meaning: "The legal stamp on British furniture made under wartime regulation, showing two stylised cheeses and a number."),
        GlossaryTerm(term: "Veneer slicer", meaning: "The machine that replaced the veneer saw from about 1830 and cut thickness from two millimetres to a fraction of one."),
        GlossaryTerm(term: "Wainscot", meaning: "Oak boards, and by extension the panelled chairs and furniture made from them in the seventeenth century."),
        GlossaryTerm(term: "Wire nail", meaning: "A round nail drawn from wire, in general use from about 1890. Before that, nails are rectangular or hand forged."),
    ]

    static let quiz: [QuizItem] = qA + qB + qC + qD

    private static let qA: [QuizItem] = [
        QuizItem(question: "Narrow pins and wide tails in a dovetail mean:", options: ["Machine cut", "Hand cut", "A repair", "Nothing at all"], answer: 1,
                 because: "A saw kerf is all the room a hand needs. A machine cutter cannot make a pin that narrow."),
        QuizItem(question: "Arced marks on a backboard mean the board was cut:", options: ["With a pit saw", "With a frame saw", "With a circular saw", "By hand"], answer: 2,
                 because: "Only a circular blade leaves curves, and it is in general use from about 1830."),
        QuizItem(question: "A screw with a gimlet point dates the fixing to:", options: ["Before 1780", "1780 to 1850", "After about 1850", "Any date"], answer: 2,
                 because: "Pointed screws, even threads and a centred slot together mean the second half of the nineteenth century."),
        QuizItem(question: "A tabletop turned round in 1770 will now measure:", options: ["Still round", "Oval, shorter across the grain", "Oval, shorter along the grain", "Larger"], answer: 1,
                 because: "Wood shrinks across the grain and hardly at all along it."),
        QuizItem(question: "Extra holes inside a drawer front mean:", options: ["A repair to the drawer", "The handles have been changed", "Woodworm", "Nothing"], answer: 1,
                 because: "Every set of handles a piece has ever worn leaves its holes, and they are permanent."),
        QuizItem(question: "Furniture made almost entirely of oak is most likely:", options: ["Before 1670", "1700 to 1730", "Regency", "Art Deco"], answer: 0,
                 because: "Oak dominates until walnut takes over after the Restoration."),
        QuizItem(question: "Walnut goes out of use around 1730 because:", options: ["It went out of fashion", "A hard winter and a French export ban", "It was too expensive", "It warps"], answer: 1,
                 because: "The winter of 1709 killed the European walnut forests and France banned export soon after."),
        QuizItem(question: "Saw cut veneer is about:", options: ["0.1 mm", "0.5 mm", "1.5 to 2 mm", "5 mm"], answer: 2,
                 because: "Thick enough to see at a chipped edge, and it is the clearest sign of pre-1830 work."),
    ]

    private static let qB: [QuizItem] = [
        QuizItem(question: "Real wear on a chair should be heaviest:", options: ["On the back rail", "On the arms and front seat edge", "Under the seat", "Everywhere equally"], answer: 1,
                 because: "Wear follows use. Even wear all over is sanding, not centuries."),
        QuizItem(question: "Dirt and wax building up in a moulding is:", options: ["A fault", "A sign of age", "A modern finish", "Always faked"], answer: 1,
                 because: "It takes generations to build, and sharp clean mouldings on a dark piece are a warning."),
        QuizItem(question: "Backboards are useful evidence because:", options: ["They are decorated", "They were never finished", "They are always oak", "They are replaced often"], answer: 1,
                 because: "Nobody polished them, so whatever tool cut them is still readable."),
        QuizItem(question: "Gaps between backboards that have opened with age suggest:", options: ["Poor work", "Genuine shrinkage over time", "Water damage", "A replacement back"], answer: 1,
                 because: "Boards shrink across their width for their whole life. A tight old back has been replaced."),
        QuizItem(question: "Stretchers between chair legs generally disappear:", options: ["About 1710", "About 1780", "About 1850", "They never do"], answer: 0,
                 because: "Once joinery was strong enough to lose them, they went, and that is a date in itself."),
        QuizItem(question: "Brass drop handles are typical of:", options: ["Before about 1710", "1740 to 1790", "1820 to 1870", "After 1900"], answer: 0,
                 because: "Drops give way to pierced backplates and then to swan neck bails."),
        QuizItem(question: "Turned wooden knobs date a chest to roughly:", options: ["1690s", "1740s", "1820 to 1870", "1920s"], answer: 2,
                 because: "Cheap, fashionable for fifty years, and then hated by everyone who came after."),
        QuizItem(question: "A plywood carcase means the piece is:", options: ["Georgian", "Victorian", "Twentieth century", "Undatable"], answer: 2,
                 because: "Machine made multi ply ends the argument immediately."),
    ]

    private static let qC: [QuizItem] = [
        QuizItem(question: "French polish appears from about:", options: ["1650", "1750", "1820", "1920"], answer: 2,
                 because: "Shellac applied with a rubber, and it goes white if water touches it."),
        QuizItem(question: "A finish that crazes into a fine crackle is:", options: ["Wax", "Shellac", "Cellulose", "Oil"], answer: 2,
                 because: "Sprayed cellulose, from the 1920s. Shellac does not craze that way."),
        QuizItem(question: "Drawer bottoms running front to back and nailed suggest:", options: ["Before about 1770", "After 1850", "Twentieth century", "A repair"], answer: 0,
                 because: "Side to side boards in a groove, with a muntin, are the later habit."),
        QuizItem(question: "Riven oak boards with irregular edges are typical of:", options: ["The seventeenth century", "The Regency", "Late Victorian", "Utility"], answer: 0,
                 because: "Split with a froe rather than sawn, and they carry no tool marks at all."),
        QuizItem(question: "A staple in a carcase means:", options: ["A good repair", "Mass production, twentieth century", "Country work", "Nothing"], answer: 1,
                 because: "A staple gun ends every argument about date."),
        QuizItem(question: "Cut nails, rectangular in section, are in use:", options: ["1600 to 1700", "About 1800 to 1890", "After 1950", "Never in furniture"], answer: 1,
                 because: "Hand forged before, round wire nails after."),
        QuizItem(question: "The utility mark on British furniture means it was made:", options: ["In the 1890s", "During and just after the Second World War", "In the 1970s", "For export"], answer: 1,
                 because: "Made to a government specification under rationing, and stamped to prove it."),
        QuizItem(question: "Quartered oak shows silver flecks because it is sawn:", options: ["Along the grain", "Through the radius", "Against the grain", "With a circular saw"], answer: 1,
                 because: "Cutting through the radius exposes the medullary rays."),
    ]

    private static let qD: [QuizItem] = [
        QuizItem(question: "Hand cut dovetails on a drawer with a circular sawn bottom means:", options: ["An early piece", "A later piece", "One of the two is wrong", "A country piece"], answer: 2,
                 because: "Evidence that disagrees is the commonest sign of a fake or a rebuild."),
        QuizItem(question: "A chest that is oddly short has probably:", options: ["Been cut down", "Shrunk", "Been made for a child", "Lost its top"], answer: 0,
                 because: "Look for a moulding running off the edge, or feet newer than everything above."),
        QuizItem(question: "New feet on an old carcase are:", options: ["Always a fake", "Normal and honest, if declared", "A reason to reject it", "Impossible to spot"], answer: 1,
                 because: "Feet take the damp and go first. The problem is only when nobody says so."),
        QuizItem(question: "Chipping a hidden edge on faked colour shows:", options: ["The same colour throughout", "A pale line under the surface", "Nothing", "Woodworm"], answer: 1,
                 because: "Stain sits on the wood; genuine oxidation goes into it."),
        QuizItem(question: "The most useful light for reading a surface is:", options: ["Bright and straight on", "Raking, almost parallel", "Ultraviolet", "Daylight only"], answer: 1,
                 because: "A low light throws every tool mark and ripple into relief."),
        QuizItem(question: "Under ultraviolet, shellac fluoresces:", options: ["Cold and bright", "Warm orange", "Not at all", "Green"], answer: 1,
                 because: "Modern lacquer glows cold and bright, and a filled repair reads as a dark patch."),
        QuizItem(question: "A dating is best expressed as:", options: ["A single year", "A bracket you can defend", "A century", "A guess"], answer: 1,
                 because: "Every finding narrows the range from one end or the other. Where they overlap is the answer."),
        QuizItem(question: "Over cleaning an old surface:", options: ["Improves it", "Destroys evidence and value together", "Has no effect", "Is required before sale"], answer: 1,
                 because: "Two centuries of patina takes two centuries to replace."),
    ]
}
