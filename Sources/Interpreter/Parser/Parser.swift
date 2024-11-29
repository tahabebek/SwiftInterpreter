struct Parser {
  let lexer: Lexer
  var tracing: ParserTracing = ParserTracing()
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
    registerPrefix(expressionType: Token(tokenType: .keyword, literal: "true").expressionType, function: { parser in parser.parseBooleanLiteral() })
    registerPrefix(expressionType: Token(tokenType: .keyword, literal: "false").expressionType, function: { parser in parser.parseBooleanLiteral() })
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

  private mutating func parseReturnStatement() -> ReturnStatement? {
    var statement = ReturnStatement(token: currentToken)
    nextToken()

    if !peekTokenIs(token: .newLine), !peekTokenIs(token: .eof) {
      nextToken()
      statement.returnValue = parseExpression(precedence: .lowest)
    }
    nextToken()
    
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
      
    if !peekTokenIs(token: .newLine), !peekTokenIs(token: .eof) {
      nextToken()
      statement.value = parseExpression(precedence: .lowest)
    }
    nextToken()

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
    tracing.trace(msg: "parseExpressionStatement")
    defer { tracing.untrace(msg: "parseExpressionStatement") }
    var statement = ExpressionStatement(token: currentToken)
    statement.expression = parseExpression(precedence: .lowest)
    while !peekTokenIs(token: .newLine), !peekTokenIs(token: .eof) {
      nextToken()
    }
    return statement
  }

  private mutating func parseExpression(precedence: Precedence) -> Expression {
    tracing.trace(msg: "parseExpression")
    defer { tracing.untrace(msg: "parseExpression") }
    guard let prefixFunction = prefixParseFunctions[currentToken.expressionType] else {
      fatalError("no prefix parse function for \(currentToken.expressionType)")
    }
    var leftExpression = prefixFunction(&self)

    while !peekTokenIs(token: .newLine), !peekTokenIs(token: .eof), precedence < (peekPrecedence() ?? .lowest) {
      guard let infixFunction = infixParseFunctions[peekToken.expressionType] else {
        return leftExpression
      }
      nextToken()
      leftExpression = infixFunction(&self, leftExpression)
    }
    return leftExpression
  }

  private mutating func parsePrefixExpression() -> PrefixExpression {
    tracing.trace(msg: "parsePrefixExpression")
    defer { tracing.untrace(msg: "parsePrefixExpression") }
    var expression = PrefixExpression(token: currentToken, operator: currentToken.literal)
    nextToken()
    expression.right = parseExpression(precedence: .prefix)
    return expression
  }

  private mutating func parseInfixExpression(precedence: Precedence, left: Expression) -> InfixExpression {
    tracing.trace(msg: "parseInfixExpression")
    defer { tracing.untrace(msg: "parseInfixExpression") }
    var expression = InfixExpression(token: currentToken, left: left, operator: currentToken.literal)
    let precedence = currentPrecedence() ?? .lowest
    nextToken()
    expression.right = parseExpression(precedence: precedence)
    return expression
  }

  private func parseIdentifier() -> Identifier {
    Identifier(token: currentToken, value: currentToken.literal)
  }

  private mutating func parseIntegerLiteral() -> IntegerLiteral {
    tracing.trace(msg: "parseIntegerLiteral")
    defer { tracing.untrace(msg: "parseIntegerLiteral") }
    return IntegerLiteral(token: currentToken, value: Int(currentToken.literal)!)
  }

  private mutating func parseBooleanLiteral() -> BooleanLiteral {
    tracing.trace(msg: "parseBooleanLiteral")
    defer { tracing.untrace(msg: "parseBooleanLiteral") }
    return BooleanLiteral(token: currentToken, value: currentToken.literal == "true")
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


