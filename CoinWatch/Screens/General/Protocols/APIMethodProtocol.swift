//
//  APIMethodProtocol.swift
//  CoinWatch
//
//  Created by Anıl Kul on 19.04.2023.
//

import Alamofire
import Foundation

protocol APIMethodProtocol: URLRequestConvertible {
    var baseURL: String { get }
    var apiVersion: APIVersion  { get }
    var path: Path { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
}

extension APIMethodProtocol {
    var baseURL: String {
        return "\(Constants.URLs.baseURL)api\(apiVersion.rawValue)/"
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path.rawValue)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return try encoding.encode(urlRequest, with: parameters)
    }
}

struct APIMethod: APIMethodProtocol {
    var apiVersion: APIVersion = .v2
    var path: Path
    var method: HTTPMethod = .get
    var parameters: Parameters?
    var encoding: ParameterEncoding = JSONEncoding.default
}

enum Path: String {
    case ticker = "/ticker"
}

enum APIVersion: String {
    case v2 = "/v2"
}
