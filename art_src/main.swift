import Foundation

let outDir = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "./out"
let iconDir = CommandLine.arguments.count > 2 ? CommandLine.arguments[2] : outDir
try? FileManager.default.createDirectory(atPath: outDir, withIntermediateDirectories: true)
try? FileManager.default.createDirectory(atPath: iconDir, withIntermediateDirectories: true)

makeGrounds(dir: outDir)
for t in toolBook { makeToolPlate(t, dir: outDir) }
for g in guideBook { makeGuidePlate(g, dir: outDir) }
for s in pieceBook { makePiecePlate(s, dir: outDir) }
makeIcon(dir: iconDir)
print("plates written to \(outDir)")
