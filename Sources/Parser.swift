
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
        while({ () -> Bool in
            switch currentToken {
            case .eof: return false
            default: return true
            }
        })() {
            if let statement = parseStatement() {
                program.addStatement(statement)
            }
            nextToken()
        }
        return program
    }

    mutating func parseStatement() -> Statement? {
        switch currentToken {
        case .keyword(.let):
            return parseLetStatement()
        default:
            return nil
        }
    }

    func currentTokenIs(token: Token) -> Bool {
        return currentToken == token
    }

    func peekTokenIs(token: Token) -> Bool {
        return peekToken == token
    }

    mutating func parseLetStatement() -> LetStatement? {
        /* TODO: figure out how to make this work
        guard peekTokenIs(token: .identifier("")) else {
            return nil
        }
        */
        guard case .identifier(_) = peekToken else {
            return nil
        }
        let name = Identifier(token: peekToken, value: peekToken.literal)
        let statement = LetStatement(token: currentToken, name: name)
        nextToken()
        guard case .assign = peekToken else {
            return nil
        }
        while({ () -> Bool in
            switch currentToken {
            case .newLine, .eof: return false
            default: return true
            }
        })() {
            nextToken()
        }
        return statement
    }
}
