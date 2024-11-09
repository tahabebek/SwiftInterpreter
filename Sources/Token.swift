//
//  Token.swift
//  Interpreter
//
//  Created by Taha Bebek on 11/8/24.
//

enum Token: Equatable {
  case illegal
  case eof
  case identifier(String)
  case integer(String)
  case assign
  case comma
  case semicolon
  case openingParen
  case closingParen
  case openingBrace
  case closingBrace
  case function
  case colon
  case `let`
  case `if`
  case `else`
  case `return`
  case `true`
  case `false`
  case `null`
  case `while`
  case `for`
  case `break`
  case `continue`
  case `struct`
  case type(String)
  case `operator`(Operator)
  case arrow
  case underscore
  case closedRange
  case openRange
  case inclusiveRange
  case `in`

  var rawValue: String {
    switch self {
    case .identifier(let identifier): return "identifier(\(identifier))"
    case .integer(let integer): return "integer(\(integer))"
    case .type(let type): return "type(\(type))"
    case .operator(let identifier): return "operator(\(identifier))"
    case .illegal:
      return "illegal"
    case .eof:
      return "eof"
    case .assign:
      return "assign"
    case .comma:
      return "comma"
    case .semicolon:
      return "semicolon"
    case .openingParen:
      return "openingParen"
    case .closingParen:
      return "closingParen"
    case .openingBrace:
      return "openingBrace"
    case .closingBrace:
      return "closingBrace"
    case .function:
      return "function"
    case .colon:
      return "colon"
    case .let:
      return "let"
    case .if:
      return "if"
    case .else:
      return "else"
    case .return:
      return "return"
    case .true:
      return "true"
    case .false:
      return "false"
    case .null:
      return "null"
    case .while:
      return "while"
    case .for:
      return "for"
    case .break:
      return "break"
    case .continue:
      return "continue"
    case .struct:
      return "struct"
    case .arrow:
      return "arrow"
    case .underscore:
      return "underscore"
    case .closedRange:
      return "closedRange"
    case .openRange:
      return "openRange"
    case .inclusiveRange:
      return "inclusiveRange"
    case .in:
      return "in"
    }
  }

  var value: String {
    switch self {
    case .identifier(let identifier): return identifier
    case .integer(let integer): return integer
    case .type(let type): return type
    case .operator(let identifier): return identifier.rawValue
    default: return ""
    }
  }

  static var keywords: [String: Token] {
    [
      "func": .function,
      "let": .let,
      "if": .if,
      "else": .else,
      "return": .return,
      "true": .true,
      "false": .false,
      "null": .null,
      "while": .while,
      "for": .for,
      "break": .break,
      "continue": .continue,
      "struct": .struct,
      "->": .arrow,
      "in": .in,
    ]
  }

  enum Operator: String {
    case plus = "+"
    case minus = "-"
    case slash = "/"
    case asterisk = "*"
    case lessThan = "<"
    case greaterThan = ">"
    case equal = "=="
  }

  static var operators: [String: Token] {
    [
      "+": .operator(.plus),
      "-": .operator(.minus),
      "/": .operator(.slash),
      "*": .operator(.asterisk),
      "<": .operator(.lessThan),
      ">": .operator(.greaterThan),
      "==": .operator(.equal),
    ]
  }

  static var types: [String: Token] {
    [
      "Int": .type("Int"),
      "String": .type("String"),
    ]
  }

  static func == (lhs: Token, rhs: Token) -> Bool {
    lhs.rawValue == rhs.rawValue
  }
}
