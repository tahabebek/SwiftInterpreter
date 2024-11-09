//
//  Token.swift
//  Interpreter
//
//  Created by Taha Bebek on 11/8/24.
//

enum Token: Equatable {
  case identifier(String)
  case integer(String)
  case keyword(Keyword)
  case `operator`(Operator)
  case `type`(`Type`)
  case illegal
  case eof
  case assign
  case comma
  case semicolon
  case openingParen
  case closingParen
  case openingBrace
  case closingBrace
  case colon
  case underscore
  case nonInclusiveRange
  case inclusiveRange

  var rawValue: String {
    switch self {
    case .identifier(let identifier): return "identifier(\(identifier))"
    case .integer(let integer): return "integer(\(integer))"
    case .operator(let identifier): return "operator(\(identifier))"
    case .keyword(let keyword): return "keyword(\(keyword.rawValue))"
    case .type(let type): return "type(\(type.rawValue))"
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
    case .colon:
      return "colon"
    case .underscore:
      return "underscore"
    case .nonInclusiveRange:
      return "nonInclusiveRange"
    case .inclusiveRange:
      return "inclusiveRange"
    }
  }

  var value: String {
    switch self {
    case .identifier(let identifier): return identifier
    case .integer(let integer): return integer
    case .operator(let identifier): return identifier.rawValue
    case .keyword(let keyword): return keyword.rawValue
    case .type(let type): return type.rawValue
    default: return ""
    }
  }

  enum Keyword: String {
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
    case arrow
    case `in`
  }

  static var keywords: [String: Token] {
    [
      "func": .keyword(.func),
      "let": .keyword(.let),
      "if": .keyword(.if),
      "else": .keyword(.else),
      "return": .keyword(.return),
      "true": .keyword(.true),
      "false": .keyword(.false),
      "null": .keyword(.nil),
      "while": .keyword(.while),
      "for": .keyword(.for),
      "break": .keyword(.break),
      "continue": .keyword(.continue),
      "struct": .keyword(.struct),
      "->": keyword(.arrow),
      "in": .keyword(.in),
      "nil": .keyword(.nil),
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
    case notEqual = "!="
    case bang = "!"
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
      "!=": .operator(.notEqual),
      "!": .operator(.bang),
    ]
  }

  enum `Type`: String {
    case `Int`
    case `String`
    case `Bool`
  }

  static var types: [String: Token] {
    [
      "Int": .type(.Int),
      "String": .type(.String),
      "Bool": .type(.Bool),
    ]
  }

  static func == (lhs: Token, rhs: Token) -> Bool {
    lhs.rawValue == rhs.rawValue
  }
}
