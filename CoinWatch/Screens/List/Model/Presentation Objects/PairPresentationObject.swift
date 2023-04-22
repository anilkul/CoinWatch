//
//  PairPresentationObject.swift
//  CoinWatch
//
//  Created by Anıl Kul on 22.04.2023.
//

final class PairPresentationObject: BasePresentationObject, PairPresentable {
    let name: String
    let last: String
    let symbol: String
    let dailyPercent: String
    let volume: String
    let numeratorSymbol: String
    let percentageColorName: String
    var isFavorite: Bool = false
    
    init(pair: Pair) {
        volume = String(pair.volume)
        numeratorSymbol = pair.numeratorSymbol
        name = pair.pairNormalized.replacingOccurrences(of: "_", with: "/")
        percentageColorName = pair.dailyPercent.sign == .minus ? "DecreasedPercentageColor" : "IncreasedPercentageColor"
        symbol = pair.pair
        last = String(pair.last)
        dailyPercent = "%\(abs(pair.dailyPercent))"
        super.init()
        self.type = .pair
    }
}
