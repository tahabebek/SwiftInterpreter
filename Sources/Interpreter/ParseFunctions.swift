import Foundation

typealias PrefixParseFunction = (inout Parser) -> Expression
typealias InfixParseFunction = (inout Parser, Expression) -> Expression
