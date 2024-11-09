import Testing

@testable import Interpreter

@Suite
struct LexerTests {
  @Test("Lexer with function and let")
  func nextTokenWithFunctionAndLet() {
    let input = """
      let five = 5
      let ten = 10

      func add(_ x: Int, _ y: Int) -> Int {
        x - y
      }

      let result = add(five, ten)
      """
    let expectedTokens: [Token] = [
      .let,
      .identifier("five"),
      .assign,
      .integer("5"),
      .let,
      .identifier("ten"),
      .assign,
      .integer("10"),
      .function,
      .identifier("add"),
      .openingParen,
      .underscore,
      .identifier("x"),
      .colon,
      .type("Int"),
      .comma,
      .underscore,
      .identifier("y"),
      .colon,
      .type("Int"),
      .closingParen,
      .arrow,
      .type("Int"),
      .openingBrace,
      .identifier("x"),
      .operator(.minus),
      .identifier("y"),
      .closingBrace,
      .let,
      .identifier("result"),
      .assign,
      .identifier("add"),
      .openingParen,
      .identifier("five"),
      .comma,
      .identifier("ten"),
      .closingParen,
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
            if x == 5 {
              continue
            }
            y = x
          }
          return y
        }
      }
      """
    let expectedTokens: [Token] = [
      .struct,
      .identifier("BuildCommand"),
      .colon,
      .identifier("ParsableCommand"),
      .openingBrace,
      .function,
      .identifier("main"),
      .openingParen,
      .closingParen,
      .arrow,
      .type("Int"),
      .openingBrace,
      .while,
      .identifier("x"),
      .operator(.lessThan),
      .identifier("y"),
      .openingBrace,
      .identifier("print"),
      .openingParen,
      .identifier("x"),
      .closingParen,
      .break,
      .closingBrace,
      .let,
      .identifier("y"),
      .assign,
      .integer("0"),
      .for,
      .identifier("x"),
      .in,
      .integer("0"),
      .closedRange,
      .integer("10"),
      .openingBrace,
      .if,
      .identifier("x"),
      .operator(.equal),
      .integer("5"),
      .openingBrace,
      .continue,
      .closingBrace,
      .identifier("y"),
      .assign,
      .identifier("x"),
      .closingBrace,
      .return,
      .identifier("y"),
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
