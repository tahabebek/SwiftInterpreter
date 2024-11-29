import Foundation

struct ParserTracing {
  var traceLevel: Int = 0
  let identPlaceholder = "\t"

  func identLevel() -> String {
    return String(repeating: identPlaceholder, count: traceLevel - 1)
  }

  func tracePrint(fs: String) {
    print("\(identLevel())\(fs)".green)
  }

  mutating func incIdent() {
    traceLevel += 1
  }

  mutating func decIdent() {
    traceLevel -= 1
  }

  mutating func trace(msg: String) {
    incIdent()
    tracePrint(fs: "BEGIN \(msg)")
  }

  mutating func untrace(msg: String) {
    tracePrint(fs: "END \(msg)")
    decIdent()
  }
}
