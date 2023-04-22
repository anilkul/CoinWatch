//
//  FavoriteListPresentationObject.swift
//  CoinWatch
//
//  Created by Anıl Kul on 22.04.2023.
//

final class FavoriteListPresentationObject: BasePresentationObject, FavoriteListPresentable {
    var favorites: [PairFavoritable]
    
    init(type: ItemType, favorites: [PairFavoritable]) {
        self.favorites = favorites
        super.init()
        self.type = type
    }
}
