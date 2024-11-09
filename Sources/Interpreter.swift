// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser

// Front-end                     Back-end (LLVM)
// ┌────────────────────────┐    ┌─────────────────────────┐
// Swift → Swift Compiler → IR → LLVM → Machine Code → Binary

// Swift Code → SwiftSyntax → AST → Sema → SILGen → IRGen → LLVM Backend
//                                  ↓       ↓        ↓         ↓
//                                AST →   SIL →   LLVM IR → Machine Code

// https://github.com/swiftlang/swift-syntax
@main
struct Interpreter {
    static func main() {
        print("Welcome to the Lexer REPL!")
        print("Type 'exit' to quit")
        print("Enter your code:")
        
        Repl.start()
    }
}
