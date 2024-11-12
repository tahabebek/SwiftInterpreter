import Testing

@testable import Interpreter

@Suite
struct ParserTests {
  @Test("Test let statement")
  func testLetStatements() {
    let input = """
    let x = 5
    let y = 10
    let foobar = 838383
    """

    let lexer = Lexer(input: input)
    var parser = Parser(lexer: lexer)
    let program = parser.parseProgram()
    assert(program.statements.count == 3)

    let expectedIdentifiers = ["x", "y", "foobar"]

    for index in expectedIdentifiers.indices {
        guard let statement = program.statements[index] as? LetStatement else {
            assert(false)
        }
        assert(testLetStatement(statement: statement, name: expectedIdentifiers[index]) == true)
    }
  }


  func testLetStatement(statement: Statement, name: String) -> Bool {
    guard let letStatement = statement as? LetStatement else {
      print("Error:".red, "Expected a let statement")
      return false
    }

    print("Info:".magenta, letStatement)
    guard letStatement.tokenLiteral() == "let" else {
      print("Error:".red, "Expected a let statement with token literal 'let'")
      return false
    }

    guard letStatement.name.value == name else {
      print("Error:".red, "Expected a let statement with name \(name)")
      return false
    }
    guard letStatement.name.tokenLiteral() == name else {
      print("Error:".red, "Expected a let statement with token literal \(name)")
      return false
    }

    return true
  }
}
