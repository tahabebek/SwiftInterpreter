import Foundation

struct BooleanLiteral: Expression {
  let token: Token
  let value: Bool

  func expressionNode() {}

  func tokenLiteral() -> String {
    return token.literal
  }

  func String() -> String {
    return token.literal
  }

  var description: String {
    return token.literal
  }
}
