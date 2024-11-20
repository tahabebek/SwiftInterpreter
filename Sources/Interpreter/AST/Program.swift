import Foundation

struct Program: CustomStringConvertible {
  var statements: [Statement] = []

  /*
    func tokenLiteral() -> String {
        if !statements.isEmpty {
            return statements.first!.tokenLiteral()
        }
        return ""
    }
    */

  mutating func addStatement(_ statement: Statement) {
    statements.append(statement)
  }

  var description: String {
    return statements.map { $0.description }.joined(separator: "\n")
  }
}
