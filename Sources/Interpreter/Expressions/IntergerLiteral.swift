import Foundation

struct IntegerLiteral: Expression {
    let token: Token
    let value: Int
    
    func tokenLiteral() -> String { 
        return token.literal
    }
    func expressionNode() {}
    
    var description: String {
        return value.description
    }
}
