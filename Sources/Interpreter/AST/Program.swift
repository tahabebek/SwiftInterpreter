import Foundation

struct Program {
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
}