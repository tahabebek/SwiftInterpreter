struct ExpressionStatement: Statement {
    let token: Token // the first token of the expression
    var expression: Expression?

    func tokenLiteral() -> String {
        return token.literal
    }

    func statementNode() {}

    var description: String {
        return expression?.description ?? ""
    }
}
