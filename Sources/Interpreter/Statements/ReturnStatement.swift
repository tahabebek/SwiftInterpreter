struct ReturnStatement: Statement, CustomStringConvertible {
  let token: Token
  var returnValue: Expression?

  func statementNode() {}
  func tokenLiteral() -> String {
    return token.literal
  }

  var description: String {
    let expressionDescription = returnValue?.description ?? "..."
    return "\(tokenLiteral()) \(expressionDescription)"
  }
}
