import Testing

@testable import Interpreter

@Suite
struct LexerTests {
  @Test("Lexer with for")
  func nextTokenWithFor() {
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
      .keyword(.struct),
      .identifier("BuildCommand"),
      .colon,
      .identifier("ParsableCommand"),
      .openingBrace,
      .keyword(.func),
      .identifier("main"),
      .openingParen,
      .closingParen,
      .keyword(.arrow),
      .type(.Int),
      .openingBrace,
      .keyword(.while),
      .identifier("x"),
      .operator(.lessThan),
      .identifier("y"),
      .openingBrace,
      .identifier("print"),
      .openingParen,
      .identifier("x"),
      .closingParen,
      .keyword(.break),
      .closingBrace,
      .keyword(.let),
      .identifier("y"),
      .assign,
      .integer("0"),
      .keyword(.for),
      .identifier("x"),
      .keyword(.in),
      .integer("0"),
      .nonInclusiveRange,
      .integer("10"),
      .openingBrace,
      .keyword(.if),
      .identifier("x"),
      .operator(.notEqual),
      .integer("5"),
      .comma,
      .identifier("y"),
      .operator(.equal),
      .integer("0"),
      .openingBrace,
      .keyword(.continue),
      .closingBrace,
      .identifier("y"),
      .assign,
      .identifier("x"),
      .operator(.bang),
      .closingBrace,
      .keyword(.let),
      .identifier("five"),
      .assign,
      .integer("5"),
      .keyword(.let),
      .identifier("ten"),
      .assign,
      .integer("10"),
      .keyword(.let),
      .identifier("result"),
      .assign,
      .identifier("add"),
      .openingParen,
      .identifier("five"),
      .comma,
      .identifier("ten"),
      .closingParen,
      .keyword(.return),
      .identifier("result"),
      .closingBrace,
      .keyword(.func),
      .identifier("add"),
      .openingParen,
      .underscore,
      .identifier("x"),
      .colon,
      .type(.Int),
      .comma,
      .underscore,
      .identifier("y"),
      .colon,
      .type(.Int),
      .closingParen,
      .keyword(.arrow),
      .openingParen,
      .type(.Int),
      .comma,
      .type(.Bool),
      .closingParen,
      .openingBrace,
      .openingParen,
      .identifier("x"),
      .operator(.minus),
      .identifier("y"),
      .comma,
      .keyword(.true),
      .closingParen,
      .closingBrace,
      .closingBrace,
      .eof,
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
