extension String {
    // Foreground colors
    var red: String { "\u{001B}[31m\(self)\u{001B}[0m" }
    var green: String { "\u{001B}[32m\(self)\u{001B}[0m" }
    var yellow: String { "\u{001B}[33m\(self)\u{001B}[0m" }
    var blue: String { "\u{001B}[34m\(self)\u{001B}[0m" }
    var magenta: String { "\u{001B}[35m\(self)\u{001B}[0m" }
}