//
//  APIMethodProtocol.swift
//  CoinWatch
//
//  Created by Anıl Kul on 19.04.2023.
//

import Alamofire
import Foundation

protocol APIMethodProtocol: URLRequestConvertible {
    var apiType: APIType { get }
    var baseURL: String { get }
    var apiVersion: APIVersion  { get }
    var path: Path { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
}

extension APIMethodProtocol {
    var baseURL: String {
        switch apiType {
        case .general:
            return "\(apiType.rawValue)api\(apiVersion.rawValue)/"
        case .graph:
            return "\(apiType.rawValue)\(apiVersion.rawValue)/"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path.rawValue)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return try encoding.encode(urlRequest, with: parameters)
    }
}

struct APIMethod: APIMethodProtocol {
    var apiType: APIType = .general
    var apiVersion: APIVersion = .v2
    var path: Path
    var method: HTTPMethod = .get
    var parameters: Parameters?
    var encoding: ParameterEncoding = URLEncoding.default
}

enum Path: String {
    case ticker = "ticker"
    case klines = "klines/history"
}

enum APIVersion: String {
    case v1 = "/v1"
    case v2 = "/v2"
}

enum APIType: String {
    case general = "https://api.btcturk.com/"
    case graph = "https://graph-api.btcturk.com"
}
