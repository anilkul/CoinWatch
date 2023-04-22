//
//  Pair.swift
//  CoinWatch
//
//  Created by Anıl Kul on 22.04.2023.
//

// MARK: - Pair
struct Pair: Decodable {
    let pair: String
    let pairNormalized: String
    let last: Double
    let volume: Double
    let dailyPercent: Double
    let numeratorSymbol: String
}
