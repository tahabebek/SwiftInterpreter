import Testing

@testable import Interpreter

@Suite
struct ParserTests {
    
  @Test(.tags(.statement))
  func letStatement() throws {
    let input = "let x = 5"

    let lexer = Lexer(input: input)
    var parser = Parser(lexer: lexer)
    let program = parser.parseProgram()
    #expect(program.statements.count == 1)

    let expectedIdentifiers = ["x"]
    #expect(program.description == input)

    for index in expectedIdentifiers.indices {
        let statement = try #require(program.statements[index] as? LetStatement)
        #expect(testLetStatement(statement: statement, name: expectedIdentifiers[index]) == true)
    }
  }
    
  @Test(.tags(.statement))
  func letStatements() throws {
    let input = """
    let x = 5
    let y = 10
    let foobar = 838383
    """

    let lexer = Lexer(input: input)
    var parser = Parser(lexer: lexer)
    let program = parser.parseProgram()
    #expect(program.statements.count == 3)

    let expectedIdentifiers = ["x", "y", "foobar"]
    for index in expectedIdentifiers.indices {
        let statement = try #require(program.statements[index] as? LetStatement)
        #expect(testLetStatement(statement: statement, name: expectedIdentifiers[index]) == true)
    }
  }

  @Test(.tags(.statement))
  func returnStatements() throws {
    let input = """
    return 5
    return 10
    return 993322
    """

    let lexer = Lexer(input: input)
    var parser = Parser(lexer: lexer)
    let program = parser.parseProgram()
    #expect(program.statements.count == 3)

    for statement in program.statements {
      let returnStatement = try #require(statement as? ReturnStatement)
      #expect(testReturnStatement(statement: returnStatement) == true)
    }
  }

  @Test(.tags(.expression))
  func booleanLiteralExpression() throws {
    let input = "true"
    let lexer = Lexer(input: input)
    var parser = Parser(lexer: lexer)
    let program = parser.parseProgram()
    print("Info:".magenta, program)
    #expect(program.statements.count == 1)

    let statement = try #require(program.statements[0] as? ExpressionStatement)
    let booleanLiteral = try #require(statement.expression as? BooleanLiteral)
    #expect(booleanLiteral.value == true)
    #expect(booleanLiteral.tokenLiteral() == "true")
  }

  @Test(.tags(.expression))
  func identifierExpression() throws {
    let input = "foobar"
    let lexer = Lexer(input: input)
    var parser = Parser(lexer: lexer)
    let program = parser.parseProgram()
    #expect(program.statements.count == 1)

    let statement = try #require(program.statements[0] as? ExpressionStatement)
    let identifier = try #require(statement.expression as? Identifier)
    #expect(identifier.value == "foobar")
    #expect(identifier.tokenLiteral() == "foobar")
  }
  
  @Test(.tags(.expression))
  func integerLiteralExpression() throws {
    let input = "5"
    let lexer = Lexer(input: input)
    var parser = Parser(lexer: lexer)
    let program = parser.parseProgram()
    #expect(program.statements.count == 1)

    let statement = try #require(program.statements[0] as? ExpressionStatement)
    let literal = try #require(statement.expression as? IntegerLiteral)
    #expect(literal.value == 5)
  }

  @Test(.tags(.expression))
  func bangPrefixExpression() throws {
    let input = "!5"
    let lexer = Lexer(input: input)
    var parser = Parser(lexer: lexer)
    let program = parser.parseProgram()
    #expect(program.statements.count == 1)

    let statement = try #require(program.statements[0] as? ExpressionStatement)
    let prefixExpression = try #require(statement.expression as? PrefixExpression)
    #expect(prefixExpression.token.literal == "!")

    let right = try #require(prefixExpression.right as? IntegerLiteral)
    #expect(right.value == 5)
  }

  @Test(.tags(.expression))
  func minusPrefixExpression() throws {
    let input = "-5"
    let lexer = Lexer(input: input)
    var parser = Parser(lexer: lexer)
    let program = parser.parseProgram()
    #expect(program.statements.count == 1)

    let statement = try #require(program.statements[0] as? ExpressionStatement)
    let prefixExpression = try #require(statement.expression as? PrefixExpression)
    #expect(prefixExpression.operator == "-")

    let right = try #require(prefixExpression.right as? IntegerLiteral)
    #expect(right.value == 5)
  }

  @Test(.tags(.expression))
  func infixExpression() throws {
    let input = "5 + 5"
    let lexer = Lexer(input: input)
    var parser = Parser(lexer: lexer)
    let program = parser.parseProgram()
    #expect(program.statements.count == 1)

    let statement = try #require(program.statements[0] as? ExpressionStatement)
    let infixExpression = try #require(statement.expression as? InfixExpression)
    #expect(infixExpression.left is IntegerLiteral)
    #expect(infixExpression.operator == "+")
    #expect(infixExpression.right is IntegerLiteral)
    #expect(infixExpression.tokenLiteral() == "+")
  }

    @Test(.tags(.expression), arguments: zip([
      "-a * b",
      "-a + b",
      "!-a",
      "a + b + c",
      "a * b * c",
      "a + b * c",
      "a * b + c",
      "5 > 4 == 3 < 4",
      "5 < 4 != 3 > 4",
      "3 + 4 * 5 == 3 * 1 + 4 * 5",
      "true",
      "false",
      "3 > 5 == false",
      "3 < 5 == true",
      "1 + (2 + 3) + 4", "((1 + (2 + 3)) + 4)"
    ],[
      "((-a) * b)",
      "((-a) + b)",
      "(!(-a))",
      "((a + b) + c)",
      "((a * b) * c)",
      "(a + (b * c))",
      "((a * b) + c)",
      "((5 > 4) == (3 < 4))",
      "((5 < 4) != (3 > 4))",
      "((3 + (4 * 5)) == ((3 * 1) + (4 * 5)))",
      "true",
      "false",
      "((3 > 5) == false)",
      "((3 < 5) == true)",
      "((1 + (2 + 3)) + 4)"
    ]))
    func multipleInfixExpressions(input: String, expected: String) throws {
      let lexer = Lexer(input: input)
      var parser = Parser(lexer: lexer)
      let program = parser.parseProgram()
      print("Info:".magenta, program)
      #expect(program.statements.count == 1)

      let statement = try #require(program.statements[0] as? ExpressionStatement)
      let expression = try #require(statement.expression)
      #expect(expression.description == expected)
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
