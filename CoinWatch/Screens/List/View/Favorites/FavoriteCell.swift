//
//  FavoriteListCell.swift
//  CoinWatch
//
//  Created by Anıl Kul on 20.04.2023.
//

import UIKit

class FavoriteCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    @IBOutlet weak var dailyPercentLabel: UILabel!
    
    private var presentationObject: PairFavoritable!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func populate(presentationObject: PairFavoritable) {
        self.presentationObject = presentationObject
        nameLabel.text = presentationObject.name
        lastLabel.text = presentationObject.last
        dailyPercentLabel.text = presentationObject.last
        dailyPercentLabel.textColor = UIColor(named: presentationObject.percentageColorName)
    }
}
