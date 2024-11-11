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
    case "\n": token = .newLine
    case "_": token = .underscore
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

  private func peekChar() -> Character? {
    guard readPosition < input.count else { return nil }
    return input[readPosition]
  }

  private func readBang() -> Token {
    guard let nextChar = peekChar() else { return .operator(.bang) }
    switch nextChar {
    case " ", "\n":
      return .operator(.bang)
    case "=":
      readChar()
      return .operator(.notEqual)
    default:
      return .illegal
    }
  }
  private func readDot() -> Token {
    //.
    guard let nextChar = peekChar() else { return .illegal }
    switch nextChar {
    case ".":
      readChar()
      //..
      guard let nextChar = peekChar() else { return .inclusiveRange }
      switch nextChar {
      case "<":
        readChar()
        // ..<
        return .nonInclusiveRange
      case " ":
        readChar()
        // ..
        return .inclusiveRange
      default:
        return .illegal
      }
    default:
      return .illegal
    }
  }

  private func readEqual() -> Token {
    guard let nextChar = peekChar() else { return .illegal }
    switch nextChar {
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
    guard let nextChar = peekChar() else { return .illegal }
    switch nextChar {
    case " ":
      return .operator(.minus)
    case ">":
      readChar()
      return .keyword(.arrow)
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
