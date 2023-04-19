//
//  ListViewDataProvider.swift
//  CoinWatch
//
//  Created by Anıl Kul on 19.04.2023.
//

import Foundation

protocol ListViewDataProvidable {
    func requestPairs(_ completion: @escaping (APIResult<PairList>) -> Void)
}

class ListViewDataProvider: ListViewDataProvidable {
    // MARK: - Variables
    private let networkManager: NetworkManagable
    
    // MARK: - Initialization
    init(networkManager: NetworkManagable) {
        self.networkManager = networkManager
    }
    
    // MARK: - Request Operations
    final func requestPairs(_ completion: @escaping (APIResult<PairList>) -> Void) {
        let apiMethod: APIMethod = APIMethod(path: .ticker)
        networkManager.request(apiMethod, response: completion)
    }
}
