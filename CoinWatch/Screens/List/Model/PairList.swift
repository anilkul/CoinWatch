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

final class PairPresentationObject: BasePresentationObject, PairPresentable {
    var isFavorite: Bool
    let name: String
    let symbol: String
    let last: String
    let volume: String
    let dailyPercent: String
    let numeratorSymbol: String
    let percentageColorName: String
    
    init(pair: Pair) {
        isFavorite = false
        name = pair.pairNormalized.replacingOccurrences(of: "_", with: "/")
        symbol = pair.pair
        last = String(pair.last)
        volume = String(pair.volume)
        dailyPercent = "%\(abs(pair.dailyPercent))"
        numeratorSymbol = pair.numeratorSymbol
        percentageColorName = pair.dailyPercent.sign == .minus ? "DecreasedPercentageColor" : "IncreasedPercentageColor"
        super.init()
        type = .pair
    }
}

protocol BaseCellPresentable {
    var type: ItemType { get }
}

protocol HorizontalCellPresentable: BaseCellPresentable {
    
}

protocol PairPresentable: PairFavoritable {
    var isFavorite: Bool { get }
    var symbol: String { get }
    var volume: String { get }
    var numeratorSymbol: String { get }
    var percentageColorName: String { get }
}

protocol PairFavoritable: BaseCellPresentable {
    var name: String { get }
    var last: String { get }
    var dailyPercent: String { get }
}
