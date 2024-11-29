import Testing

@testable import Interpreter

@Suite
struct LexerTests {
  @Test(.tags(.lexer))
  func lexer() {
    let input = """
      struct BuildCommand: ParsableCommand {
        func main() -> Int {
          while x < y {
            print(x)
            break
          }
          let y = 0
          for x in 0..<10 {
            if x != 5, y == 0 {
              continue
            }
            y = x!
          }
          let five = 5
          let ten = 10
          let result = add(five, ten)
          return result
        }

        func add(_ x: Int, _ y: Int) -> (Int, Bool) {
            (x - y, true)
        }
      }
      """
    let expectedTokens: [Token] = [
      .init(tokenType: .keyword, literal: "struct"),
      .init(tokenType: .identifier, literal: "BuildCommand"),
      .init(tokenType: .colon, literal: ":"),
      .init(tokenType: .identifier, literal: "ParsableCommand"),
      .init(tokenType: .openingBrace, literal: "{"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .keyword, literal: "func"),
      .init(tokenType: .identifier, literal: "main"),
      .init(tokenType: .openingParen, literal: "("),
      .init(tokenType: .closingParen, literal: ")"),
      .init(tokenType: .keyword, literal: "->"),
      .init(tokenType: .type, literal: "Int"),
      .init(tokenType: .openingBrace, literal: "{"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .keyword, literal: "while"),
      .init(tokenType: .identifier, literal: "x"),
      .init(tokenType: .operator, literal: "<"),
      .init(tokenType: .identifier, literal: "y"),
      .init(tokenType: .openingBrace, literal: "{"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .identifier, literal: "print"),
      .init(tokenType: .openingParen, literal: "("),
      .init(tokenType: .identifier, literal: "x"),
      .init(tokenType: .closingParen, literal: ")"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .keyword, literal: "break"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .closingBrace, literal: "}"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .keyword, literal: "let"),
      .init(tokenType: .identifier, literal: "y"),
      .init(tokenType: .assign, literal: "="),
      .init(tokenType: .integer, literal: "0"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .keyword, literal: "for"),
      .init(tokenType: .identifier, literal: "x"),
      .init(tokenType: .keyword, literal: "in"),
      .init(tokenType: .integer, literal: "0"),
      .init(tokenType: .nonInclusiveRange, literal: "..<"),
      .init(tokenType: .integer, literal: "10"),
      .init(tokenType: .openingBrace, literal: "{"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .keyword, literal: "if"),
      .init(tokenType: .identifier, literal: "x"),
      .init(tokenType: .operator, literal: "!="),
      .init(tokenType: .integer, literal: "5"),
      .init(tokenType: .comma, literal: ","),
      .init(tokenType: .identifier, literal: "y"),
      .init(tokenType: .operator, literal: "=="),
      .init(tokenType: .integer, literal: "0"),
      .init(tokenType: .openingBrace, literal: "{"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .keyword, literal: "continue"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .closingBrace, literal: "}"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .identifier, literal: "y"),
      .init(tokenType: .assign, literal: "="),
      .init(tokenType: .identifier, literal: "x"),
      .init(tokenType: .operator, literal: "!"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .closingBrace, literal: "}"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .keyword, literal: "let"),
      .init(tokenType: .identifier, literal: "five"),
      .init(tokenType: .assign, literal: "="),
      .init(tokenType: .integer, literal: "5"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .keyword, literal: "let"),
      .init(tokenType: .identifier, literal: "ten"),
      .init(tokenType: .assign, literal: "="),
      .init(tokenType: .integer, literal: "10"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .keyword, literal: "let"),
      .init(tokenType: .identifier, literal: "result"),
      .init(tokenType: .assign, literal: "="),
      .init(tokenType: .identifier, literal: "add"),
      .init(tokenType: .openingParen, literal: "("),
      .init(tokenType: .identifier, literal: "five"),
      .init(tokenType: .comma, literal: ","),
      .init(tokenType: .identifier, literal: "ten"),
      .init(tokenType: .closingParen, literal: ")"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .keyword, literal: "return"),
      .init(tokenType: .identifier, literal: "result"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .closingBrace, literal: "}"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .keyword, literal: "func"),
      .init(tokenType: .identifier, literal: "add"),
      .init(tokenType: .openingParen, literal: "("),
      .init(tokenType: .underscore, literal: "_"),
      .init(tokenType: .identifier, literal: "x"),
      .init(tokenType: .colon, literal: ":"),
      .init(tokenType: .type, literal: "Int"),
      .init(tokenType: .comma, literal: ","),
      .init(tokenType: .underscore, literal: "_"),
      .init(tokenType: .identifier, literal: "y"),
      .init(tokenType: .colon, literal: ":"),
      .init(tokenType: .type, literal: "Int"),
      .init(tokenType: .closingParen, literal: ")"),
      .init(tokenType: .keyword, literal: "->"),
      .init(tokenType: .openingParen, literal: "("),
      .init(tokenType: .type, literal: "Int"),
      .init(tokenType: .comma, literal: ","),
      .init(tokenType: .type, literal: "Bool"),
      .init(tokenType: .closingParen, literal: ")"),
      .init(tokenType: .openingBrace, literal: "{"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .openingParen, literal: "("),
      .init(tokenType: .identifier, literal: "x"),
      .init(tokenType: .operator, literal: "-"),
      .init(tokenType: .identifier, literal: "y"),
      .init(tokenType: .comma, literal: ","),
      .init(tokenType: .keyword, literal: "true"),
      .init(tokenType: .closingParen, literal: ")"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .closingBrace, literal: "}"),
      .init(tokenType: .newLine, literal: "\n"),
      .init(tokenType: .closingBrace, literal: "}"),
      .init(tokenType: .eof, literal: ""),
    ]
    let lexer = Lexer(input: input)
    var tokenCount = 0

    for (index, token) in lexer.enumerated() {
      #expect(token == expectedTokens[index])
      tokenCount += 1
    }
    #expect(tokenCount == expectedTokens.count)
  }
}
