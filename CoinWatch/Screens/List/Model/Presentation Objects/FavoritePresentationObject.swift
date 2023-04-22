//
//  FavoritePresentationObject.swift
//  CoinWatch
//
//  Created by Anıl Kul on 22.04.2023.
//

final class FavoritePresentationObject: BasePresentationObject, PairFavoritable, Codable {
    let name: String
    let last: String
    let symbol: String
    let dailyPercent: String
    let percentageColorName: String
    
    init(pair: PairPresentable) {
        self.name = pair.name
        self.last = pair.last
        self.symbol = pair.symbol
        self.dailyPercent = pair.dailyPercent
        self.percentageColorName = pair.percentageColorName
        super.init()
        self.type = .favorite
    }
    
    init(storedObject: FavoriteStorableObject) {
        name = storedObject.name
        last = storedObject.last
        symbol = storedObject.symbol
        dailyPercent = storedObject.dailyPercent
        percentageColorName = storedObject.percentageColorName
        super.init()
        type = storedObject.type
    }
}
