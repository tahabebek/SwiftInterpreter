struct Parser {
  let lexer: Lexer
  var currentToken: Token
  var peekToken: Token
  var errors: [String] = []

  init(lexer: Lexer) {
    self.lexer = lexer
    currentToken = lexer.nextToken()
    peekToken = lexer.nextToken()
  }

  mutating func parseProgram() -> Program {
    var program = Program()

    while !currentTokenIs(token: .eof) {
      if let statement = parseStatement() {
        program.addStatement(statement)
      }
      nextToken()
    }
    return program
  }

  private mutating func nextToken() {
    currentToken = peekToken
    peekToken = lexer.nextToken()
  }

  private mutating func parseStatement() -> Statement? {
    switch currentToken.tokenType {
    case .keyword:
      switch currentToken.literal {
      case Keyword.let.rawValue:
        return parseLetStatement()
      case Keyword.return.rawValue:
        return parseReturnStatement()
      default:
        return nil
      }
    default:
      return nil
    }
  }

  private mutating func parseReturnStatement() -> ReturnStatement? {
    let statement = ReturnStatement(token: currentToken)
    nextToken()

    while !peekTokenIs(token: .newLine), !peekTokenIs(token: .eof) {
      nextToken()
    }
    return statement
  }

  private mutating func parseLetStatement() -> LetStatement? {
    var statement = LetStatement(token: currentToken)
    guard expectPeek(token: .identifier) else {
      return nil
    }

    statement.name = Identifier(token: currentToken, value: currentToken.literal)

    guard expectPeek(token: .assign) else {
      return nil
    }

    while !peekTokenIs(token: .newLine), !peekTokenIs(token: .eof) {
      nextToken()
    }
    return statement
  }

  private mutating func expectPeek(token: TokenType) -> Bool {
    if peekTokenIs(token: token) {
      nextToken()
      return true
    }
    peekError(token: token)
    return false
  }

  private func currentTokenIs(token: TokenType) -> Bool {
    return currentToken.tokenType == token
  }

  private func peekTokenIs(token: TokenType) -> Bool {
    return peekToken.tokenType == token
  }

  private mutating func peekError(token: TokenType) {
    errors.append("expected next token to be \(token), got \(peekToken.tokenType) instead")
  }
}
