import Foundation

enum DebugOutputType {
    case `deinit`(object: AnyObject)
    case debug(message: String)
    case log(message: String)
    case error(error: String)
    case fatalError(error: String)
    
    var rawValue: String {
        switch self {
        case .deinit:
            return "- deinit"
        case .debug:
            return "- debug"
        case .log:
            return "- log"
        case .error:
            return "- error"
        case .fatalError:
            return "- FATAL"
        }
    }
    
    var emoji: String {
        switch self {
        case .deinit:
            return "♻️"
        case .debug:
            return "🚾"
        case .log:
            return "❕"
        case .error:
            return "⚠️"
        case .fatalError:
            return "🚫"
        }
    }
    
    var message: String? {
        switch self {
        case .deinit(let object):
            return NSStringFromClass(type(of: object))
        case .debug(let message):
            return message
        case .log(let message):
            return message
        case .error(let error):
            return error
        case .fatalError(let error):
            return error.uppercased()
        }
    }
}

func print(
    _ debugOutputType: DebugOutputType,
    fileName: String = #file,
    line: Int = #line,
    column: Int = #column,
    functionName: String = #function
    ) {
    
    debugOutput.print(
        outputType: debugOutputType.rawValue,
        outputEmoji: debugOutputType.emoji,
        message: debugOutputType.message,
        fileName: fileName,
        line: line,
        column: column,
        functionName: functionName
    )
}

private var debugOutput: DebugOutput = DebugOutput()

private struct DebugOutput {
    
    // MARK: - Date formatter
    
    private let debugOutputDateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    fileprivate lazy var debugOutputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = debugOutputDateFormat
        return formatter
    }()
    
    //  MARK: - Helpers
    
    private func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    // MARK: - Print
    
    func print(
        outputType debugOutputType: String,
        outputEmoji debugOutputEmoji: String,
        message: String?,
        fileName: String = #file,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
        ) {

        let date = Date().toDebugOutputString()
        let debugType = debugOutputType.padding(toLength: 9, withPad: " ", startingAt: 0)
        let outputEmoji = debugOutputEmoji
        let fileName = sourceFileName(filePath: fileName).padding(toLength: 40, withPad: " ", startingAt: 0)
        let functionName = functionName.padding(toLength: 50, withPad: " ", startingAt: 0)
        let lineAndColumn = ":\(line):\(column)".padding(toLength: 10, withPad: " ", startingAt: 0)
        var stringToPrint = "\(date) "
        stringToPrint += "\(debugType)\(outputEmoji) \(fileName)  \(functionName) \(lineAndColumn)"
        if let message = message {
            stringToPrint += " :: \(message)"
        }
        Swift.print(stringToPrint)
    }
}

// MARK: - Date convinient extension

private extension Date {
    func toDebugOutputString() -> String {
        return debugOutput.debugOutputDateFormatter.string(from: self)
    }
}

