
// let <identifier> = <expression>
// expressions produce values, statements do not.
protocol Statement {
    var node: Node { get }
}

protocol Expression {
    var node: Node { get }
}

protocol Node {
    var tokenLiteral: String { get }
}

struct Program {
    let statements: [Statement]
}

