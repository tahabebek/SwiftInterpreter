
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

    mutating func parseLetStatement() -> LetStatement? {
        var statement = LetStatement(token: currentToken)
        guard case .identifier(_) = peekToken else {
            return nil
        }
        statement.name = Identifier(token: currentToken)
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
