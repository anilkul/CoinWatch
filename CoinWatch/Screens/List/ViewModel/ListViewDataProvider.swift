//
//  ListViewDataProvider.swift
//  CoinWatch
//
//  Created by Anıl Kul on 19.04.2023.
//

import Foundation
import Alamofire

protocol ListViewDataProvidable {
    func requestPairs(_ completion: @escaping (APIResult<PairList>) -> Void)
    func setfavorites(_ state: Bool, _ favoriteList: [FavoritePresentationObject], _ completion: VoidHandler?)
    func fetchFavoriteList(fetchOffset: Int?) -> [FavoritePresentationObject]
    func fetchChart(for symbol: String, _ completion: @escaping (APIResult<ChartDataModel>) -> Void)
}

final class ListViewDataProvider: ListViewDataProvidable {
    // MARK: - Variables
    private let networkManager: NetworkManagable
    private let persistencyManager: PersistencyManagerProtocol
    
    // MARK: - Initialization
    init(networkManager: NetworkManagable = NetworkManager(), persistencyManager: PersistencyManagerProtocol = PersistencyManager()) {
        self.networkManager = networkManager
        self.persistencyManager = persistencyManager
    }
    
    // MARK: - Request Operations
    func requestPairs(_ completion: @escaping (APIResult<PairList>) -> Void) {
        let apiMethod: APIMethod = APIMethod(path: .ticker)
        networkManager.request(apiMethod, response: completion)
    }
    
    func setfavorites(_ state: Bool, _ favoriteList: [FavoritePresentationObject], _ completion: VoidHandler?) {
        persistencyManager.encode(newValue: favoriteList, for: .favorites)
        completion?()
    }
    
    func fetchFavoriteList(fetchOffset: Int?) -> [FavoritePresentationObject] {
        return persistencyManager.decode(for: .favorites, defaultValue: [])
    }
    
    func fetchChart(for symbol: String, _ completion: @escaping (APIResult<ChartDataModel>) -> Void) {
        let to: Int = Int(Date().timeIntervalSince1970)
        let from = Int(Date.init(timeIntervalSinceNow: -(3600 * 24 * 3)).timeIntervalSince1970)
        let resolution: Double = 120
        let parameters: Parameters = [
            "to": to,
            "from": from,
            "resolution": resolution,
            "symbol": symbol
        ]
        let apiMethod: APIMethod = APIMethod(
            apiType: .graph,
            apiVersion: .v1,
            path: .klines,
            parameters: parameters
        )
        networkManager.request(apiMethod, response: completion)
    }
}
