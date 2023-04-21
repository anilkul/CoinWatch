//
//  PairListCell.swift
//  CoinWatch
//
//  Created by Anıl Kul on 19.04.2023.
//

import UIKit

final class PairListCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var pairNameLabel: UILabel!
    @IBOutlet private weak var lastLabel: UILabel!
    @IBOutlet private weak var dailyPercentageLabel: UILabel!
    @IBOutlet private weak var volumeLabel: UILabel!
    @IBOutlet private weak var numeratorNameLabel: UILabel!
    
    // MARK: - Variables
    private var presentationObject: PairPresentable!
    weak var delegate: PairListCellDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - UI Operations
    func populate(with presentationObject: PairPresentable) {
        self.presentationObject = presentationObject
        favoriteButton.setTitle("", for: .normal)
        let imageName = presentationObject.isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        pairNameLabel.text = presentationObject.name
        lastLabel.text = presentationObject.last
        dailyPercentageLabel.text = presentationObject.dailyPercent
        dailyPercentageLabel.textColor = UIColor(named: presentationObject.percentageColorName)
        volumeLabel.text = presentationObject.volume
        numeratorNameLabel.text = presentationObject.numeratorSymbol
    }
    
    // MARK: - Actions
    @IBAction func didTapFavoriteButton(_ sender: UIButton) {
        delegate?.didReceive(action: .favorite, presentationObject: presentationObject)
    }
    
    @IBAction func didTapCell(_ sender: UIButton) {
        delegate?.didReceive(action: .select, presentationObject: presentationObject)
    }
}

protocol PairListCellDelegate: AnyObject {
    func didReceive(action: CellAction, presentationObject: PairPresentable)
}

enum CellAction {
    case select
    case favorite
}
