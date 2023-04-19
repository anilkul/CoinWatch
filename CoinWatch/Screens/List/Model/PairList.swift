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

struct PairPresentationObject: PairPresentable {
    var isFavorite: Bool
    let name: String
    let symbol: String
    let last: Double
    let volume: Double
    let dailyPercent: Double
    let numeratorSymbol: String
    
    init(pair: Pair) {
        isFavorite = false
        name = pair.pairNormalized.replacingOccurrences(of: "_", with: "/")
        symbol = pair.pair
        last = pair.last
        volume = pair.volume
        dailyPercent = pair.dailyPercent
        numeratorSymbol = pair.numeratorSymbol
    }
}

protocol PairPresentable: PairFavoritable {
    var isFavorite: Bool { get }
    var symbol: String { get }
    var volume: Double { get }
    var numeratorSymbol: String { get }
}

protocol PairFavoritable {
    var name: String { get }
    var last: Double { get }
    var dailyPercent: Double { get }
}
