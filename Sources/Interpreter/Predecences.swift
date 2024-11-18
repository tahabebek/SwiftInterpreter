enum Precedence: Int {
  case lowest
  case equals // ==
  case lessGreater // > or <
  case sum // +
  case product // *
  case prefix // -X or !X
  case call // myFunction(X)
}
