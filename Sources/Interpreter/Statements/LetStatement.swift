struct LetStatement: Statement, CustomStringConvertible {
  let token: Token
  var name = Identifier(token: Token(tokenType: .identifier, literal: ""), value: "")
  /*
    var value: Expression?
    */

  func statementNode() {}
  func tokenLiteral() -> String {
    return token.literal
  }

  var description: String {
    return "\(tokenLiteral()) \(name.value) = ..."
  }
}