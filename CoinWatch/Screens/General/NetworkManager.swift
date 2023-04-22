//
//  NetworkManager.swift
//  CoinWatch
//
//  Created by Anıl Kul on 19.04.2023.
//

import Alamofire

protocol NetworkManagable {
    func request<T: Decodable>(
        _ apiRoute: APIMethodProtocol,
        response: @escaping (APIResult<T>) -> Void
    )
}

final class NetworkManager: NetworkManagable {
    // MARK: - Variables
    private let reachabilityManager: NetworkReachabilityManager? = NetworkReachabilityManager()
    
    // MARK: - Request
    func request<T: Decodable>(_ apiRoute: APIMethodProtocol,
                               response: @escaping (APIResult<T>) -> Void) {
        
        let dataRequest = AF.request(apiRoute)
        dataRequest.responseDecodable(completionHandler: self.transform(T.self, response))
        
    }
    
    // MARK: - Request Handling
    /// This method transforms AF's result type to ours
    private func transform<T: Decodable>(_ type: T.Type, _ response: @escaping (APIResult<T>) -> Void) -> (AFDataResponse<T>) -> Void {
        return { [weak self] result in
            self?.map(result, of: T.self, response)
        }
    }
    
    private func map<T: Decodable>(_ result: AFDataResponse<T>, of type: T.Type, _ response: @escaping (APIResult<T>) -> Void) {
        response(process(result, ofType: type))
    }
    
    private func process<T: Decodable>(_ result: AFDataResponse<T>, ofType type: T.Type) -> APIResult<T> {
        switch result.result {
        case .success(let response):
            return APIResult<T>.success(response)
        case .failure(let error):
            if reachabilityManager?.isReachable == false {
                return APIResult.failure(.noInternetConnection(errorMessage: "Could not connect to network"))
            }
            return APIResult.failure(.general(errorMessage: "Could not get the result from the performed request. ERROR: \(error)"))
        }
    }
}
