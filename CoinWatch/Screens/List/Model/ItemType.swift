//
//  ItemType.swift
//  CoinWatch
//
//  Created by Anıl Kul on 22.04.2023.
//

import UIKit

enum ItemType: Int, Codable {
    case horizontal
    case pair
    case favorite
    
    var itemSize: CGSize {
        switch self {
        case .horizontal:
            let windowWidth = Constants.screenWidth
            return CGSize(width: windowWidth, height: 60)
        case .pair:
            let windowWidth = Constants.screenWidth
            return CGSize(width: windowWidth, height: 50)
        case .favorite:
            return CGSize(width: 60, height: 60)
        }
    }
}

