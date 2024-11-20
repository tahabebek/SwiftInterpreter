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
    // defer { if log { print("Token: \(String(describing: token))") } }
    readChar()
    guard let currentChar else {
      token = .init(tokenType: .eof, literal: "")
      return token
    }

    switch currentChar {
    case "=": token = readEqual()
    case ";": token = .init(tokenType: .semicolon, literal: ";")
    case "(": token = .init(tokenType: .openingParen, literal: "(")
    case ")": token = .init(tokenType: .closingParen, literal: ")")
    case "{": token = .init(tokenType: .openingBrace, literal: "{")
    case "}": token = .init(tokenType: .closingBrace, literal: "}")
    case ",": token = .init(tokenType: .comma, literal: ",")
    case ":": token = .init(tokenType: .colon, literal: ":")
    case "\n": token = .init(tokenType: .newLine, literal: "\n")
    case "_": token = .init(tokenType: .underscore, literal: "_")
    case "-": token = readDash()
    case ".": token = readDot()
    case "!": token = readBang()
    case " ":
      token = nextToken(log: false)
    default:
      if let operatorIdentifier = Token.operators[String(currentChar)] {
        token = operatorIdentifier
      } else if currentChar.isLetter {
        let identifier = readIdentifier()
        if Token.keywords[identifier] != nil {
          token = .init(tokenType: .keyword, literal: identifier)
        } else if Token.types[identifier] != nil {
          token = .init(tokenType: .type, literal: identifier)
        } else {
          token = .init(tokenType: .identifier, literal: identifier)
        }
      } else if currentChar.isNumber {
        token = .init(tokenType: .integer, literal: readNumber())
      } else {
        token = .init(tokenType: .illegal, literal: String(currentChar))
      }
    }
    return token
  }

  private func peekChar() -> Character? {
    guard readPosition < input.count else { return nil }
    return input[readPosition]
  }

  private func readBang() -> Token {
    guard let nextChar = peekChar() else { return .init(tokenType: .operator, literal: "!") }
    switch nextChar {
    case "=":
      readChar()
        return .init(tokenType: .operator, literal: "!=")
    default:
      return .init(tokenType: .operator, literal: "!")
    }
  }
  private func readDot() -> Token {
    //.
    guard let nextChar = peekChar() else { return .init(tokenType: .illegal, literal: ".") }
    switch nextChar {
    case ".":
      readChar()
      //..
      guard let nextChar = peekChar() else { return .init(tokenType: .inclusiveRange, literal: "..") }
      switch nextChar {
      case "<":
        readChar()
        // ..<
        return .init(tokenType: .nonInclusiveRange, literal: "..<")
      case " ":
        readChar()
        // ..
          return .init(tokenType: .inclusiveRange, literal: "..")
      default:
        return .init(tokenType: .illegal, literal: ".")
      }
    default:
      return .init(tokenType: .illegal, literal: ".")
    }
  }

  private func readEqual() -> Token {
    guard let nextChar = peekChar() else { return .init(tokenType: .illegal, literal: "=") }
    switch nextChar {
    case " ":
      return .init(tokenType: .assign, literal: "=")
    case "=":
      readChar()
        return .init(tokenType:.operator, literal: "=")
    default:
      return .init(tokenType: .illegal, literal: "=")
    }
  }

  private func readDash() -> Token {
    guard let nextChar = peekChar() else { return .init(tokenType: .illegal, literal: "-") }
    switch nextChar {
    case " ",
        _ where input[readPosition].isNumber:
      return .init(tokenType: .operator, literal: "-")
    case ">":
      readChar()
      return .init(tokenType: .keyword, literal: "->")
    default:
      return .init(tokenType: .illegal, literal: "-")
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
      if token.tokenType == .eof {
        shouldStop = true
      }
      return token
    }
  }

  func makeIterator() -> LexerIterator {
    LexerIterator(lexer: self)
  }
}
