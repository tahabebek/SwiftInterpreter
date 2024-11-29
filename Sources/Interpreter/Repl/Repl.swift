struct Repl {
    static let PROMPT = ">> "
    static let CONTINUATION_PROMPT = "... "
    
    static func start() {
        while true {
            print(PROMPT, terminator: "")
            
            var lines = [String]()
            while let line = readLine() {
                // Exit command
                if lines.isEmpty && line.lowercased() == "exit" {
                    print("Goodbye!")
                    return
                }
                
                // Empty line ends the input
                if line.isEmpty {
                    break
                }
                
                lines.append(line)
                print(CONTINUATION_PROMPT, terminator: "")
            }
            
            // Handle EOF (Ctrl+D)
            guard !lines.isEmpty else {
                print("\nGoodbye!")
                return
            }
            
            // Join all lines and process
            let input = lines.joined(separator: "\n")
            let lexer = Lexer(input: input)
            
            for token in lexer {
                print(token)
            }
        }
    }
}
