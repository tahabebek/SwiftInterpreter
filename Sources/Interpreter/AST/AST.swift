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

Note: The Expression under value and returnValue can be any valid expression node,
which will be implemented as we add more expression types.
*/

// let <identifier> = <expression>
// expressions produce values, statements do not.










