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
        let statement = program.statements[index]
        assert(testLetStatement(statement: statement) == true)
    }
  }

  func testLetStatement(statement: Statement) -> Bool {
    guard let _ = statement as? LetStatement else {
      return false
    }
    guard statement.tokenLiteral() == "let" else {
      return false
    }
    return true
  }
}
