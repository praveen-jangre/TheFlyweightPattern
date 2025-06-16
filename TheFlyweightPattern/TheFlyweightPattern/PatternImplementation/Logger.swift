//
//  Logger.swift
//  TheFlyweightPattern
//
//  Created by Praveen Jangre on 16/06/2025.
//

import Foundation

public protocol Logging {
    var subsystem: String { get }
    var category: String { get }
    
    init(subsystem: String, category: String, printer: PrinterType)
    
    func output(_ message: String,
                type: LogType,
                file: String,
                function: String,
                line:Int)
}

public enum LogType {
    case info, warning, error
}

extension LogType: CustomStringConvertible {
    public var description: String {
        switch (self) {
        case .info:
            return "INFO"
        case .warning:
            return "WARNING"
        case .error:
            return "ERROR"
        }
    }
}

public class Logger: Logging {
    public func output(_ message: String, type: LogType, file: String, function: String, line: Int) {
        
    }
    
    public let subsystem: String
    public let category: String
    
    public let printer: Printer
    
    required public init(subsystem: String, category: String, printer: PrinterType) {
        
        self.subsystem = subsystem
        self.category = category
        
        self.printer = PrinterFactory.printer(for: subsystem, category: category, type: printer)
    }
    
    
    public func log(_ message: String,
                    type: LogType,
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {
        printer.output(message, type: type, file: file, function: function, line: line)
    }
}

public enum PrinterType: String {
    case console, file
}

public protocol Printer: AnyObject {
    func output(_ message: String,
                type: LogType,
                file: String,
                function: String,
                line: Int)
}

public class ConsolePrinter: Printer {
    
    private let syncQueue = DispatchQueue(label: "ConsolePrinterQueue")
    public func output(_ message: String,
                       type: LogType,
                       file: String,
                       function: String,
                       line: Int) {
        syncQueue.async {
            let message = "\(type) [\(file) \(function) line# \(line)] \(message)"
            print(message)
        }
        
    }
}

public class FilePrinter: Printer {
    
    private let syncQueue = DispatchQueue(label: "FilePrinterSyncQueue")
    public let logFileURL: URL?
    
    init () {
        guard let documentsURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            logFileURL = nil
            return
        }
        // create the File URL
        let logFile = "logs.txt"
        logFileURL = documentsURL.appendingPathComponent(logFile)
    }
    
    public func output(_ message: String,
                       type: LogType,
                       file: String,
                       function: String,
                       line: Int) {
        
        syncQueue.async {
            guard let fileURL = self.logFileURL else { return }
            
            let message = "\(type) [\(file) \(function) line# \(line)] \(message)"
            try? message.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        
        
    }
    
    
}


struct PrinterFactory {
    private static var printersByID = [String: Printer]()
    
    static func printer(for subsystem: String,
                        category: String,
                        type: PrinterType) -> Printer {
        let key = subsystem + category + type.rawValue
        if let existingPrinter = printersByID[key] {
            return existingPrinter
        } else {
            let newPrinter: Printer
            switch type {
            case .console:
                newPrinter = ConsolePrinter()
            case .file:
                newPrinter = FilePrinter()
                
            }
            printersByID[key] = newPrinter
            return newPrinter
        }
    }
}
