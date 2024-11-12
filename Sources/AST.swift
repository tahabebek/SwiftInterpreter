/*
AST representation:

Program (Root)
    |
    +-- statements [Statement]
         |
         +-- LetStatement
              |
              +-- token: Token (let)
              |
              +-- name: Identifier
              |    |
              |    +-- token: Token (some_name)
              |
              +-- value: Expression (...)

Note: The Expression under value can be any valid expression node,
which will be implemented as we add more expression types.
*/

// let <identifier> = <expression>
// expressions produce values, statements do not.

struct Program {
    var statements: [Statement] = []

    /*
    func tokenLiteral() -> String {
        if !statements.isEmpty {
            return statements.first!.tokenLiteral()
        }
        return ""
    }
    */

    mutating func addStatement(_ statement: Statement) {
        statements.append(statement)
    }
}

protocol Node {
    func tokenLiteral() -> String
}

protocol Statement: Node {
    func statementNode()
}

protocol Expression: Node {
    func expressionNode()
}

struct LetStatement: Statement, CustomStringConvertible {
    let token: Token
    var name: Identifier
    /*
    var value: Expression?
    */

    func statementNode() {}
    func tokenLiteral() -> String {
        return token.literal
    }

    var description: String {
        return "let \(name.value) = ...."
    }
}

struct Identifier: Expression {
    let token: Token
    var value: String

    func expressionNode() {}
    func tokenLiteral() -> String {
        return token.literal
    }
}
