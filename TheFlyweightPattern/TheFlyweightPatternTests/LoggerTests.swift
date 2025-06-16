//
//  LoggerTests.swift
//  TheFlyweightPatternTests
//
//  Created by Praveen Jangre on 16/06/2025.
//

import Testing
import XCTest
import TheFlyweightPattern

class LoggerTests: XCTestCase {

    func testFilePrinter() {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        let subsystem = "com.pj.test"
        let category = "UnitTest"
        let logger = Logger(subsystem: subsystem, category: category, printer: .file)
        logger.log("This is an error message", type: LogType.error)
        
        guard let filePrinter = logger.printer as? FilePrinter else {
            XCTFail("Invalid printer type")
            return
        }
        
        guard let logFileURL = filePrinter.logFileURL else {
            XCTFail("Could not retrieve log file URL")
            return
        }
        
        let log = try? String(contentsOf: logFileURL, encoding: .utf8)
        XCTAssertNotNil(log, "Could not retrieve log entry")
    }
    
    
    func testSharedPrinter() {
        let subsystem = "com.pj.test"
        let category = "UnitTest"
        let loggerA = Logger(subsystem: subsystem, category: category, printer: .console)
        let loggerB = Logger(subsystem: subsystem, category: category, printer: .console)
        
        XCTAssert(loggerA.printer === loggerB.printer, "Logger should share the same printer instance")
    }
    
    func testSharedPrinterDifferentType() {
        let subsystem = "com.pj.test"
        let category = "UnitTest"
        let loggerA = Logger(subsystem: subsystem, category: category, printer: .console)
        let loggerB = Logger(subsystem: subsystem, category: category, printer: .file)
        
        XCTAssertFalse(loggerA.printer === loggerB.printer, "Different type of Loggers should not share the same printer instance")
    }

}
