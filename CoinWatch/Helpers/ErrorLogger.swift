//
//  ErrorLogger.swift
//  CoinWatch
//
//  Created by Anıl Kul on 22.04.2023.
//

import Foundation

protocol ErrorLoggable {
    func logError(_ error: Error)
}

struct ErrorLogger: ErrorLoggable {
    func logError(_ error: Error) {
        #if DEBUG
        print("--------------------------")
        print("❌  ERROR  ❌\n⭕️ \(error)")
        print("--------------------------")
        #endif
    }
}


