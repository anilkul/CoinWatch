//
//  ChartDataModel.swift
//  CoinWatch
//
//  Created by Anıl Kul on 21.04.2023.
//

// MARK: - ChartData
struct ChartDataModel: Decodable {
    let time: [Double]
    let close: [Double]
    
    enum CodingKeys: String, CodingKey {
        case time = "t"
        case close = "c"
    }
}
