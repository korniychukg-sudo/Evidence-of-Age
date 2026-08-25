import SwiftUI
import UIKit
import ImageIO

enum Age {
    static let paper = Color(red: 0.933, green: 0.918, blue: 0.882)
    static let paperWarm = Color(red: 0.949, green: 0.929, blue: 0.878)
    static let card = Color(red: 0.965, green: 0.953, blue: 0.925)
    static let ink = Color(red: 0.110, green: 0.106, blue: 0.098)
    static let inkSoft = Color(red: 0.263, green: 0.251, blue: 0.235)
    static let inkPale = Color(red: 0.459, green: 0.447, blue: 0.427)
    static let sepia = Color(red: 0.333, green: 0.263, blue: 0.180)
    static let oxblood = Color(red: 0.529, green: 0.208, blue: 0.169)

    static let oak = Color(red: 0.635, green: 0.494, blue: 0.310)
    static let oakDark = Color(red: 0.400, green: 0.298, blue: 0.180)
    static let oakPale = Color(red: 0.769, green: 0.639, blue: 0.443)
    static let walnut = Color(red: 0.478, green: 0.333, blue: 0.220)
    static let mahogany = Color(red: 0.478, green: 0.243, blue: 0.176)
    static let pine = Color(red: 0.831, green: 0.729, blue: 0.549)
    static let patina = Color(red: 0.290, green: 0.204, blue: 0.129)
    static let bareWood = Color(red: 0.800, green: 0.706, blue: 0.545)

    static let brass = Color(red: 0.741, green: 0.596, blue: 0.286)
    static let brassDark = Color(red: 0.502, green: 0.388, blue: 0.176)
    static let iron = Color(red: 0.353, green: 0.353, blue: 0.361)
    static let ironDark = Color(red: 0.204, green: 0.204, blue: 0.216)
    static let steel = Color(red: 0.600, green: 0.616, blue: 0.627)
    static let baize = Color(red: 0.235, green: 0.322, blue: 0.259)
    static let linen = Color(red: 0.855, green: 0.827, blue: 0.761)
    static let lamp = Color(red: 0.973, green: 0.859, blue: 0.639)
    static let moss = Color(red: 0.427, green: 0.482, blue: 0.376)
    static let night = Color(red: 0.106, green: 0.102, blue: 0.106)
    static let slate = Color(red: 0.325, green: 0.333, blue: 0.341)

    static func serif(_ s: CGFloat) -> Font { .custom("Georgia", size: s) }
    static func serifBold(_ s: CGFloat) -> Font { .custom("Georgia-Bold", size: s) }
    static func serifItalic(_ s: CGFloat) -> Font { .custom("Georgia-Italic", size: s) }
}

enum Plates {
    private static let cache = NSCache<NSString, UIImage>()
    static func image(_ name: String, maxDim: CGFloat = 1200) -> UIImage? {
        let key = "\(name)@\(Int(maxDim))" as NSString
        if let hit = cache.object(forKey: key) { return hit }
        guard let path = Bundle.main.path(forResource: name, ofType: "jpg", inDirectory: "Art"),
              let src = CGImageSourceCreateWithURL(URL(fileURLWithPath: path) as CFURL, nil)
        else { return nil }
        let opts: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDim * UIScreen.main.scale
        ]
        guard let cg = CGImageSourceCreateThumbnailAtIndex(src, 0, opts as CFDictionary) else { return nil }
        let img = UIImage(cgImage: cg)
        cache.setObject(img, forKey: key)
        return img
    }
}

