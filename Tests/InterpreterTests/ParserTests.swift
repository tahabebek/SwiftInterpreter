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

  @Test("Test return statement")
  func testReturnStatements() {
    let input = """
    return 5
    return 10
    return 993322
    """

    let lexer = Lexer(input: input)
    var parser = Parser(lexer: lexer)
    let program = parser.parseProgram()

    assert(program.statements.count == 3)

    for statement in program.statements {
      guard let returnStatement = statement as? ReturnStatement else {
        assert(false)
      }
      assert(testReturnStatement(statement: returnStatement) == true)
    }
  }

  @Test("Test identifier expression")
  func testIdentifierExpression() {
    let input = "foobar"
    let lexer = Lexer(input: input)
    var parser = Parser(lexer: lexer)
    let program = parser.parseProgram()
    print("Info:".magenta, program)

    assert(program.statements.count == 1)
    guard let statement = program.statements[0] as? ExpressionStatement else {
      assert(false)
    }

    guard let identifier = statement.expression as? Identifier else {
      assert(false)
    }

    assert(identifier.value == "foobar")
    assert(identifier.tokenLiteral() == "foobar")
  }
  
  @Test("Test integer literal expression")
  func testIntegerLiteralExpression() {
    let input = "5"
    let lexer = Lexer(input: input)
    var parser = Parser(lexer: lexer)
    let program = parser.parseProgram()

    assert(program.statements.count == 1)
    guard let statement = program.statements[0] as? ExpressionStatement else {
      assert(false)
    }

    guard let literal = statement.expression as? IntegerLiteral else {
      assert(false)
    }

    assert(literal.value == 5)
  }

  @Test("Test bang prefix expression")
  func testBangPrefixExpression() {
    let input = "!5"
    let lexer = Lexer(input: input)
    var parser = Parser(lexer: lexer)
    let program = parser.parseProgram()

    assert(program.statements.count == 1)
    guard let statement = program.statements[0] as? ExpressionStatement else {
      assert(false)
    }

    guard let prefixExpression = statement.expression as? PrefixExpression else {
      assert(false)
    }

    guard prefixExpression.token.literal == "!" else {
      assert(false)
    }

    guard let right = prefixExpression.right as? IntegerLiteral, right.value == 5 else {
      assert(false)
    }
  }

  @Test("Test minus prefix expression")
  func testMinusPrefixExpression() {
    let input = "-5"
    let lexer = Lexer(input: input)
    var parser = Parser(lexer: lexer)
    let program = parser.parseProgram()

    guard let statement = program.statements[0] as? ExpressionStatement else {
      assert(false)
    }

    guard let prefixExpression = statement.expression as? PrefixExpression else {
      assert(false)
    }

    guard prefixExpression.operator == "-" else {
      assert(false)
    }

    guard let right = prefixExpression.right as? IntegerLiteral, right.value == 5 else {
      assert(false)
    }
  }

  @Test("Test infix expression")
  func testInfixExpression() {
    let input = "5 + 5"
    let lexer = Lexer(input: input)
    var parser = Parser(lexer: lexer)
    let program = parser.parseProgram()
    print("Info:".magenta, program)

    assert(program.statements.count == 1)
    guard let statement = program.statements[0] as? ExpressionStatement else {
      assert(false)
    }

    guard let infixExpression = statement.expression as? InfixExpression else {
      assert(false)
    }

    assert(infixExpression.left is IntegerLiteral)
    assert(infixExpression.operator == "+")
    assert(infixExpression.right is IntegerLiteral)
    assert(infixExpression.tokenLiteral() == "+")
  }

  @Test("Test infix expressions")
  func testInfixExpressions() {
    let tests = [
      ("-a + b", "((-a) + b)"),
      ("!-a", "(!(-a))"),
      ("a + b + c", "((a + b) + c)"),
      ("a * b * c", "((a * b) * c)"),
      ("a + b * c", "(a + (b * c))"),
      ("a * b + c", "((a * b) + c)"),
      ("3 + 4; -5 * 5", "((3 + 4)((-5) * 5))"),
      ("5 > 4 == 3 < 4", "((5 > 4) == (3 < 4))"),
      ("5 < 4 != 3 > 4", "((5 < 4) != (3 > 4))"),
      ("3 + 4 * 5 == 3 * 1 + 4 * 5", "((3 + (4 * 5)) == ((3 * 1) + (4 * 5)))"),
    ]

    for (input, expected) in tests {
      let lexer = Lexer(input: input)
      var parser = Parser(lexer: lexer)
      let program = parser.parseProgram()
      print("Info:".magenta, program)

      assert(program.statements.count == 1)
      guard let statement = program.statements[0] as? ExpressionStatement else {
        assert(false)
      }

      guard let infixExpression = statement.expression as? InfixExpression else {
        assert(false)
      }

      assert(infixExpression.description == expected)
    }
  }
}

extension ParserTests {
  private func testReturnStatement(statement: Statement) -> Bool {
    guard let returnStatement = statement as? ReturnStatement else {
      print("Error:".red, "Expected a return statement")
      return false
    }
    print("Info:".magenta, returnStatement)
    guard returnStatement.tokenLiteral() == "return" else {
      print("Error:".red, "Expected a return statement with token literal 'return'")
      return false
    }
    return true
  }

  private func testLetStatement(statement: Statement, name: String) -> Bool {
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
