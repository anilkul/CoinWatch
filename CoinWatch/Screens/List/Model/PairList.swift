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
    var last: String = ""
    var symbol: String = ""
    var dailyPercent: String = ""
    var type: ItemType = .pair
    var isFavorite = false
}

final class PairPresentationObject: BasePresentationObject, PairPresentable {
    let name: String
    let volume: String
    let numeratorSymbol: String
    let percentageColorName: String
    
    init(pair: Pair) {
        name = pair.pairNormalized.replacingOccurrences(of: "_", with: "/")
        volume = String(pair.volume)
        numeratorSymbol = pair.numeratorSymbol
        percentageColorName = pair.dailyPercent.sign == .minus ? "DecreasedPercentageColor" : "IncreasedPercentageColor"
        super.init()
        symbol = pair.pair
        last = String(pair.last)
        dailyPercent = "%\(abs(pair.dailyPercent))"
        
        type = .pair
    }
}

protocol BaseCellPresentable {
    var type: ItemType { get }
    var symbol: String { get }
    var last: String { get }
    var dailyPercent: String { get }
    var isFavorite: Bool { get set }
}

protocol PairPresentable: BaseCellPresentable {
    var name: String { get }
    var volume: String { get }
    var numeratorSymbol: String { get }
    var percentageColorName: String { get }
}

protocol HorizontalCellPresentable: BaseCellPresentable {
    
}
