// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser

@main
struct Interpreter {
    static func main() {
        print("Welcome to the Lexer REPL!")
        print("Type 'exit' to quit")
        print("Enter your code:")
        
        Repl.start()
    }
}