struct PlateView: View {
    let name: String
    var maxDim: CGFloat = 1100
    var mode: ContentMode = .fit
    var body: some View {
        GeometryReader { geo in
            if let img = Plates.image(name, maxDim: maxDim) {
                Image(uiImage: img).resizable().aspectRatio(contentMode: mode)
                    .frame(width: geo.size.width, height: geo.size.height).clipped()
            } else {
                Rectangle().fill(Age.paperWarm).frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}

struct PlateTop: View {
    let name: String
    var band: CGFloat = 0.56
    var maxDim: CGFloat = 1100

    var body: some View {
        GeometryReader { geo in
            if let img = Plates.image(name, maxDim: maxDim) {
                let scale = geo.size.width / img.size.width
                Image(uiImage: img)
                    .resizable()
                    .frame(width: img.size.width * scale, height: img.size.height * scale)
                    .offset(y: 0)
            } else {
                Rectangle().fill(Age.paperWarm)
            }
        }
        .clipped()
    }
}

struct PlateThumb: View {
    let name: String
    var focusY: CGFloat = 0.32
    var bandHeight: CGFloat = 0.42
    var maxDim: CGFloat = 520
    var body: some View {
        GeometryReader { geo in
            if let img = Plates.image(name, maxDim: maxDim) {
                let iw = img.size.width, ih = img.size.height
                let scale = max(geo.size.width / iw, geo.size.height / (ih * bandHeight))
                Image(uiImage: img).resizable()
                    .frame(width: iw * scale, height: ih * scale)
                    .offset(x: (geo.size.width - iw * scale) / 2,
                            y: geo.size.height / 2 - ih * scale * focusY)
            } else { Rectangle().fill(Age.paperWarm) }
        }
        .clipped()
    }
}

enum DealerRank {
    static let names = ["Porter", "Runner", "Cataloguer", "Valuer", "Specialist", "Consultant"]
    static let steps = [0, 250, 760, 1700, 3400, 6200]
    static func level(_ xp: Int) -> Int {
        var lv = 0
        for (i, s) in steps.enumerated() where xp >= s { lv = i }
        return lv
    }
    static func name(_ xp: Int) -> String { names[min(level(xp), names.count - 1)] }
    static func progress(_ xp: Int) -> Double {
        let lv = level(xp)
        guard lv < steps.count - 1 else { return 1 }
        return max(0, min(1, Double(xp - steps[lv]) / Double(steps[lv + 1] - steps[lv])))
    }
    static func nextAt(_ xp: Int) -> Int? {
        let lv = level(xp)
        return lv < steps.count - 1 ? steps[lv + 1] : nil
    }
}

struct DaySeed {
    let value: UInt64
    init(_ date: Date, salt: UInt64 = 0) {
        let c = Calendar.current.dateComponents([.year, .month, .day], from: date)
        var h: UInt64 = 1469598103934665603
        for n in [c.year ?? 0, c.month ?? 0, c.day ?? 0] {
            h = (h ^ UInt64(bitPattern: Int64(n))) &* 1099511628211
        }
        h = (h ^ salt) &* 1099511628211
        value = h
    }
    func pick<T>(_ items: [T], _ o: UInt64 = 0) -> T {
        items[Int((value &+ o &* 2654435761) % UInt64(max(1, items.count)))]
    }
    func int(_ lo: Int, _ hi: Int, _ o: UInt64 = 0) -> Int {
        lo + Int((value &+ o &* 40503) % UInt64(max(1, hi - lo + 1)))
    }
}

func dayKey(_ d: Date) -> String {
    let c = Calendar.current.dateComponents([.year, .month, .day], from: d)
    return String(format: "%04d-%02d-%02d", c.year ?? 0, c.month ?? 0, c.day ?? 0)
}
func shortDate(_ d: Date) -> String {
    let f = DateFormatter(); f.dateFormat = "d MMM"; f.locale = Locale(identifier: "en_US")
    return f.string(from: d)
}
func gradeWord(_ s: Double) -> String {
    switch s {
    case 0.92...: return "Textbook"
    case 0.80..<0.92: return "Confident"
    case 0.66..<0.80: return "Defensible"
    case 0.50..<0.66: return "Arguable"
    case 0.32..<0.50: return "Loose"
    default: return "Wrong"
    }
}
struct Seeded {
    private var s: UInt64
    init(_ seed: UInt64) { s = seed == 0 ? 0x9E3779B97F4A7C15 : seed }
    mutating func next() -> UInt64 { s ^= s << 13; s ^= s >> 7; s ^= s << 17; return s }
    mutating func d() -> Double { Double(next() % 1_000_000) / 1_000_000.0 }
    mutating func r(_ a: Double, _ b: Double) -> Double { a + d() * (b - a) }
    mutating func chance(_ p: Double) -> Bool { d() < p }
}
func hashString(_ s: String) -> UInt64 {
    var h: UInt64 = 14695981039346656037
    for b in s.utf8 { h = (h ^ UInt64(b)) &* 1099511628211 }
    return h
}
