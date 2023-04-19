//
//  SectionType.swift
//  CoinWatch
//
//  Created by Anıl Kul on 18.04.2023.
//

import UIKit

enum SectionType: Int {
    case favorites
    case pairs
    
    var title: String {
        switch self {
        case .favorites:
            return "Favorites"
        case .pairs:
            return "Pairs"
        }
    }
    
    var headerSize: CGSize {
        let windowWidth = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.frame.width ?? UIScreen.main.bounds.width
        return CGSize(width: windowWidth, height: 60)
    }
}
