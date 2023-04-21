//
//  FavoriteListCell.swift
//  CoinWatch
//
//  Created by Anıl Kul on 20.04.2023.
//

import UIKit

final class FavoriteCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var lastLabel: UILabel!
    @IBOutlet private weak var dailyPercentLabel: UILabel!
    
    // MARK: - Variables
    private var presentationObject: PairFavoritable!
    weak var delegate: FavoriteCellDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - UI Operations
    func populate(presentationObject: PairFavoritable) {
        self.presentationObject = presentationObject
        nameLabel.text = presentationObject.name
        lastLabel.text = presentationObject.last
        dailyPercentLabel.text = presentationObject.dailyPercent
        dailyPercentLabel.textColor = UIColor(named: presentationObject.percentageColorName)
    }
    
    // MARK: - Actions
    @IBAction func didTapCell(_ sender: UIButton) {
        delegate?.didReceive(action: .select, presentationObject: presentationObject)
    }
}

protocol FavoriteCellDelegate: AnyObject {
    func didReceive(action: CellAction, presentationObject: PairFavoritable)
}
