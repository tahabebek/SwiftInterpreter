
struct Parser {
    let lexer: Lexer
    var currentToken: Token
    var peekToken: Token

    init(lexer: Lexer) {
        self.lexer = lexer
        currentToken = lexer.nextToken()
        peekToken = lexer.nextToken()
    }

    private mutating func nextToken() {
        currentToken = peekToken
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

    mutating func parseStatement() -> Statement? {
        switch currentToken.tokenType {
        case .keyword:
            return parseLetStatement()
        default:
            return nil
        }
    }

    func currentTokenIs(token: TokenType) -> Bool {
        return currentToken.tokenType == token
    }

    func peekTokenIs(token: TokenType) -> Bool {
        return peekToken.tokenType == token
    }

    mutating func parseLetStatement() -> LetStatement? {
        guard peekTokenIs(token: .identifier) else {
            return nil
        }

        let name = Identifier(token: peekToken, value: peekToken.literal)
        let statement = LetStatement(token: currentToken, name: name)
        nextToken()
        guard peekTokenIs(token: .assign) else {
            return nil
        }
        
        while !peekTokenIs(token: .newLine), !peekTokenIs(token: .eof) {
            nextToken()
        }
        return statement
    }
}
