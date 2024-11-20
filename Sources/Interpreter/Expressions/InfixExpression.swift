import Foundation

struct InfixExpression: Expression {
    let token: Token
    var left: Expression?
    var `operator`: String?
    var right: Expression?

    func tokenLiteral() -> String {
        return token.literal
    }

    func expressionNode() {}

    var description: String {
        return "(\(token.literal)\(left?.description ?? "") \(`operator` ?? "") \(right?.description ?? ""))"
    }
}
