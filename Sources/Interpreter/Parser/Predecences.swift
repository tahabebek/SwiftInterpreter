enum Precedence: Int, Comparable {
  case lowest
  case equals // ==
  case lessGreater // > or <
  case sum // +
  case product // *
  case prefix // -X or !X
  case call // myFunction(X)

  static func < (lhs: Precedence, rhs: Precedence) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}
