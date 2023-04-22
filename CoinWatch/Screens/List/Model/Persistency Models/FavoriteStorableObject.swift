//
//  FavoriteStorableObject.swift
//  CoinWatch
//
//  Created by Anıl Kul on 22.04.2023.
//

final class FavoriteStorableObject: PairFavoritable, Codable {
    var type: ItemType
    var name: String
    var symbol: String
    var last: String
    var dailyPercent: String
    var percentageColorName: String
    
    init(favoritedPair: PairFavoritable) {
        type = favoritedPair.type
        name = favoritedPair.name
        symbol = favoritedPair.symbol
        last = favoritedPair.last
        dailyPercent = favoritedPair.dailyPercent
        percentageColorName = favoritedPair.percentageColorName
    }
}

