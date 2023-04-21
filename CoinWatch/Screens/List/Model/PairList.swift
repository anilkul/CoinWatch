//
//  PairList.swift
//  CoinWatch
//
//  Created by Anıl Kul on 19.04.2023.
//

import Foundation

// MARK: - PairList
struct PairList: Decodable {
    let data: [Pair]
    let success: Bool
    let message: String?
    let code: Int
}

// MARK: - Pair
struct Pair: Decodable {
    let pair: String
    let pairNormalized: String
    let last: Double
    let volume: Double
    let dailyPercent: Double
    let numeratorSymbol: String
}

class BasePresentationObject: BaseCellPresentable {
    var type: ItemType = .pair
}

class FavoritePresentationObject: BasePresentationObject, PairFavoritable, Codable {
    var name: String
    var last: String
    var symbol: String
    var dailyPercent: String
    var isFavorite: Bool
    var percentageColorName: String
    
    init(name: String = "", last: String = "", symbol: String = "", dailyPercent: String = "", type: ItemType = .pair, isFavorite: Bool = false, percentageColorName: String = "") {
        self.name = name
        self.last = last
        self.symbol = symbol
        self.dailyPercent = dailyPercent
        self.isFavorite = isFavorite
        self.percentageColorName = percentageColorName
        super.init()
        self.type = type
    }
}

final class PairPresentationObject: FavoritePresentationObject, PairPresentable {
    let volume: String
    let numeratorSymbol: String
    
    init(type: ItemType, pair: Pair) {
        volume = String(pair.volume)
        numeratorSymbol = pair.numeratorSymbol
        super.init()
        name = pair.pairNormalized.replacingOccurrences(of: "_", with: "/")
        percentageColorName = pair.dailyPercent.sign == .minus ? "DecreasedPercentageColor" : "IncreasedPercentageColor"
        symbol = pair.pair
        last = String(pair.last)
        dailyPercent = "%\(abs(pair.dailyPercent))"
        self.type = type
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

protocol BaseCellPresentable: AnyObject {
    var type: ItemType { get set }
}

protocol PairFavoritable: BaseCellPresentable {
    var name: String { get }
    var symbol: String { get }
    var last: String { get }
    var dailyPercent: String { get }
    var isFavorite: Bool { get set }
    var percentageColorName: String { get }
}

protocol PairPresentable: PairFavoritable {
    var volume: String { get }
    var numeratorSymbol: String { get }
}

protocol FavoriteListPresentable: BaseCellPresentable {
    var favorites: [PairFavoritable] { get set }
}

extension FavoriteListPresentable {
    var type: ItemType {
        return .favorite
    }
}

final class FavoriteListPresentationObject: BasePresentationObject, FavoriteListPresentable {
    var favorites: [PairFavoritable]
    
    init(type: ItemType, favorites: [PairFavoritable]) {
        self.favorites = favorites
        super.init()
        self.type = type
    }
}
