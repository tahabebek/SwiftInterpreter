struct Parser {
  let lexer: Lexer
  var currentToken: Token
  var peekToken: Token
  var errors: [String] = []
  var prefixParseFunctions: [Token.ExpressionType: PrefixParseFunction] = [:]
  var infixParseFunctions: [Token.ExpressionType: InfixParseFunction] = [:]

  init(lexer: Lexer) {
    self.lexer = lexer
    currentToken = lexer.nextToken()
    peekToken = lexer.nextToken()

    registerPrefix(expressionType: Token(tokenType: .identifier, literal: "").expressionType, function: { parser in parser.parseIdentifier() })
    registerPrefix(expressionType: Token(tokenType: .integer, literal: "").expressionType, function: { parser in parser.parseIntegerLiteral() })
    registerPrefix(expressionType: Token(tokenType: .operator, literal: "!").expressionType, function: { parser in parser.parsePrefixExpression() })
    registerPrefix(expressionType: Token(tokenType: .operator, literal: "-").expressionType, function: { parser in parser.parsePrefixExpression() })

    registerInfix(expressionType: Token(tokenType: .operator, literal: "+").expressionType, function: { parser, left in parser.parseInfixExpression(precedence: .sum, left: left) })
    registerInfix(expressionType: Token(tokenType: .operator, literal: "-").expressionType, function: { parser, left in parser.parseInfixExpression(precedence: .sum, left: left) })
    registerInfix(expressionType: Token(tokenType: .operator, literal: "*").expressionType, function: { parser, left in parser.parseInfixExpression(precedence: .product, left: left) })
    registerInfix(expressionType: Token(tokenType: .operator, literal: "/").expressionType, function: { parser, left in parser.parseInfixExpression(precedence: .product, left: left) })
    registerInfix(expressionType: Token(tokenType: .operator, literal: "==").expressionType, function: { parser, left in parser.parseInfixExpression(precedence: .equals, left: left) })
    registerInfix(expressionType: Token(tokenType: .operator, literal: "!=").expressionType, function: { parser, left in parser.parseInfixExpression(precedence: .equals, left: left) })
    registerInfix(expressionType: Token(tokenType: .operator, literal: ">").expressionType, function: { parser, left in parser.parseInfixExpression(precedence: .lessGreater, left: left) })
    registerInfix(expressionType: Token(tokenType: .operator, literal: "<").expressionType, function: { parser, left in parser.parseInfixExpression(precedence: .lessGreater, left: left) })
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
      return parseExpressionStatement()
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

// MARK: - Expressions
extension Parser {
  private mutating func parseExpressionStatement() -> ExpressionStatement {
    var statement = ExpressionStatement(token: currentToken)
    statement.expression = parseExpression(precedence: .lowest)
    while !peekTokenIs(token: .newLine), !peekTokenIs(token: .eof) {
      nextToken()
    }
    return statement
  }

  private mutating func parseExpression(precedence: Precedence) -> Expression {
    guard let prefixFunction = prefixParseFunctions[currentToken.expressionType] else {
      fatalError("no prefix parse function for \(currentToken.expressionType)")
    }
    var leftExpression = prefixFunction(&self)

    while !peekTokenIs(token: .newLine), !peekTokenIs(token: .eof), (peekPrecedence() ?? .lowest) > precedence {
      guard let infixFunction = infixParseFunctions[peekToken.expressionType] else {
        return leftExpression
      }
      nextToken()
      leftExpression = infixFunction(&self, leftExpression)
    }
    return leftExpression
  }

  private mutating func parsePrefixExpression() -> PrefixExpression {
    var expression = PrefixExpression(token: currentToken, operator: currentToken.literal)
    nextToken()
    expression.right = parseExpression(precedence: .prefix)
    return expression
  }

  private mutating func parseInfixExpression(precedence: Precedence, left: Expression) -> InfixExpression {
    var expression = InfixExpression(token: currentToken, operator: currentToken.literal)
    expression.left = left
    nextToken()
    expression.right = parseExpression(precedence: currentPrecedence() ?? .lowest)
    return expression
  }

  private func parseIdentifier() -> Identifier {
    Identifier(token: currentToken, value: currentToken.literal)
  }

  private func parseIntegerLiteral() -> IntegerLiteral {
    IntegerLiteral(token: currentToken, value: Int(currentToken.literal)!)
  }

  private mutating func registerPrefix(expressionType: Token.ExpressionType, function: @escaping PrefixParseFunction) {
    prefixParseFunctions[expressionType] = function
  }

  private mutating func registerInfix(expressionType: Token.ExpressionType, function: @escaping InfixParseFunction) {
    infixParseFunctions[expressionType] = function
  }

  private func peekPrecedence() -> Precedence? {
    return peekToken.precedence
  }

  private func currentPrecedence() -> Precedence? {
    return currentToken.precedence
  }
}


