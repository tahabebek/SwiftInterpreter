//
//  Token.swift
//  Interpreter
//
//  Created by Taha Bebek on 11/8/24.
//

enum TokenType: Equatable {
    case identifier
    case integer
    case keyword
    case `operator`
    case type
    case illegal
    case eof
    case assign
    case comma
    case semicolon
    case newLine
    case openingParen
    case closingParen
    case openingBrace
    case closingBrace
    case colon
    case underscore
    case nonInclusiveRange
    case inclusiveRange
}

struct Token: Equatable {
    let tokenType: TokenType
    let literal: String
}

enum Keyword: String, CaseIterable {
    case `func`
    case `let`
    case `if`
    case `else`
    case `return`
    case `true`
    case `false`
    case `nil`
    case `while`
    case `for`
    case `break`
    case `continue`
    case `struct`
    case arrow = "->"
    case `in`
}

enum Operator: String, CaseIterable {
    case plus = "+"
    case minus = "-"
    case slash = "/"
    case asterisk = "*"
    case lessThan = "<"
    case greaterThan = ">"
    case equal = "=="
    case notEqual = "!="
    case bang = "!"
 }

enum `Type`: String, CaseIterable {
    case `Int`
    case `String`
    case `Bool`
  }

extension Token {
    static let keywords: [String: Token] = Dictionary(
        uniqueKeysWithValues: Keyword.allCases.map { keyword in
            (keyword.rawValue, Token(tokenType: .keyword, literal: keyword.rawValue))
        }
    )

    static let operators: [String: Token] = Dictionary(
        uniqueKeysWithValues: Operator.allCases.map { `operator` in
            (`operator`.rawValue, Token(tokenType: .operator, literal: `operator`.rawValue))
        }
    )

    static let types: [String: Token] = Dictionary(
        uniqueKeysWithValues: Type.allCases.map { `type` in
            (`type`.rawValue, Token(tokenType: .type, literal: `type`.rawValue))
        }
    )
}
