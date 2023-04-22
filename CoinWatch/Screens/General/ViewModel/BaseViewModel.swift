//
//  BaseViewModel.swift
//  CoinWatch
//
//  Created by Anıl Kul on 22.04.2023.
//

import Foundation

class BaseViewModel: BaseViewModelProtocol {
    // MARK: - Variables
    var errorLogger: ErrorLoggable
    
    // MARK: - Initialization
    init(errorLogger: ErrorLoggable = ErrorLogger()) {
        self.errorLogger = errorLogger
    }
    
    // MARK: - Error Logging
    func log(error: Error) {
        errorLogger.logError(error)
    }
}
