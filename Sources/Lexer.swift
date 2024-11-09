//
//  Lexer.swift
//  Interpreter
//
//  Created by Taha Bebek on 11/8/24.
//

class Lexer {
  let input: [Character]
  var position: Int = -1
  var readPosition: Int = 0
  var currentChar: Character? = nil

  init(input: String) {
    self.input = Array(input)
  }

  func nextToken(log: Bool = true) -> Token {
    let token: Token
    defer { if log { print("Token: \(String(describing: token))") } }
    readChar()
    guard let currentChar else {
      token = .eof
      return token
    }

    switch currentChar {
    case "=": token = readEqual()
    case ";": token = .semicolon
    case "(": token = .openingParen
    case ")": token = .closingParen
    case "{": token = .openingBrace
    case "}": token = .closingBrace
    case ",": token = .comma
    case ":": token = .colon
    case "_": token = .underscore
    case "-": token = readDash()
    case ".": token = readDot()
    case " ", "\n":
      token = nextToken(log: false)
    default:
      if let operatorIdentifier = Token.operators[currentChar] {
        token = operatorIdentifier
      } else if currentChar.isLetter {
        let identifier = readIdentifier()
        if let keyword = Token.keywords[identifier] {
          token = keyword
        } else if let type = Token.types[identifier] {
          token = type
        } else {
          token = .identifier(identifier)
        }
      } else if currentChar.isNumber {
        token = .integer(readNumber())
      } else {
        token = .illegal
      }
    }
    return token
  }

  private func readDot() -> Token {
    // .
    switch input[readPosition] {
    case ".":
      readChar()
      //..
      switch input[readPosition] {
      case ".":
        readChar()
        // ...
        return .inclusiveRange
      case "<":
        readChar()
        // ..<
        return .closedRange
      case " ":
        readChar()
        // ..
        return .openRange
      default:
        return .illegal
      }
    default:
      return .illegal
    }
  }

  private func readEqual() -> Token {
    switch input[readPosition] {
    case " ":
      return .assign
    case "=":
      readChar()
      return .operator(.equal)
    default:
      return .illegal
    }
  }

  private func readDash() -> Token {
    switch input[readPosition] {
    case " ":
      return .operator(.minus)
    case ">":
      readChar()
      return .arrow
    case _ where input[readPosition].isNumber:
      return .integer("-\(readNumber())")
    default:
      return .illegal
    }
  }

  private func readNumber() -> String {
    let startPosition = position
    while readPosition < input.count,
      input[readPosition].isNumber
    {
      readChar()
    }
    return String(input[startPosition..<readPosition])
  }

  private func readChar() {
    guard readPosition < input.count else {
      currentChar = nil
      return
    }
    currentChar = input[readPosition]
    position = readPosition
    readPosition += 1
  }

  private func readIdentifier() -> String {
    let startPosition = position
    while readPosition < input.count,
      input[readPosition].isLetter
    {
      readChar()
    }
    return String(input[startPosition..<readPosition])
  }
}

extension Lexer: Sequence {
  struct LexerIterator: IteratorProtocol {
    let lexer: Lexer
    var shouldStop: Bool = false

    mutating func next() -> Token? {
      guard !shouldStop else { return nil }
      let token = lexer.nextToken()
      if token == .eof {
        shouldStop = true
      }
      return token
    }
  }

  func makeIterator() -> LexerIterator {
    LexerIterator(lexer: self)
  }
}
