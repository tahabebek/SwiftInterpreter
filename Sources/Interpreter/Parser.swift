struct Parser {
  let lexer: Lexer
  var currentToken: Token
  var peekToken: Token
  var errors: [String] = []
    
  // Operator precedence levels
  private let precedences: [String: Int] = [
    "==": 1,
    "!=": 1,
    "<": 2,
    ">": 2,
    "+": 3,
    "-": 3,
    "*": 4,
    "/": 4
  ]

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
        return parseExpressionStatement()
      }
    default:
      return parseExpressionStatement()
    }
  }

  private mutating func parseExpressionStatement() -> ExpressionStatement? {
    let stmt = ExpressionStatement(token: currentToken)
    stmt.expression = parseExpression(precedence: 0)
    
    if peekTokenIs(token: .newLine) {
      nextToken()
    }
    return stmt
  }

  private mutating func parseExpression(precedence: Int) -> Expression? {
    // Parse prefix
    guard var leftExp = parsePrefixExpression() else {
      errors.append("no prefix parse function for \(currentToken.literal)")
      return nil
    }
    
    // Parse infix while precedence allows
    while !peekTokenIs(token: .newLine) && precedence < peekPrecedence() {
      guard let infix = parseInfixExpression(left: leftExp) else {
        return leftExp
      }
      leftExp = infix
    }
    
    return leftExp
  }

  private mutating func parsePrefixExpression() -> Expression? {
    switch currentToken.tokenType {
    case .identifier:
      return parseIdentifier()
    case .integer:
      return parseIntegerLiteral()
    case .operator where currentToken.literal == "!":
      return parsePrefixOperator()
    case .operator where currentToken.literal == "-":
      return parsePrefixOperator()
    default:
      return nil
    }
  }

  private func parseIdentifier() -> Identifier {
    return Identifier(token: currentToken, value: currentToken.literal)
  }

  private func parseIntegerLiteral() -> IntegerLiteral {
    return IntegerLiteral(token: currentToken, 
                         value: Int(currentToken.literal) ?? 0)
  }

  private mutating func parsePrefixOperator() -> PrefixExpression? {
    let expression = PrefixExpression(token: currentToken, 
                                    operator: currentToken.literal)
    nextToken()
    expression.right = parseExpression(precedence: 0)
    return expression
  }

  private mutating func parseInfixExpression(left: Expression) -> InfixExpression? {
    guard currentToken.tokenType == .operator else { return nil }
    
    let precedence = currentPrecedence()
    let expression = InfixExpression(token: currentToken,
                                   operator: currentToken.literal,
                                   left: left)
    nextToken()
    expression.right = parseExpression(precedence: precedence)
    return expression
  }

  private func peekPrecedence() -> Int {
    return precedences[peekToken.literal] ?? 0
  }

  private func currentPrecedence() -> Int {
    return precedences[currentToken.literal] ?? 0
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
