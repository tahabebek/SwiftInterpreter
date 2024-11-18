struct Identifier: Expression {
  let token: Token
  var value: String

  func expressionNode() {}
  func tokenLiteral() -> String {
    return token.literal
  }

  var description: String {
    return value
  }
}
