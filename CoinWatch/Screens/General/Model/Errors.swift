//
//  Errors.swift
//  CoinWatch
//
//  Created by Anıl Kul on 22.04.2023.
//

enum UIError: Error {
    case couldNotDefineController(identifier: String)
    case cellCouldNotBeCreated(className: String)
}

enum APIError: Error {
    case general(errorMessage: String)
    case apiError(error: Error)
    case noInternetConnection(errorMessage: String)
}

enum GeneralError: Error {
    case general(errorMessage: String)
    case enumInitializationError(rawValue: String)
    case invalidCast
}
