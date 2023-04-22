//
//  CGSize+Extensions.swift
//  CoinWatch
//
//  Created by Anıl Kul on 22.04.2023.
//

import CoreGraphics

extension CGSize {
    static var negligibleSize: CGSize {
        return CGSize(width: 0, height: 1)
    }
}
