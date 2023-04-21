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
    weak var delegate: FavoriteCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func populate(presentationObject: PairFavoritable) {
        self.presentationObject = presentationObject
        nameLabel.text = presentationObject.name
        lastLabel.text = presentationObject.last
        dailyPercentLabel.text = presentationObject.dailyPercent
        dailyPercentLabel.textColor = UIColor(named: presentationObject.percentageColorName)
    }
    @IBAction func didTapCell(_ sender: UIButton) {
        delegate?.didReceive(action: .select, presentationObject: presentationObject)
    }
}

protocol FavoriteCellDelegate: AnyObject {
    func didReceive(action: CellAction, presentationObject: PairFavoritable)
}
