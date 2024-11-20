import Foundation

struct PrefixExpression: Expression {
    let token: Token
    let `operator`: String
    var right: Expression?

    func tokenLiteral() -> String {
        return token.literal
    }

    func expressionNode() {}

    var description: String {
        return "(\(`operator`)\(right?.description ?? "")"
    }
}
