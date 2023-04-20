//
//  PairListCell.swift
//  CoinWatch
//
//  Created by Anıl Kul on 19.04.2023.
//

import UIKit

final class PairListCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var favoriteIconImageView: UIImageView!
    @IBOutlet private weak var pairNameLabel: UILabel!
    @IBOutlet private weak var lastLabel: UILabel!
    @IBOutlet private weak var dailyPercentageLabel: UILabel!
    @IBOutlet private weak var volumeLabel: UILabel!
    @IBOutlet private weak var numeratorNameLabel: UILabel!
    
    // MARK: - Variables
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func populate(with presentationObject: PairPresentable) {
        favoriteIconImageView.image = UIImage(systemName: "star")
        pairNameLabel.text = presentationObject.name
        lastLabel.text = presentationObject.last
        dailyPercentageLabel.text = presentationObject.dailyPercent
        dailyPercentageLabel.textColor = UIColor(named: presentationObject.percentageColorName)
        volumeLabel.text = presentationObject.volume
        numeratorNameLabel.text = presentationObject.numeratorSymbol
    }
}
