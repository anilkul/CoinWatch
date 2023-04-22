//
//  DataProvider.swift
//  CoinWatch
//
//  Created by Anıl Kul on 19.04.2023.
//

import Foundation
import Alamofire


protocol DataProvidable {}

protocol DetailViewDataProvidable: DataProvidable {
    func fetchChart(for symbol: String, _ completion: @escaping (APIResult<ChartDataModel>) -> Void)
}

protocol ListViewDataProvidable: DataProvidable {
    func requestPairs(_ completion: @escaping (APIResult<PairList>) -> Void)
    func setfavorites(_ state: Bool, _ favoriteList: [FavoritePresentationObject], _ completion: VoidHandler?) throws
    func fetchFavoriteList(fetchOffset: Int?) -> [FavoritePresentationObject]
}

final class DataProvider: ListViewDataProvidable, DetailViewDataProvidable {
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
    
    func setfavorites(_ state: Bool, _ favoriteList: [FavoritePresentationObject], _ completion: VoidHandler?) throws {
        let favorites = favoriteList.map({ FavoriteStorableObject(favoritedPair: $0) })
        try persistencyManager.encode(newValue: favorites, for: .favorites)
        completion?()
    }
    
    func fetchFavoriteList(fetchOffset: Int?) -> [FavoritePresentationObject] {
        let favorites = persistencyManager.decode(for: .favorites, defaultValue: []).map({ FavoritePresentationObject(storedObject: $0) })
        return favorites
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
