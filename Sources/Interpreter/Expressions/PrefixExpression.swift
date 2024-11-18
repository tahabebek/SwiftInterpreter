import Foundation

struct PrefixExpression: Expression {
    let token: Token
    var right: Expression?

    func tokenLiteral() -> String {
        return token.literal
    }

    func expressionNode() {}

    var description: String {
        return "(\(token.literal)\(right?.description ?? "")"
    }
}
