//
//  Logger.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import Foundation

enum LoggerLevelType {
    case none
    case errors
    case all
}

class Logger {

    static var loggerLevel: LoggerLevelType = .errors
    
    static func log(error: Error?) {
        if let logString = error?.localizedDescription {
            if loggerLevel != .none {
                print(logString)
            }
        }
    }
    
    static func log(string: String?, type: LoggerLevelType) {
        guard let logString = string else { return }
        
        switch type {
        case .none:
            break
        case .errors:
            if loggerLevel != .none {
                print(logString)
            }
        case .all:
            if loggerLevel == .all {
                print(logString)
            }
        }
    }
}
