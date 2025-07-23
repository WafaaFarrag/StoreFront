//
//  Logger.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import Foundation

class Logger {
    static func log(_ message: String, file: String = #file, function: String = #function) {
        print("[\(file)]:\(function) -> \(message)")
    }
}
