//
//  ListViewSectionHeader.swift
//  CoinWatch
//
//  Created by Anıl Kul on 20.04.2023.
//

import UIKit

class ListViewSectionHeader: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func populate(with title: String) {
        titleLabel.text = title
    }
}
