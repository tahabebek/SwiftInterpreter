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
         |
         +-- ReturnStatement
              |
              +-- token: Token (return)
              |
              +-- returnValue: Expression? (...)
         |
         +-- ExpressionStatement
              |
              +-- token: Token (first token of expression)
              |
              +-- expression: Expression
                   |
                   +-- Identifier
                   |    |
                   |    +-- token: Token (some_name)
                   |    |
                   |    +-- value: String
                   |
                   +-- IntegerLiteral
                   |    |
                   |    +-- token: Token (5)
                   |    |
                   |    +-- value: Int
                   |
                   +-- PrefixExpression
                   |    |
                   |    +-- token: Token (!, -)
                   |    |
                   |    +-- operator: String
                   |    |
                   |    +-- right: Expression
                   |
                   +-- InfixExpression
                        |
                        +-- token: Token (+, -, *, /, etc)
                        |
                        +-- left: Expression
                        |
                        +-- operator: String
                        |
                        +-- right: Expression

Note: The Expression under value and returnValue can be any valid expression node,
which will be implemented as we add more expression types.
*/

// let <identifier> = <expression>
// return <expression>
// <prefix_operator><expression>
// <expression> <infix_operator> <expression>
// expressions produce values, statements do not.










