//
//  ListViewDataProvider.swift
//  CoinWatch
//
//  Created by Anıl Kul on 19.04.2023.
//

import Foundation

protocol ListViewDataProvidable {
    func requestPairs(_ completion: @escaping (APIResult<PairList>) -> Void)
    func setfavorite(_ state: Bool, _ favoritedPair: FavoritePresentationObject, _ completion: VoidHandler?)
    func fetchFavoriteList(fetchOffset: Int?) -> [FavoritePresentationObject]
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
    
    func setfavorite(_ state: Bool, _ favoritedPair: FavoritePresentationObject, _ completion: VoidHandler?) {
        var favorites: [FavoritePresentationObject] = persistencyManager.decode(for: .favorites, defaultValue: [])
        switch state {
        case true:
            favorites.append(favoritedPair)
            persistencyManager.encode(newValue: favorites, for: .favorites)
        case false:
            favorites.removeAll(where: { $0.symbol == favoritedPair.symbol })
            persistencyManager.encode(newValue: favorites, for: .favorites)
        }
        completion?()
    }
    
    func fetchFavoriteList(fetchOffset: Int?) -> [FavoritePresentationObject] {
        return persistencyManager.decode(for: .favorites, defaultValue: [])
    }
}
