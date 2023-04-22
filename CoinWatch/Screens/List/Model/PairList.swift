//
//  PairList.swift
//  CoinWatch
//
//  Created by Anıl Kul on 19.04.2023.
//

// MARK: - PairList
struct PairList: Decodable {
    let data: [Pair]
    let success: Bool
    let message: String?
    let code: Int
}
