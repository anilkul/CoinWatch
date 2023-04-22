//
//  Constants.swift
//  CoinWatch
//
//  Created by Anıl Kul on 18.04.2023.
//

import UIKit

typealias VoidHandler = () -> Void

struct Constants {
    static var screenWidth: CGFloat {
        return UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.frame.width ?? UIScreen.main.bounds.width
    }
}
